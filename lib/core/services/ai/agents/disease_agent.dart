import 'package:image_picker/image_picker.dart';
import 'agent.dart';
import '../disease_detection_service.dart';

class DiseaseAgent implements AiAgent {
  @override
  String get name => 'DiseaseAgent';

  final DiseaseDetectionService _svc = DiseaseDetectionService();

  @override
  bool canHandle(String query, {Map<String, dynamic>? context}) {
    final q = query.toLowerCase();
    final hasImage = context?['image'] is XFile;
    return hasImage || q.contains('disease') || q.contains('leaf') || q.contains('spot');
  }

  @override
  Future<String> handle(String query, {Map<String, dynamic>? context}) async {
    final image = context?['image'] as XFile?;
    final crop = (context?['crop'] as String?) ?? 'crop';
    if (image == null) {
      return 'Please upload a clear photo of the affected plant for diagnosis.';
    }
    final txt = await _svc.detect(image, crop: crop, locale: 'en');
    return txt ?? 'Could not analyze the image. Try another photo with better lighting.';
  }
}


