import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeModelService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  GenerativeModelService(String apiKey) {
    // 🔥 THE UPGRADE: We tell the AI exactly how to behave for a screen reader
    final systemInstruction = Content.system(
        "You are 'Virtual Eye', an AI accessibility assistant directly helping a visually impaired user. "
            "Keep your answers extremely concise, conversational, and clear. "
            "Do NOT use markdown formatting like asterisks, bolding, or bullet points, as they sound unnatural on screen readers. "
            "Speak directly to the user as a helpful guide."
    );

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: systemInstruction, // Injecting the persona
    );

    _chatSession = _model.startChat();
  }

  /// Returns a safe stream of text strings, catching any network crashes
  Stream<String> sendMessageStream(String message) async* {
    try {
      final responseStream = _chatSession.sendMessageStream(Content.text(message));

      await for (final chunk in responseStream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      debugPrint("Gemini API Error: $e");
      // Fallback message so the screen reader can inform the user of the error
      yield "I am having trouble connecting to the network right now. Please check your internet connection.";
    }
  }
}