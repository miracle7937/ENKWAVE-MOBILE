import 'package:enk_pay_project/UILayer/Screens/v_cards_screen/widget/card_history_tile.dart';
import 'package:enk_pay_project/UILayer/Screens/v_cards_screen/widget/card_info_sheet_view.dart';
import 'package:enk_pay_project/UILayer/Screens/v_cards_screen/widget/card_transaction_model.dart';
import 'package:enk_pay_project/UILayer/Screens/v_cards_screen/widget/v_card_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/controllers/vcard_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';

class VCardScreen extends StatefulWidget {
  const VCardScreen({Key? key}) : super(key: key);

  @override
  State<VCardScreen> createState() => _VCardScreenState();
}

class _VCardScreenState extends State<VCardScreen> with OnVCardView {
  VCardController? vCardController;
  int cardIndex = 0;
  @override
  Widget build(BuildContext context) {
    vCardController = Provider.of<VCardController>(context)..setVCardView(this);
    return EPScaffold(
      state: AppState(pageState: vCardController?.pageState),
      appBar: EPAppBar(
        title: const Text("Card"),
      ),
      builder: (_) => RefreshIndicator(
        onRefresh: () async {
          vCardController?.refreshCard();
        },
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 210,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    onPageChanged: (v) {
                      setState(() {
                        cardIndex = v;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: vCardController
                            ?.cardDetailsResponse?.cardDetails?.length ??
                        0,
                    itemBuilder: (_, index) => VCardView(
                      cardDetails: vCardController
                          ?.cardDetailsResponse!.cardDetails![index],
                    ),
                  ),
                ),
                Text(
                  "Tap to flip",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    children: CardAction.values
                        .map<Widget>((cardAction) => _button(
                            cardAction.name.replaceAll("\$", " "),
                            onTap: () => onTap(cardAction)))
                        .toList(),
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: vCardController
                          ?.cardDetailsResponse?.cardTransaction?.length ??
                      0,
                  itemBuilder: (_, index) => CardHistoryTile(
                    cardTransaction: vCardController!
                        .cardDetailsResponse!.cardTransaction![index],
                  ),
                  // children:
                  //     List.generate(5, (index) => const CardHistoryTile()).toList(),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  _button(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: EPColors.generateRandomColor(),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(4, 4),
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 15)
                ])),
      ),
    );
  }

  fundCard() {
    return cardTransactionView(context,
        title:
            "Fund your card  |   NGN/USD : ${vCardController?.cardDetailsResponse?.rate}",
        onChange: (value) {
          vCardController?.setFundAmount(value);
        },
        onTap: () => vCardController?.fundVCard());
  }

  liquidate() {
    return cardTransactionView(context,
        title:
            "Liquidate your card  |   NGN/USD : ${vCardController?.cardDetailsResponse?.wRate}",
        fundWallet: false,
        onChange: (value) {
          vCardController?.setLiquidateAmount(value);
        },
        onTap: () => vCardController?.liquidateWallet());
  }

  onTap(CardAction cardAction) {
    switch (cardAction) {
      case CardAction.card$Info:
        cardInfoView(
          context,
          vCardController?.cardDetailsResponse!.cardDetails![cardIndex],
        );
        break;
      case CardAction.fund$Card:
        fundCard();
        break;
      case CardAction.liquidate:
        liquidate();
        break;
      // case CardAction.freeze$Card:
      //   print("Freeze");
      //   break;
      // case CardAction.deleted$Card:
      //   print("deleted$Card");
      //   break;
      default:
    }
  }

  @override
  onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
    });
  }
}

enum CardAction {
  card$Info,
  fund$Card,
  liquidate,

  // freeze$Card, deleted$Card

}
