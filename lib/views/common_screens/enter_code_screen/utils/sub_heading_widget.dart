import 'package:flutter/material.dart';

import '../../../global_utils/sub_heading.dart';

class SubHeadingWidget extends StatelessWidget {
  const SubHeadingWidget({
    this.mobile,
    super.key,
  });

  final String? mobile;

  @override
  Widget build(BuildContext context) {
    return SubHeading(
      subHeadingText:
          'We\'ve sent an SMS with an activation code to your phone',
      textAlign: TextAlign.left,
      spanText: '+91${mobile}',
    );
  }
}
