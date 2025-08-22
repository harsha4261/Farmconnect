import 'package:image_picker/image_picker.dart';
import 'agent.dart';
import 'price_agent.dart';
import 'weather_agent.dart';
import 'disease_agent.dart';
import '../../../services/location/location_service.dart';

class MultiAgentOrchestrator {
  final List<AiAgent> _agents = [
    PriceAgent(),
    WeatherAgent(),
    DiseaseAgent(),
  ];

  /// Route a user query + optional context (crop, market, lat, lon, image)
  Future<String> route(String query, {
    String? crop,
    String? market,
    double? lat,
    double? lon,
    XFile? image,
  }) async {
    // Auto-fetch GPS if not provided
    if (lat == null || lon == null) {
      final pos = await LocationService.getCurrentPosition();
      if (pos != null) {
        lat = pos.latitude;
        lon = pos.longitude;
      }
    }

    final context = <String, dynamic>{
      if (crop != null) 'crop': crop,
      if (market != null) 'market': market,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (image != null) 'image': image,
    };

    for (final agent in _agents) {
      if (agent.canHandle(query, context: context)) {
        return await agent.handle(query, context: context);
      }
    }
    return 'I can help with crop prices, disease diagnosis (photo), and 3-day weather. Try asking “price in <market>”, “weather”, or upload a plant photo.';
  }
}


