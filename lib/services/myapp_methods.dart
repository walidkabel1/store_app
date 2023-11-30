import 'package:flutter/material.dart';
import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/widgets/subtitle_text.dart';
import 'package:store_app/widgets/title_text.dart';

class MyappMethods {
  static Future<void> ShowErrorOrWarningDialog(
      {required BuildContext context,
      required String subtitle,
      required Function function,
      bool iserror = true}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey.shade300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  assetsManager.warning,
                  height: 60,
                  width: 60,
                ),
                SizedBox(
                  height: 16,
                ),
                TitleTextWidget(
                  label: subtitle,
                  maxlines: 3,
                  fontSize: 14,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !iserror,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    TextButton(
                        onPressed: () {
                          function();
                        },
                        child: Text("Ok",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)))
                  ],
                )
              ],
            ),
          );
        });
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: TitleTextWidget(
                label: "Choose option",
              ),
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text(
                    "Camera",
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text(
                    "Gallery",
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text(
                    "Remove",
                  ),
                ),
              ],
            )),
          );
        });
  }
}
