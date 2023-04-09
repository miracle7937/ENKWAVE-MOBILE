import 'package:flutter/material.dart';

import '../../../../Constant/colors.dart';

class SettingTabs extends StatelessWidget {
  final String image, title;
  final VoidCallback? onTap;
  const SettingTabs(
      {Key? key, required this.image, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Row(
                children: [
                  Image.asset(image),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: EPColors.appBlackColor),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
