import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/buy_airtime_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/grey_bg_card.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AirtimeTransactionPreview extends StatelessWidget {
  const AirtimeTransactionPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AirtimeController _airtimeController =
        Provider.of<AirtimeController>(context);

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
                              "Network Provider",
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
                              getAirtimeTitle(
                                  _airtimeController.airTimeRouteSelector),
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
                              _airtimeController.airtimeModel.phone.toString(),
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
                            "NGN${_airtimeController.airtimeModel.amount.toString()}",
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
                            "NGN${_airtimeController.airtimeModel.amount.toString()}",
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
