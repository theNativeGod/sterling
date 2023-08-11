import 'package:flutter/material.dart';
import '../../global_utils/global_export.dart';
import 'utils/export.dart';

class QuickQuestionsScreen extends StatelessWidget {
  const QuickQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:  BackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.5,
          vertical: 20,
        ),
        child: SizedBox(
          height: height * .8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Questions',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: width - 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.5, vertical: 20),
                child: Column(
                  children: [
                    QuestionDropDown(
                      width: width,
                      heading: 'Ride Session',
                      dropText: 'Ride type',
                    ),
                    const SizedBox(height: 15),
                    QuestionDropDown(
                      width: width,
                      heading: 'Ride Session',
                      dropText: 'Ride type',
                    ),
                    const SizedBox(height: 15),
                    QuestionDropDown(
                      width: width,
                      heading: 'Ride Session',
                      dropText: 'Ride type',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Skip',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  ThemeButton(
                    buttonText: 'Submit',
                    width: width * .3,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
