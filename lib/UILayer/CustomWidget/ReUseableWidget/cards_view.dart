import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:flutter/material.dart';

class DashBoardCard extends StatelessWidget {
  const DashBoardCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Balance",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: EPColors.appWhiteColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "N 100,000.00",
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: EPColors.appWhiteColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.visibility_off,
                      color: EPColors.appWhiteColor,
                      // size: 22,
                    )
                  ],
                )
              ],
            ),
            Column(
              children: [
                ContainButton(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Top - Up",
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.bold,
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
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontWeight: FontWeight.bold,
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
          borderRadius: const BorderRadius.all(Radius.circular(8)),
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
}
