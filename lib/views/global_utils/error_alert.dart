import 'package:flutter/material.dart';

import 'global_export.dart';

class ErrorAlert extends StatelessWidget {
  const ErrorAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              CloseButtonWidget(),
            ],
          ),
          Image.asset('assets/images/error_img.png'),
          const SizedBox(height: 30),
          const Text(
            textAlign: TextAlign.center,
            'Error, Something went wrong. Please try again later',
          ),
          const SizedBox(height: 20),
          const ThemeButton(
            buttonText: 'Submit',
            width: 100,
          ),
        ],
      ),
    );
  }
}
