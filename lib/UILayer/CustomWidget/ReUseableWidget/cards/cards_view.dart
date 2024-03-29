import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:flutter/material.dart';

import '../../../utils/money_formatter.dart';

class DashBoardCard extends StatefulWidget {
  final String? amount, title;
  final VoidCallback? cashOut, cashIn, enkPayTransfer;

  final bool forBonus;
  const DashBoardCard(
      {Key? key,
      this.amount,
      this.title,
      this.cashOut,
      this.cashIn,
      this.enkPayTransfer,
      this.forBonus = false})
      : super(key: key);

  @override
  _DashBoardCardState createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title ?? "",
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
                                              fontSize: 25,
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
                ],
              ),
              Row(
                children: [
                  ContainButton(
                    bgColor: Colors.pink,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        children: [
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
                  !widget.forBonus
                      ? ContainButton(
                          bgColor: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Row(
                              children: [
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
                                          color: EPColors.appWhiteColor),
                                ),
                              ],
                            ),
                          ),
                          onTap: widget.cashIn,
                        )
                      : Container(),
                  const SizedBox(
                    width: 10,
                  ),
                  ContainButton(
                    bgColor: Colors.purpleAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        children: [
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
            // image: DecorationImage(
            //     image: AssetImage(
            //       EPImages.bgImage,
            //     ),
            //     fit: BoxFit.fill),
            color: EPColors.appMainColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              colors: [
                EPColors.appMainColor,
                EPColors.appMainLightColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.6, 20],
            ),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(4, 4),
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 15)
            ]),
      ),
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
