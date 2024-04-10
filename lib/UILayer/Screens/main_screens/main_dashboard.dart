import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/cards_view.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/Screens/cash_in/cash_in_screen.dart';
import 'package:enk_pay_project/UILayer/utils/greeting_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/model/login_response_model.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../utils/account_creation_dialog.dart';
import '../../utils/linear_progress_bar.dart';
import '../../utils/screen_navigation.dart';
import '../Intro_Screen/dash_board_widget_builder.dart';
import '../cash_out/cash_out_screen.dart';
import '../settings/user_account_verification/verification_main_screen.dart';
import '../transfers/transfer_in_app.dart';

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
      setState(() {
        appPermission = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _dashBoardController =
        Provider.of<DashBoardController>(context, listen: true)
          ..setMainView = this;
    return SafeArea(
        child: RefreshIndicator(
      onRefresh: () async {
        _dashBoardController.fetchDashboardData(refresh: true);
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EPLinearProgressBar(
                loading: _dashBoardController.isAccountCreationLoading,
              ),
              const SizedBox(
                height: 5,
              ),
              _dashBoardController.completeKYC
                  ? Container()
                  : InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VerificationMainScreen())),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.exclamationTriangle,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Please verify your account for full service access. \u26A1",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: EPColors.appBlackColor),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  _dashBoardController.isMale
                      ? Image.asset(
                          EPImages.userMale,
                          width: 30,
                        )
                      : Image.asset(EPImages.female, width: 30),
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greetingMessage(),
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: EPColors.appBlackColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        _dashBoardController.fullName.toUpperCase(),
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: EPColors.appBlackColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              DashBoardCard(
                amount: _dashBoardController.getAccountBalance,
                bonusWallet: _dashBoardController.getAccountBonusBalance,
                cashOut: () {
                  pushToNextScreen(
                      context,
                      CashOutScreen(
                        onRefresh: widget.onRefresh,
                      ));
                },
                cashIn: () {
                  _dashBoardController.onCahIn();
                },
                enkPayTransfer: () async {
                  await pushToNextScreen(context, const TransferInApp());
                },
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
                  children: DashBoardBuilder.builder(appPermission, context)
                      .map<Widget>((e) => cardUI(e))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  cardUI(IntroModel introModel) {
    return Stack(
      children: [
        ContainButton(
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
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: EPColors.appBlackColor),
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
        ),
        introModel.newFeature == true
            ? Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "New+",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  @override
  void onError(String message) {
   if(mounted){
     showEPStatusDialog(context, success: false, message: message, callback: () {
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
    accountCreationDialog(context, onProceed: () {
      _dashBoardController.createAccount();
      Navigator.of(context).pop();
    });
  }

  @override
  void onShowTransferAccount() {
    pushToNextScreen(context, const CashInScreen());

    // showTransferDialog(context,
    //     accountNumber: _dashBoardController.getVAccountNumber,
    //     accountName: _dashBoardController.getVAccountName,F
    //     bankName: _dashBoardController.getVBankName);
  }

  @override
  void onAccountCreateSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      widget.onRefresh!();
    });
  }
}
