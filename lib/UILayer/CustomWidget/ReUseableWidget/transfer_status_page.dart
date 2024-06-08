import 'dart:io';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:etop_pos_plugin/etop_pos_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Constant/image.dart';
import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/controllers/transfer_status_controller.dart';
import '../../../DataLayer/model/login_response_model.dart';
import '../../utils/time_ago_util.dart';
import 'ep_button.dart';

class TransferStatusPage extends StatefulWidget {
  final VoidCallback? onTap;
  final String? refTransId;
  final String? transactionTitle;
  const TransferStatusPage(
      {Key? key, this.onTap, this.refTransId, this.transactionTitle})
      : super(key: key);

  @override
  State<TransferStatusPage> createState() => _TransferStatusPageState();
}

class _TransferStatusPageState extends State<TransferStatusPage> {
  ScreenshotController screenshotController = ScreenshotController();
  XFile? file;
  TransferStatusController? controller;
  @override
  void dispose() {
    super.dispose();
    controller?.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransferStatusController>(
        builder: (context, myProvider, child) {
      myProvider.getTransaction(widget.refTransId!);
      controller = myProvider;
      return EPScaffold(
        appBar: EPAppBar(),
        state: AppState(
            pageState: myProvider.pageState,
            noDataMessage: myProvider.transactionStatusModel?.message),
        builder: (_) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Image.asset(EPImages.logoIcon),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            statusString(
                                myProvider.transactionStatusModel?.status),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor(myProvider
                                        .transactionStatusModel?.status)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Actual credit time subject to recipient's bank.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          rowView(
                            "Recipient",
                            myProvider.transactionStatusModel?.receiverName,
                          ),
                          rowView(
                            "Recipient Bank",
                            myProvider.transactionStatusModel?.receiverBank,
                          ),
                          rowView(
                            "Recipient Account Number",
                            myProvider
                                .transactionStatusModel?.receiverAccountNo,
                          ),
                          rowView(
                            "Transaction Amount",
                            amountFormatter(myProvider
                                .transactionStatusModel?.amount
                                .toString()),
                          ),
                          rowView("Reference ID",
                              myProvider.transactionStatusModel?.eRef ?? "",
                              copy: true),
                          rowView("Card Pan",
                              myProvider.transactionStatusModel?.cardPan ?? "",
                              copy: false),
                          rowView("RRN",
                              myProvider.transactionStatusModel?.rrn ?? "",
                              copy: true),
                          rowView(
                            "Note",
                            myProvider.transactionStatusModel?.note ?? "",
                          ),
                          rowView(
                            "Date",
                            TimeUtilAgo.format2(
                                myProvider.transactionStatusModel!.date!),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  myProvider.transactionStatusModel?.message ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontWeight: FontWeight.w300, color: Colors.black87),
                ),
                EPButton(
                  title: "Print",
                  onTap: () async {
                    UserData? userData = await LocalDataStorage.getUserData();
                    Map map = {
                      "title": widget.transactionTitle,
                      "merchantName": userData?.terminalInfo?.merchantName
                    };
                    map["data"] = transactionMap(myProvider);
                    EtopPosPlugin().reprint(map: map);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String statusString(num? status) {
    switch (status) {
      case 0:
        return "Pending";
      case 2:
        return "Successful";
      case 3:
        return "Failed";
      case 4:
        return "Reversed";
      default:
        return "Unknown";
    }
  }

  Color statusColor(num? status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Map<String, dynamic> transactionMap(TransferStatusController myProvider) => {
        "Card Pan": myProvider.transactionStatusModel?.cardPan ?? "",
        "RRN": myProvider.transactionStatusModel?.rrn ?? "",
        "Recipient": myProvider.transactionStatusModel?.receiverName ?? "",
        "Recipient Bank": myProvider.transactionStatusModel?.receiverBank ?? "",
        "Recipient Account Number":
            myProvider.transactionStatusModel?.receiverAccountNo ?? "",
        "Transaction Amount": amountFormatter(
                myProvider.transactionStatusModel?.amount.toString()) ??
            "",
        "Date": myProvider.transactionStatusModel?.date != null
            ? TimeUtilAgo.format2(myProvider.transactionStatusModel!.date!)
            : "",
        "Message": statusString(myProvider.transactionStatusModel?.status),
      };

  Widget rowView(String title, String? value, {bool copy = false}) {
    if (isEmpty(value)) {
      return Container();
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title:",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value!,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.w200, color: Colors.black87),
                  ),
                ),
                const Spacer(),
                copy
                    ? InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: value ?? ""))
                              .then((value) {
                            snackBar(context, message: "copied");
                          });
                        },
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 10,
                            ),
                            FaIcon(FontAwesomeIcons.copy),
                          ],
                        ),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/Receipt.png');
    // final file = File('${directory.path}/${generateRandomString(10)}.png');
    await file.writeAsBytes(imageBytes);
    this.file = XFile(file.path);
  }
}
