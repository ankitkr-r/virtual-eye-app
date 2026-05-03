import 'package:flutter/material.dart';
import 'package:virtual_eye/l10n/app_localizations.dart';

class PopUpForLanguageSelection extends StatefulWidget {
  final String initialLanguage; // 1. Renamed and made final
  final bool changingLanguage;
  final Function(String) onSubmit; // 2. Added type safety

  const PopUpForLanguageSelection({
    super.key,
    required this.onSubmit,
    required this.changingLanguage,
    this.initialLanguage = 'en'
  });

  @override
  State<PopUpForLanguageSelection> createState() => _PopUpForLanguageSelectionState();
}

class _PopUpForLanguageSelectionState extends State<PopUpForLanguageSelection> {
  late String _currentLanguage; // 3. Local state variable

  @override
  void initState() {
    super.initState();
    // Initialize the local state with the value passed from parent
    _currentLanguage = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 0,
      insetPadding: const EdgeInsets.all(40),
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  Widget textUnderline(Widget child) => Container(
    padding: const EdgeInsets.only(bottom: 5),
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF494C8A), width: 1))
    ),
    child: child,
  );

  Widget itemViewForInvoiceType(
      BuildContext context, String text, String languageCode) {
    bool isSelected = _currentLanguage == languageCode;
    return ListTile(
      onTap: () {
        setState(() {
          _currentLanguage = languageCode;
        });
      },
      contentPadding: EdgeInsets.zero,
      title: Text(text),
      trailing: Icon(
        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
        color: isSelected ? Colors.green : const Color(0xFFBABABA),
        size: isSelected ? 30 : 25,
      ),
    );
  }

  Widget _buildChild(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // Important for Dialogs
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        textUnderline(
          Text(
            AppLocalizations.of(context)?.selectLanguage ?? "Select Language",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF494C8A)
            ),
          ),
        ),
        const SizedBox(height: 10),

        // List Items
        itemViewForInvoiceType(context, "English", "en"),
        itemViewForInvoiceType(context, "हिन्दी (Hindi)", "hi"),
        itemViewForInvoiceType(context, "台灣 (Chinese)", "zh"),

        const SizedBox(height: 20),

        // Submit Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 45),
            backgroundColor: const Color(0xFF494C8A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: widget.changingLanguage
              ? null
              : () => widget.onSubmit(_currentLanguage), // Pass the local state
          child: widget.changingLanguage
              ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          )
              : Text(
            AppLocalizations.of(context)?.changeLanguage ?? "Change Language",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}