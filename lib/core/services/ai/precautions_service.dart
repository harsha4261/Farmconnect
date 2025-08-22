import 'weather_service.dart';

class PrecautionsService {
  final WeatherService _weatherService = WeatherService();

  Future<List<String>> getPrecautions({
    required String crop,
    double? lat,
    double? lon,
  }) async {
    String summary = '';
    if (lat != null && lon != null) {
      final wx = await _weatherService.forecast(lat: lat, lon: lon, locale: 'en');
      summary = wx?.summary ?? '';
    }

    final advisories = <String>[];
    final s = summary.toLowerCase();

    if (s.contains('rain')) {
      advisories.add('Avoid spraying chemicals before rain; reschedule applications.');
      advisories.add('Ensure drainage around fields to prevent waterlogging.');
    }
    if (s.contains('heat') || s.contains('hot')) {
      advisories.add('Irrigate early morning or late evening to reduce evapotranspiration.');
    }
    if (s.contains('wind')) {
      advisories.add('Stake/secure tender plants; avoid spraying in high winds.');
    }

    if (advisories.isEmpty) {
      advisories.add('Scout ${crop.toLowerCase()} fields for pests/disease symptoms twice this week.');
      advisories.add('Maintain recommended spacing and remove heavily infected leaves.');
      advisories.add('Plan nutrient application based on growth stage and local guidance.');
    }

    return advisories;
  }
}


