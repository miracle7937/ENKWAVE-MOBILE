import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/v_cards_screen/v_cards_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/string_values.dart';
import '../../../DataLayer/controllers/vcard_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class VCardVerifyScreen extends StatefulWidget {
  const VCardVerifyScreen({Key? key}) : super(key: key);

  @override
  State<VCardVerifyScreen> createState() => _VCardVerifyScreenState();
}

class _VCardVerifyScreenState extends State<VCardVerifyScreen>
    with OnVCardVerification {
  @override
  Widget build(BuildContext context) {
    VCardController vCardController = Provider.of<VCardController>(context)
      ..setCardVerifyView(this);
    return EPScaffold(
      state: AppState(pageState: vCardController.pageState),
      appBar: EPAppBar(
        title: const Text("Verify"),
      ),
      builder: (_) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                vCardController.setImageCard();
              },
              child: Container(
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                ),
                decoration: BoxDecoration(
                    image: vCardController.userImage == null
                        ? DecorationImage(
                            image: AssetImage(EPImages.scanPhoto),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: FileImage(vCardController.userImage!),
                            fit: BoxFit.cover,
                          ),
                    shape: BoxShape.circle,
                    border: Border.all(color: EPColors.appMainColor)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                verifyImageTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            vCardController.userImage != null
                ? EPButton(
                    title: "Continue",
                    onTap: () {
                      vCardController.verifyImage();
                    },
                  )
                : Container(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String message) {
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => const VCardCreateScreen()));
  }
}
