import 'package:enk_pay_project/UILayer/Screens/history/widget/history_list_tile.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/history_selectable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/controllers/dashboard_controller.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/transfer_status_page.dart';
import '../../utils/loader_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: Provider.of<DashBoardController>(context, listen: false)
            .fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoaderWidget(),
            );
          }

          return Consumer<DashBoardController>(
              builder: (context, myProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                myProvider.fetchHistory(refresh: true);
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  EPForm(
                    hintText: "Search",
                    onChange: (query) {
                      myProvider.filterHistoryItems(query);
                    },
                  ),
                  SizedBox(
                    child: HistorySelectable(
                      onSelect: (v) {
                        myProvider.filterByTransactionType(v);
                      },
                    ),
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  myProvider.queryTransactionData.isNotEmpty
                      ? Expanded(
                          child: ListView(
                          children: myProvider.queryTransactionData
                              .map((e) => HistoryListTile(
                                    transactionData: e,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  TransferStatusPage(
                                                    refTransId: e.refTransId,
                                                    transactionTitle: e.title,
                                                  )));
                                      // if (getTransactionEnum(
                                      //         e.transactionType!) ==
                                      //     TransactionEnum.bankTransfer) {
                                      //   Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder: (builder) =>
                                      //               TransferStatusPage(
                                      //                 refTransId: e.refTransId,
                                      //               )));
                                      // }
                                    },
                                  ))
                              .toList(),
                        ))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
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
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            );
          });
        });
  }
}
