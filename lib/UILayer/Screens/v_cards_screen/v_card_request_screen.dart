import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/v_cards_screen/v_cards_create_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/v_cards_screen/vcard_verify_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/string_values.dart';
import '../../../DataLayer/controllers/vcard_controller.dart';
import '../../CustomWidget/ReUseableWidget/cards/grey_bg_card.dart';

class VCardRequestScreen extends StatelessWidget {
  const VCardRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text("Request Virtual Card"),
      ),
      builder: (_) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Spacer(),
            Image.asset(EPImages.rVcard),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Enjoy seamless payment online with '),
                    TextSpan(
                      text: 'ENKPAY Virtual Card',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add any other text spans here if needed
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GreyBGCard(
              child: Text(
                requestTitle,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            EPButton(
              title: "Continue",
              onTap: () {
                Provider.of<VCardController>(context, listen: false)
                    .canUserCreateCard()
                    .then((value) {
                  if (value == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const VCardCreateScreen()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const VCardVerifyScreen()));
                  }
                });
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
