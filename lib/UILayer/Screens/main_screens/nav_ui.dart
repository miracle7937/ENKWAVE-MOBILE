import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/app_theme.dart';
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
  int _tabIndex = 2;

  List<Widget> get _pages => [
        const HistoryScreen(),
        SettingScreen(onRefresh: refresh),
        MainScreen(onRefresh: refresh),
      ];

  static const _titles = ['History', 'Settings', 'Home'];

  void refresh() {
    _dashBoardController.fetchDashboardData(refresh: true);
  }

  int _backButtonCounter = 0;

  int get _navBarActiveIndex => _tabIndex == 2 ? 0 : _tabIndex;

  @override
  Widget build(BuildContext context) {
    _dashBoardController =
        Provider.of<DashBoardController>(context, listen: true)
          ..fetchDashboardData()
          ..setView = this;

    final scheme = Theme.of(context).colorScheme;
    final isHome = _tabIndex == 2;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_backButtonCounter < 1) {
          _backButtonCounter++;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: EPScaffold(
        backgroundColor: scheme.surface,
        appBar: EPAppBar(
          centerTitle: true,
          backgroundColor:
              context.isDarkMode ? EPColors.appMainDark : scheme.primary,
          title: Text(
            _titles[_tabIndex],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              fontSize: 17,
            ),
          ),
          leading: const SizedBox.shrink(),
        ),
        state: AppState(pageState: _dashBoardController.pageState),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            child: Image.asset(EPImages.homeIcon, width: 26),
            backgroundColor:
                isHome ? EPColors.appMainLightColor : scheme.primary,
            onPressed: () => setState(() => _tabIndex = 2),
          ),
        ),
        builder: (context) => _pages[_tabIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: context.cardFill,
            border: Border(
              top: BorderSide(color: context.borderColor),
            ),
          ),
          child: AnimatedBottomNavigationBar(
            icons: const [
              Icons.receipt_long_outlined,
              Icons.settings_outlined,
            ],
            activeIndex: _navBarActiveIndex,
            activeColor: scheme.primary,
            inactiveColor: context.mutedText,
            elevation: 0,
            backgroundColor: context.cardFill,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            leftCornerRadius: 0,
            rightCornerRadius: 0,
            iconSize: 24,
            splashColor: scheme.primary.withValues(alpha: 0.1),
            splashSpeedInMilliseconds: 200,
            onTap: (index) => setState(() => _tabIndex = index),
          ),
        ),
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
