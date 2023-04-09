import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../../Constant/image.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Lottie.asset(EPImages.loader),
      ),
    );
  }
}
