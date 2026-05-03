import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:virtual_eye/library/system_settings/system_settings.dart';
import 'package:virtual_eye/l10n/app_localizations.dart';

class ShowOfflinePopup extends StatelessWidget {
  final bool showOfflineMode;

  const ShowOfflinePopup({super.key, 
    this.showOfflineMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildChild(context));
  }

  _buildChild(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SvgPicture.asset(
              "images/internet-down-image.svg",
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              localizations?.internetOffMessage ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  minimumSize: const Size(double.infinity, 50)),
              child: Text(
                localizations?.turnOnInternet ?? "",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              onPressed: () => SystemSettings.dataRoaming(),
            )
          ],
        ),
      ),
    );
  }
}
