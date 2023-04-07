import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constant/colors.dart';

class EPLinearProgressBar extends StatelessWidget {
  final bool? loading;
  const EPLinearProgressBar({Key? key, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return LinearProgressIndicator(
        minHeight: 5,
        color: EPColors.appMainColor,
        backgroundColor: EPColors.appMainLightColor,
      );
    } else {
      return Container();
    }
  }
}
