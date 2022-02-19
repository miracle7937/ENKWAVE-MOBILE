import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards_view.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EPScaffold(
        floatingActionButton: FloatingActionButton(
          child: Image.asset(EPImages.homeIcon),
          backgroundColor: EPColors.appMainLightColor,
          onPressed: () {},

          //params
        ),
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(EPImages.female),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Good Morning",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.bold, color: EPColors.appBlackColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Tolulope Adejimi",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.w600, color: EPColors.appBlackColor),
            ),
            const SizedBox(
              height: 10,
            ),
            const DashBoardCard(),
            const SizedBox(
              height: 15,
            ),
            Text(
              "What would you like to do?",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w500, color: EPColors.appGreyColor),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: .8,
                padding: const EdgeInsets.all(6.0),
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                children: ConstantString.dashBoardData
                    .map<Widget>((e) => cardUI(e))
                    .toList(),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const [Icons.toc_rounded, Icons.person],
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          iconSize: 40,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          //other params
        ),
      ),
    );
  }

  cardUI(IntroModel introModel) {
    return ContainButton(
      borderRadius: BorderRadius.circular(15.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              introModel.image,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              introModel.title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w700, color: EPColors.appBlackColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              introModel.subTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
