import 'agent.dart';
import '../weather_service.dart';

class WeatherAgent implements AiAgent {
  @override
  String get name => 'WeatherAgent';

  final WeatherService _svc = WeatherService();

  @override
  bool canHandle(String query, {Map<String, dynamic>? context}) {
    final q = query.toLowerCase();
    return q.contains('weather') || q.contains('forecast') || q.contains('rain');
  }

  @override
  Future<String> handle(String query, {Map<String, dynamic>? context}) async {
    final lat = context?['lat'] as double?;
    final lon = context?['lon'] as double?;
    if (lat == null || lon == null) {
      return 'Share your farm location to get a 3-day field forecast.';
    }
    final res = await _svc.forecast(lat: lat, lon: lon, locale: 'en');
    return res?.summary ?? 'Weather service unavailable.';
  }
}


