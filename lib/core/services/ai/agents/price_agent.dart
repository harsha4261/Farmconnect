import 'package:collection/collection.dart';
import 'agent.dart';
import '../price_prediction_service.dart';

class PriceAgent implements AiAgent {
  @override
  String get name => 'PriceAgent';

  final CropPricePredictionService _svc = CropPricePredictionService();

  @override
  bool canHandle(String query, {Map<String, dynamic>? context}) {
    final q = query.toLowerCase();
    return ['price', 'market', 'rate'].any((k) => q.contains(k)) &&
        (context?['crop'] != null || q.contains('tomato') || q.contains('rice'));
  }

  @override
  Future<String> handle(String query, {Map<String, dynamic>? context}) async {
    final crop = (context?['crop'] as String?) ?? _extractCrop(query) ?? 'crop';
    final market = (context?['market'] as String?) ?? 'local market';
    final res = await _svc.predict(commodity: crop, market: market, currency: 'INR');
    if (res == null) return 'Could not predict $crop price for $market right now.';
    return 'Predicted $crop price for $market: ${res.predictedPrice.toStringAsFixed(2)} ${res.currency}.\n${res.explanation}';
  }

  String? _extractCrop(String q) {
    final crops = ['tomato', 'rice', 'wheat', 'cotton', 'chilli'];
    return crops.firstWhereOrNull((c) => q.toLowerCase().contains(c));
  }
}


