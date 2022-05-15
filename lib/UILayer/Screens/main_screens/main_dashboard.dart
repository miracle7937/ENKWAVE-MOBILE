import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/cards_view.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/Intro_Screen/dash_board_widget_builder.dart';
import 'package:enk_pay_project/UILayer/utils/greeting_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with DashboardView {
  int _bottomNavIndex = 0;
  late DashBoardController _dashBoardController;
  @override
  Widget build(BuildContext context) {
    _dashBoardController = Provider.of<DashBoardController>(context)
      ..fetchDashboardData()
      ..setView = this;
    return SafeArea(
      child: EPScaffold(
        state: AppState(pageState: _dashBoardController.pageState),
        floatingActionButton: FloatingActionButton(
          child: Image.asset(EPImages.homeIcon),
          backgroundColor: EPColors.appMainLightColor,
          onPressed: () {
            print(_dashBoardController.featurePermissionModel.data!.first.id);
          },

          //params
        ),
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 2,
            ),
            Container(
              color: Colors.orangeAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      "Verify your account to enjoy our full service ",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: EPColors.appWhiteColor),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Image.asset(
                  EPImages.female,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  greetingMessage(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: EPColors.appBlackColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  _dashBoardController.fullName,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: EPColors.appBlackColor),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DashBoardCard(
              amount: _dashBoardController.getAccountBalance,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "What would you like to do?",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.w500, color: EPColors.appGreyColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: .8,
                padding: const EdgeInsets.all(6.0),
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                children: DashBoardBuilder.builder(
                        _dashBoardController.featurePermissionModel.data!.first,
                        context)
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
      // onTap: () {
      //   verifyPin(context, onSuccess: () {
      //     print("success true");
      //   });
      //   // Navigator.push(
      //   //     context, MaterialPageRoute(builder: (_) => const SetPinScreen()));
      // },
      onTap: introModel.onTap,
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
              style: Theme.of(context).textTheme.headline1!.copyWith(
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

  @override
  void onError(String message) {}

  @override
  void onSuccess() {}
}
