import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 🔥 1. Added dotenv import

// 1. A simple class to hold our message data
class ChatModel {
  final String text;
  final bool isUser;

  ChatModel({required this.text, required this.isUser});
}

// 2. The ViewModel that manages State and connects to Gemini
class ChatViewModel extends ChangeNotifier {
  // ⚠️ Notice: The hardcoded _apiKey line has been completely removed!

  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  final List<ChatModel> messages = [];
  bool isLoading = false;

  StreamSubscription<GenerateContentResponse>? _chatSubscription;

  ChatViewModel() {
    // 🔥 2. We securely grab the key from your hidden .env file right here
    final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // Upgraded to Gemini 2.5 Flash for the fastest response times
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey, // 🔥 3. Pass the secure variable here
    );
    // FIX: Properly initialize the chat session so it remembers conversation history and doesn't crash!
    _chatSession = _model.startChat();
  }

  // FIX: Added 'onComplete' callback specifically for our Voice Assistant UI
  void sendMessage(String text, {VoidCallback? onComplete}) {
    if (text.trim().isEmpty) return;

    // 1. Add user message and a placeholder for the AI to the UI
    messages.add(ChatModel(text: text, isUser: true));
    messages.add(ChatModel(text: "", isUser: false));
    isLoading = true;
    notifyListeners(); // Tells the UI to update

    // Clean up previous stream if the user talks again quickly
    _chatSubscription?.cancel();

    // 2. Stream the response from Gemini API chunk by chunk
    _chatSubscription = _chatSession.sendMessageStream(Content.text(text)).listen(
            (event) {
          if (event.text != null) {
            final lastIndex = messages.length - 1;
            // Append the new text to the AI's current message
            messages[lastIndex] = ChatModel(
              text: messages[lastIndex].text + event.text!,
              isUser: false,
            );
            notifyListeners();
          }
        },
        onDone: () {
          isLoading = false;
          notifyListeners();
          // 3. FIX: Tell the UI that generation is done so it can read it out loud!
          if (onComplete != null) onComplete();
        },
        // inside sendMessage...
        onError: (error) {
          isLoading = false;

          // DO THIS: Print the full error to your terminal
          print("GEMINI DEBUG ERROR: $error");

          String friendlyError = "Network error. Please try again.";

          if (error.toString().contains("403")) {
            friendlyError = "API Key Error: Please check your key in AI Studio.";
          } else if (error.toString().contains("404")) {
            friendlyError = "Region Error: Gemini may be restricted in your country.";
          } else if (error.toString().contains("429")) {
            friendlyError = "Too many messages. Please wait 60 seconds.";
          }

          messages.last = ChatModel(text: friendlyError, isUser: false);
          notifyListeners();
          if (onComplete != null) onComplete();
        }
    );
  }

  @override
  void dispose() {
    // Clean up memory leaks when the chat screen closes
    _chatSubscription?.cancel();
    super.dispose();
  }
}