import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String message;

  SuccessDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Berhasil'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  ErrorDialog({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Gagal'),
      content: Text('Terjadi kesalahan: $errorMessage'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
