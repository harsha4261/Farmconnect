import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../app_config.dart';
import '../market/market_price_service.dart';

class PricePredictionResult {
  final double predictedPrice;
  final String currency;
  final String explanation;

  PricePredictionResult({
    required this.predictedPrice,
    required this.currency,
    required this.explanation,
  });
}

class CropPricePredictionService {
  final MarketPriceService _marketPriceService;
  final GenerativeModel? _model;

  CropPricePredictionService({MarketPriceService? marketService})
      : _marketPriceService = marketService ?? MarketPriceService(),
        _model = (AppConfig.instance?.geminiApiKey?.isNotEmpty ?? false)
            ? GenerativeModel(
                model: 'gemini-1.5-flash',
                apiKey: AppConfig.instance!.geminiApiKey!,
              )
            : null;

  /// Fetch recent market data and predict near-term price
  /// Returns null if not enough data or AI not configured
  Future<PricePredictionResult?> predict({
    required String commodity,
    required String market,
    String currency = 'INR',
  }) async {
    final data = await _marketPriceService.getPrice(
      commodity: commodity,
      market: market,
    );
    if (_model == null || data == null) return null;

    final recent = data['recent'] as List<dynamic>? ?? [];
    if (recent.length < 5) return null;
    final series = recent
        .map((e) => {
              'date': e['date'],
              'price': (e['price'] as num).toDouble(),
            })
        .toList();

    final prompt = Content.text(
        'You are a market analyst. Using this time series of $commodity prices in $market, '
        'predict the average spot price for tomorrow in $currency. '
        'Return ONLY a JSON object with keys predicted and explanation. '
        'Data: ${series.toString()}');

    final response = await _model.generateContent([prompt]);
    final text = response.text ?? '';
    // Very simple JSON pull; fall back to number extraction
    final priceMatch = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(text);
    final predicted = double.tryParse(priceMatch?.group(1) ?? '') ??
        (series.last['price'] as double);
    final explanation = text.isEmpty
        ? 'Predicted using recent average and momentum.'
        : text;
    return PricePredictionResult(
      predictedPrice: predicted,
      currency: currency,
      explanation: explanation,
    );
  }

  /// Simple local smoothing estimate as a backup if AI is unavailable
  static double fallbackEstimate(List<double> prices) {
    if (prices.isEmpty) return 0;
    if (prices.length < 3) return prices.last;
    final weights = [0.2, 0.3, 0.5];
    final n = prices.length;
    return max(0,
        prices[n - 3] * weights[0] + prices[n - 2] * weights[1] + prices[n - 1] * weights[2]);
  }
}


