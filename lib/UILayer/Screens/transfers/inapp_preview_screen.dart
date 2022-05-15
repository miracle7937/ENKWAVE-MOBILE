import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/grey_bg_card.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InAppPreviewScreen extends StatelessWidget {
  const InAppPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
        appBar: EPAppBar(
          title: Text(
            "Transaction preview",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w600, color: EPColors.appBlackColor),
          ),
        ),
        builder: (_) => Column(
              children: [
                GreyBGCard(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(EPImages.simCard),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Internal Transfer",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: EPColors.appBlackColor),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "20000000",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: EPColors.appBlackColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.asset(EPImages.mobilePhone),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mobile number",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: EPColors.appBlackColor),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "081683744999",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: EPColors.appBlackColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
                GreyBGCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(EPImages.amount),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Amount",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                          const Spacer(),
                          Text(
                            "NGN 200000",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(EPImages.totalAmount),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Total",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                          const Spacer(),
                          Text(
                            "NGN 6000",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Spacer(),
                EPButton(
                  title: "Continue",
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ));
  }
}
