import 'package:flutter/material.dart';
import 'package:sterling/views/common_screens/signup_screen/signup_screen.dart';

class CreateAccButton extends StatelessWidget {
  const CreateAccButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const SignupScreen(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 42,
        height: 50,
        decoration: BoxDecoration(
          //color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xff8f8e8e),
          ),
        ),
        child: const Center(
          child: Text(
            'Create Account',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
