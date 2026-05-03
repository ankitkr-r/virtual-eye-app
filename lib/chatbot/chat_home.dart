import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:virtual_eye/l10n/app_localizations.dart';
import 'chat_view_model.dart';

class ChatHome extends StatefulWidget {
  final ChatViewModel viewModel;

  const ChatHome({super.key, required this.viewModel});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  String _spokenWords = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _speakInitialGreeting();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    // FIX 1: Force the app to wait until the AI is completely finished talking
    // before turning on the mic (Prevents audio collision)
    await _flutterTts.awaitSpeakCompletion(true);
  }

  void _speakInitialGreeting() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Reads out loud so the user knows what to do
    await _flutterTts.speak("Voice assistant opened. Double tap anywhere on the screen to ask a question.");
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    // Rule 4: Safely dispose the viewModel
    widget.viewModel.dispose();
    super.dispose();
  }

  void _handleScreenTap() async {
    if (widget.viewModel.isLoading) return; // Don't interrupt if the AI is still thinking

    if (_isListening) {
      // 1. Stop listening
      await _speechToText.stop();
      setState(() => _isListening = false);

      // 2. Send the voice command to the AI
      if (_spokenWords.trim().isNotEmpty) {
        _sendToGeminiAndSpeak(_spokenWords);
      } else {
        // FIX 2: Accessibility Fallback. If the STT failed to hear them, TELL THEM.
        await _flutterTts.speak("I didn't catch that. Please tap again and ask your question.");
      }
    } else {
      // 1. Tell the user we are about to listen
      await _flutterTts.stop();
      await _flutterTts.speak("Listening...");

      // NOTE: Because we added awaitSpeakCompletion(true) in initSpeech,
      // the code naturally pauses right here until "Listening..." is fully spoken!

      setState(() {
        _spokenWords = "";
        _isListening = true;
      });

      // 2. Capture the user's voice
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _spokenWords = result.recognizedWords;
          });
        },
        // FIX 3: Add a generous pause duration so it doesn't cut the user off
        pauseFor: const Duration(seconds: 5),
      );
    }
  }

  void _sendToGeminiAndSpeak(String text) {
    widget.viewModel.sendMessage(
        text,
        onComplete: () async {
          // 3. Read the AI's answer out loud!
          final aiResponse = widget.viewModel.messages.last.text;
          await _flutterTts.speak(aiResponse);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final String titleText = l10n?.chatbotTitle ?? "Voice Assistant";

    // Rule 2: Accessibility First. Semantics explains the massive invisible button.
    return Semantics(
      label: "Double tap anywhere to speak to the AI assistant.",
      button: true,
      child: GestureDetector(
        onTap: _handleScreenTap,
        child: Scaffold(
          appBar: AppBar(title: Text(titleText)),
          body: Column(
            children: [
              Expanded(
                child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (context, _) {
                      return ListView.builder(
                        itemCount: widget.viewModel.messages.length,
                        itemBuilder: (context, index) {
                          final message = widget.viewModel.messages[index];
                          return ExcludeSemantics( // Excluded because TTS will read it out loud anyway
                            child: ListTile(
                              title: Align(
                                alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: message.isUser ? Colors.blue[100] : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(message.text),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                ),
              ),
              // Visual indicator (No Text Field!)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                color: _isListening ? Colors.red.withOpacity(0.1) : Colors.transparent,
                child: Column(
                  children: [
                    if (widget.viewModel.isLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text("Assistant is thinking...", style: const TextStyle(fontSize: 18)),
                    ] else ...[
                      Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        size: 48,
                        color: _isListening ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isListening ? _spokenWords : "Tap anywhere to speak",
                        style: TextStyle(
                            fontSize: 20,
                            color: _isListening ? Colors.red : Colors.grey,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}