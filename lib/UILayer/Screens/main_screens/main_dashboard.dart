import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/cards_view.dart'
    show HomeWalletsSection;
import 'package:enk_pay_project/UILayer/Screens/cash_in/cash_in_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/main_screens/widgets/home_widgets.dart';
import 'package:enk_pay_project/UILayer/utils/greeting_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/model/login_response_model.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../utils/account_creation_dialog.dart';
import '../../utils/linear_progress_bar.dart';
import '../../utils/screen_navigation.dart';
import '../Intro_Screen/dash_board_widget_builder.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/service_options_sheet.dart';
import '../settings/user_account_verification/verification_main_screen.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback? onRefresh;
  const MainScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with MainView {
  late DashBoardController _dashBoardController;
  APPPermission? appPermission;

  @override
  void initState() {
    super.initState();
    loadPermission();
  }

  loadPermission() async {
    LocalDataStorage.getUserPermission().then((value) {
      if (mounted) {
        setState(() => appPermission = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dashBoardController =
        Provider.of<DashBoardController>(context, listen: true)
          ..setMainView = this;

    final services =
        DashBoardBuilder.builder(appPermission, context);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: RefreshIndicator(
          color: EPColors.appMainColor,
          onRefresh: () async {
            await _dashBoardController.fetchDashboardData(refresh: true);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EPLinearProgressBar(
                        loading: _dashBoardController.isAccountCreationLoading ||
                            _dashBoardController.isCreatingStaticVa,
                      ),
                      if (!_dashBoardController.completeKYC) ...[
                        const SizedBox(height: 12),
                        HomeKycBanner(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const VerificationMainScreen(),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: HomeHeaderDelegate(
                  greeting: greetingMessage(),
                  name: _dashBoardController.fullName,
                  isMale: _dashBoardController.isMale,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeWalletsSection(
                        mainAmount: _dashBoardController.getAccountBalance,
                        bonusAmount:
                            _dashBoardController.getAccountBonusBalance,
                        onPayBills: () => showBillPaymentOptionsSheet(context),
                        cashIn: _dashBoardController.onCahIn,
                        onTransfer: () => showTransferOptionsSheet(context),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Services',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What would you like to do today?',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.55),
                                ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        HomeServiceTile(model: services[index]),
                    childCount: services.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onError(String message) {
    if (mounted) {
      showEPStatusDialog(context,
          success: false, message: message, callback: () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onAccountCheck() {
    pushToNextScreen(context, const CashInScreen());
  }

  @override
  void onShowTransferAccount() {
    pushToNextScreen(context, const CashInScreen());
  }

  @override
  void onAccountCreateSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      widget.onRefresh?.call();
    });
  }
}
