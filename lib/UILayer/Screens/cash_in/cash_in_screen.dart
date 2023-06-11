import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../DataLayer/model/login_response_model.dart';
import '../../CustomWidget/ReUseableWidget/snack_bar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class CashInScreen extends StatelessWidget {
  const CashInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text("Account Info"),
      ),
      builder: (_) => FutureBuilder<UserData?>(
          future: LocalDataStorage.getUserData(),
          builder: (context, snapshot) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "List of Business/Personal Accounts primed to receive your payments and take your to new heights!",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.virtualBankList?.length ?? 0,
                      itemBuilder: (_, index) => _AccountTile(
                          bank: snapshot.data!.virtualBankList![index])),
                ),
              ],
            );
          }),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final VirtualBank bank;
  const _AccountTile({Key? key, required this.bank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textView("Bank Name", bank.bankName, context),
              const SizedBox(
                height: 10,
              ),
              _textView("Account Number", bank.accountNo, context, show: true),
              const SizedBox(
                height: 10,
              ),
              _textView("Account Name", bank.accountName, context),
            ],
          ),
        ),
        const Divider()
      ],
    );
  }

  _textView(String title, String? value, BuildContext context,
      {bool show = false}) {
    return Row(
      children: [
        Text(
          "$title:  ".toUpperCase(),
          style: Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal),
        ),
        Text(
          value ?? "",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black, fontSize: 13),
        ),
        const Spacer(),
        show
            ? InkWell(
                child: const FaIcon(FontAwesomeIcons.copy),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value)).then((v) {
                    snackBar(context, message: "$value copied");
                  });
                },
              )
            : Container(),
      ],
    );
  }
}
