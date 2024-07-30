import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String approveText;
  final String cancelText;
  final String content;
  final void Function() onApprove;
  // final void Function() onCancel;

  const ConfirmDialogWidget({ super.key, 
    this.approveText = 'OK', 
    this.cancelText = 'Cancel', 
    this.content = 'Confirm...?', 
    required this.onApprove
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Icon(Icons.info),
      content: Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
            backgroundColor: const Color.fromARGB(241, 243, 74, 62),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
          ),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: onApprove, 
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
          ),
          child: Text(approveText),
        ),
      ],
    );
  }
}