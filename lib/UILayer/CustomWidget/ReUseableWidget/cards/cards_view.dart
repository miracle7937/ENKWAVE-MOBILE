import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:flutter/material.dart';

class DashBoardCard extends StatefulWidget {
  final String? amount;
  const DashBoardCard({Key? key, this.amount}) : super(key: key);

  @override
  _DashBoardCardState createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder<bool>(
                    initialData: true,
                    future: LocalDataStorage.getHideBalance(),
                    builder: (_, snap) => Row(
                          children: [
                            Text(
                              snap.data!
                                  ? "NGN ${widget.amount}"
                                  : hideAmountString(widget.amount!),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: EPColors.appWhiteColor),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                LocalDataStorage.saveHideBalance(!snap.data!);
                                setState(() {});
                              },
                              child: Icon(
                                snap.data!
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: EPColors.appWhiteColor,
                                size: 20,
                                // size: 22,
                              ),
                            ),
                          ],
                        )),
              ],
            ),
            Column(
              children: [
                ContainButton(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Top - Up",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: EPColors.appGreyColor),
                    ),
                  ),
                  onTap: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                ContainButton(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Withdraw",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: EPColors.appGreyColor),
                    ),
                  ),
                  onTap: () {},
                )
              ],
            )
          ],
        ),
      ),
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          color: EPColors.appWhiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            colors: [EPColors.appMainLightColor, EPColors.appMainColor],
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
    return List.generate(amount.length, (index) => "*")
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
