import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:flutter/material.dart';

import '../../../utils/money_formatter.dart';

class DashBoardCard extends StatefulWidget {
  final String? amount, bonusWallet;
  final VoidCallback? cashOut, cashIn, enkPayTransfer;
  const DashBoardCard(
      {Key? key,
      this.amount,
      this.bonusWallet,
      this.cashOut,
      this.cashIn,
      this.enkPayTransfer})
      : super(key: key);

  @override
  _DashBoardCardState createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Balance",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: EPColors.appWhiteColor),
                    ),
                    FutureBuilder<bool>(
                        initialData: true,
                        future: LocalDataStorage.getHideBalance(),
                        builder: (_, snap) => InkWell(
                              onTap: () {
                                LocalDataStorage.saveHideBalance(!snap.data!);
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Text(
                                    snap.data!
                                        ? "${amountFormatter(widget.amount)}"
                                        : hideAmountString(widget.amount!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: EPColors.appWhiteColor),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    snap.data!
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: EPColors.appWhiteColor,
                                    size: 15,
                                    // size: 22,
                                  ),
                                ],
                              ),
                            )),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bonus Balance",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: EPColors.appWhiteColor),
                    ),
                    FutureBuilder<bool>(
                        initialData: true,
                        future: LocalDataStorage.getHideBonus(),
                        builder: (_, snap) => InkWell(
                              onTap: () {
                                LocalDataStorage.saveHideBonus(!snap.data!);
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Text(
                                    snap.data!
                                        ? "${amountFormatter(widget.bonusWallet)}"
                                        : hideAmountString(widget.amount!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: EPColors.appWhiteColor),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    snap.data!
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: EPColors.appWhiteColor,
                                    size: 15,
                                    // size: 22,
                                  ),
                                ],
                              ),
                            )),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ContainButton(
                  bgColor: Colors.pink,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wallet,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          "CASH OUT",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: EPColors.appWhiteColor),
                        ),
                      ],
                    ),
                  ),
                  onTap: widget.cashOut,
                ),
                const SizedBox(
                  width: 10,
                ),
                ContainButton(
                  bgColor: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          "CASH IN",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: EPColors.appWhiteColor),
                        ),
                      ],
                    ),
                  ),
                  onTap: widget.cashIn,
                ),
                const SizedBox(
                  width: 10,
                ),
                ContainButton(
                  bgColor: Colors.purpleAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.forward_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          "EP TRANSFER",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: EPColors.appWhiteColor),
                        ),
                      ],
                    ),
                  ),
                  onTap: widget.enkPayTransfer,
                )
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                EPImages.bgImage,
              ),
              fit: BoxFit.cover),
          color: EPColors.appMainColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            colors: [
              EPColors.appMainColor,
              EPColors.appMainLightColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.4, 13],
          ),
          boxShadow: const [
            BoxShadow(
                offset: Offset(4, 4),
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 15)
          ]),
    );
  }

  hideAmountString(String amount) {
    return List.generate(amount.length, (index) => "****")
        .toList()
        .toString()
        .substring(1, amount.length)
        .replaceAll(",", "*");
  }
}

class CardSelectCard extends StatelessWidget {
  final String image, title;
  final VoidCallback? onTap;
  const CardSelectCard(
      {Key? key, required this.image, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                Image.asset(image),
                const SizedBox(
                  width: 15,
                ),
                Text(title,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                const Spacer(),
                Image.asset(EPImages.forwardArrow),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: EPColors.appWhiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                colors: [EPColors.appWhiteColor, EPColors.appWhiteColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.4, 13],
              ),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(4, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 15)
              ]),
        ),
      ),
    );
  }
}
