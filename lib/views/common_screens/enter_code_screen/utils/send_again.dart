import 'package:flutter/material.dart';

class SendAgain extends StatelessWidget {
  const SendAgain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            elevation: 6,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            content: Center(
              child: Text(
                'COMMING SOON',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: const Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
              text: 'Send code again in\t',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: '00:20',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
