import 'package:image_picker/image_picker.dart';
import '../price_prediction_service.dart';
import '../weather_service.dart';
import '../disease_detection_service.dart';

class CropAgent {
  final String cropName;
  final String? defaultMarket;
  final double? lat;
  final double? lon;

  final CropPricePredictionService _priceService = CropPricePredictionService();
  final WeatherService _weatherService = WeatherService();
  final DiseaseDetectionService _diseaseService = DiseaseDetectionService();

  CropAgent({required this.cropName, this.defaultMarket, this.lat, this.lon});

  Future<String> handle(String query, {XFile? image}) async {
    final q = query.toLowerCase();

    // Price intent
    if (q.contains('price') || q.contains('market')) {
      final market = defaultMarket ?? 'local market';
      final res = await _priceService.predict(
        commodity: cropName,
        market: market,
        currency: 'INR',
      );
      if (res == null) {
        return 'I could not fetch enough data to predict the $cropName price for $market.';
      }
      return 'Predicted $cropName price for $market: ${res.predictedPrice.toStringAsFixed(2)} ${res.currency}.\n${res.explanation}';
    }

    // Weather intent
    if (q.contains('weather') || q.contains('rain') || q.contains('forecast')) {
      if (lat == null || lon == null) {
        return 'Share your farm location to get a 3-day field forecast.';
      }
      final res = await _weatherService.forecast(lat: lat!, lon: lon!, locale: 'en');
      return res?.summary ?? 'Weather service unavailable right now.';
    }

    // Disease intent
    if (q.contains('disease') || q.contains('leaf') || image != null) {
      if (image == null) {
        return 'Please upload a clear photo of the affected plant for diagnosis.';
      }
      final txt = await _diseaseService.detect(image, crop: cropName, locale: 'en');
      return txt ?? 'Could not analyze the image. Try another photo with better lighting.';
    }

    // Help fallback
    return 'I can help with $cropName price prediction, disease diagnosis (with photo), and 3-day weather forecast. Ask me, e.g., "$cropName price in Guntur", "weather for my farm", or upload a leaf photo.';
  }
}


