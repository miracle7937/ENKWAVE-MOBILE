import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/controllers/manage_terminal_controller.dart';
import '../../../../DataLayer/model/terminal_request_model.dart';
import '../../../CustomWidget/ReUseableWidget/snack_bar.dart';
import '../../../CustomWidget/ReUseableWidget/transfer_status_page.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../../utils/loader_widget.dart';
import '../../history/widget/history_list_tile.dart';

class TerminalHistoryScreen extends StatefulWidget {
  const TerminalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TerminalHistoryScreen> createState() => _TerminalHistoryScreenState();
}

class _TerminalHistoryScreenState extends State<TerminalHistoryScreen>
    with OnTerminalHistory {
  @override
  void dispose() {
    super.dispose();
    Provider.of<ManageTerminalController>(context, listen: false)
        .clearAllHistory();
  }

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
        appBar: EPAppBar(
          title: const Text("Terminal Transactions"),
        ),
        builder: (context) {
          return FutureBuilder<void>(
              future:
                  Provider.of<ManageTerminalController>(context, listen: false)
                      .getTerminalHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoaderWidget(),
                  );
                } else {
                  return Consumer<ManageTerminalController>(
                      builder: (context, myProvider, child) {
                    myProvider.onTerminalHistory = this;

                    return RefreshIndicator(
                      onRefresh: () async {
                        myProvider.getTerminalHistory(refresh: true);
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                (myProvider.selectedTerminal?.description ?? "")
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                              ),
                              const Spacer(),
                              transferStatusView(myProvider.selectedTerminal!)
                            ],
                          ),
                          amountView(
                            todayTransaction: myProvider
                                .terminalTransactionsModel?.dailyTransactions
                                .toString(),
                            totalTransaction: myProvider
                                .terminalTransactionsModel?.totalTransactions
                                .toString(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          (myProvider.terminalTransactionsModel?.history ?? [])
                                  .isNotEmpty
                              ? Expanded(
                                  child: ListView(
                                  children: myProvider
                                      .terminalTransactionsModel!.history!
                                      .map((e) => HistoryListTile(
                                            transactionData: e,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          TransferStatusPage(
                                                            refTransId:
                                                                e.refTransId,
                                                          )));
                                            },
                                          ))
                                      .toList(),
                                ))
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.list,
                                        size: 50,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Empty Record",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                                fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    );
                  });
                }
              });
        });
  }

  amountView({String? totalTransaction, String? todayTransaction}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Transaction Amount" ?? "",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      amountFormatter(totalTransaction),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daily Amount" ?? "",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      amountFormatter(todayTransaction),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: EPColors.appMainColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: EPColors.appMainColor, width: 2),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(4, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 15)
              ])),
    );
  }

  transferStatusView(TerminalData terminalData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
          child: Text(
            terminalData.transferStatus == 0
                ? "Transfer inactive"
                : "Transfer active",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        decoration: BoxDecoration(
          color:
              terminalData.transferStatus == 0 ? Colors.orange : Colors.green,
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }

  @override
  onError(String? message) {
    snackBar(context, message: message);
  }

  @override
  onSuccess(String? message) {}
}
