import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../Constant/image.dart';
import '../../../DataLayer/controllers/dashboard_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../../utils/vesrion_dialog.dart';
import '../history/history_screen.dart';
import '../settings/setting_screen.dart';
import 'main_dashboard.dart';

class NavUI extends StatefulWidget {
  const NavUI({Key? key}) : super(key: key);

  @override
  State<NavUI> createState() => _NavUIState();
}

class _NavUIState extends State<NavUI> with DashboardView {
  late DashBoardController _dashBoardController;
  int _bottomNavIndex = 2;
  List<Widget> get getViews => [
        const HistoryScreen(),
        SettingScreen(
          onRefresh: () {
            refresh();
          },
        ),
        MainScreen(
          onRefresh: () {
            refresh();
          },
        ),
      ];
  refresh() {
    _dashBoardController.fetchDashboardData(refresh: true);
  }

  List<String> title = [
    "History",
    "Settings",
    "Home",
  ];

  @override
  Widget build(BuildContext context) {
    _dashBoardController =
        Provider.of<DashBoardController>(context, listen: true)
          ..fetchDashboardData()
          ..setView = this;
    return EPScaffold(
      appBar: EPAppBar(
        centerTitle: true,
        title: Text(title[_bottomNavIndex].toUpperCase()),
        leading: Container(),
      ),
      state: AppState(pageState: _dashBoardController.pageState),
      floatingActionButton: FloatingActionButton(
        child: Image.asset(EPImages.homeIcon),
        backgroundColor: EPColors.appMainColor,
        onPressed: () async {
          setState(() {
            _bottomNavIndex = 2;
          });
        },
      ),
      builder: (context) => getViews[_bottomNavIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [Icons.toc_rounded, Icons.person],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        iconSize: 40,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
        },
        //other params
      ),
    );
  }

  @override
  void onError(String message) {}

  @override
  void onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onVersionCheck() {
    versionDialog(context,
        androidLink: _dashBoardController.appSettings?.googleUrl,
        iosLink: _dashBoardController.appSettings?.iosUrl);
  }
}
