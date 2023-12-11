import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class VerificationDialog extends StatefulWidget {
  const VerificationDialog({Key? key});

  @override
  State<VerificationDialog> createState() => _VerificationDialogState();
}

class _VerificationDialogState extends State<VerificationDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                animType: AnimType.leftSlide,
                headerAnimationLoop: false,
                dialogType: DialogType.success,
                showCloseIcon: true,
                title: 'Success',
                desc: 'Dialog description here...',
                btnOkOnPress: () {
                  debugPrint('OnClick');
                },
                btnOkIcon: Icons.check_circle,
                onDismissCallback: (type) {
                  debugPrint('Dialog Dismiss from callback $type');
                },
              ).show();
            },
            child: Text('Show Success Dialog'),
          ),
        ],
      ),
    );
  }
}
