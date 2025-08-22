abstract class AiAgent {
  String get name;

  /// Lightweight intent check. Avoid network calls here.
  bool canHandle(String query, {Map<String, dynamic>? context});

  /// Perform the action and return a user-facing reply.
  Future<String> handle(String query, {Map<String, dynamic>? context});
}


