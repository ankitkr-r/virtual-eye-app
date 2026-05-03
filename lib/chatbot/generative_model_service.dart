import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeModelService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  GenerativeModelService(String apiKey) {
    // Initializing Gemini 2.5 Flash
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
    _chatSession = _model.startChat();
  }

  /// Returns a stream of responses for a real-time typing effect
  Stream<GenerateContentResponse> sendMessageStream(String message) {
    return _chatSession.sendMessageStream(Content.text(message));
  }
}