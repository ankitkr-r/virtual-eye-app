// import 'package:flutter/material.dart';
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
// import 'package:virtual_eye/l10n/app_localizations.dart';
// class AccessibleDetectionView extends StatelessWidget {
//   final DetectedObject? currentObject;
//
//   const AccessibleDetectionView({super.key, required this.currentObject});
//
//   @override
//   Widget build(BuildContext context) {
//     if (currentObject == null || currentObject!.labels.isEmpty) {
//       return Semantics(
//         // Safely falls back to English if the translation isn't ready
//         label: AppLocalizations.of(context)?.scanningEnvironment ?? "Scanning environment",
//         child: const SizedBox.expand(),
//       );
//     }
//
//     final String objectName = currentObject!.labels.first.text;
//
//     return Semantics(
//       // Safely falls back to English if the translation isn't ready
//       label: AppLocalizations.of(context)?.objectDetected(objectName) ?? "$objectName detected",
//       container: true,
//       liveRegion: true,
//       child: Container(
//         alignment: Alignment.bottomCenter,
//         padding: const EdgeInsets.only(bottom: 50.0),
//         child: Text(
//           objectName,
//           style: const TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             backgroundColor: Colors.black54, // High contrast
//           ),
//         ),
//       ),
//     );
//   }
// }