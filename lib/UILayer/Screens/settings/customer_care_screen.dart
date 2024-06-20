import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constant/string_values.dart';
import '../../../DataLayer/controllers/contact_us_controller.dart';
import '../../CustomWidget/ReUseableWidget/cards/grey_bg_card.dart';
import '../../CustomWidget/ReUseableWidget/snack_bar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class CustomerCareScreen extends StatefulWidget {
  const CustomerCareScreen({Key? key}) : super(key: key);

  @override
  State<CustomerCareScreen> createState() => _CustomerCareScreenState();
}

class _CustomerCareScreenState extends State<CustomerCareScreen>
    with ContactUseView {
  ContactUsController? controller;
  @override
  Widget build(BuildContext context) {
    controller = Provider.of<ContactUsController>(context)
      ..setView = this
      ..getContact();
    return EPScaffold(
      state: AppState(
          pageState: Provider.of<ContactUsController>(context).pageState),
      appBar: EPAppBar(
        title: const Text("Customer Care"),
      ),
      builder: (_) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GreyBGCard(
              color: EPColors.appMainColor,
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "We are available",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Monday  - Sunday",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "8:00am - 4:00pm",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _contactUSView(context,
                title: controller?.contactUsData?.email,
                icon: const FaIcon(FontAwesomeIcons.mailBulk),
                launcher: ContactLauncher.email),
            _contactUSView(context,
                title: controller?.contactUsData?.phone,
                icon: const FaIcon(FontAwesomeIcons.phone),
                launcher: ContactLauncher.phone),
            _contactUSView(context,
                title: controller?.contactUsData?.whatsapp,
                icon: const FaIcon(FontAwesomeIcons.whatsapp)),
            _contactUSView(context,
                title: controller?.contactUsData?.facebook,
                icon: const FaIcon(FontAwesomeIcons.facebook)),
            _contactUSView(context,
                title: controller?.contactUsData?.twitter,
                icon: const FaIcon(FontAwesomeIcons.twitter)),
            _contactUSView(context,
                title: controller?.contactUsData?.instagram,
                icon: const FaIcon(FontAwesomeIcons.instagram)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (isEmpty(url)) {
      return;
    }
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  _contactUSView(BuildContext context,
      {String? title, required Widget icon, ContactLauncher? launcher}) {
    if (isEmpty(title)) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: () {
          switch (launcher) {
            case ContactLauncher.phone:
              var phoneNumber = 'tel:$title';
              _launchUrl(phoneNumber);
              break;
            case ContactLauncher.email:
              var emailAddress = 'mailto:$title';
              _launchUrl(emailAddress);

              break;
            default:
              final websiteURL = 'https://$title';
              _launchUrl(websiteURL);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: EPColors.appMainColor)),
          width: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
            child: Row(
              children: [
                icon,
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title ?? "",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.black,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  onError(String message) {
    snackBar(context, message: message);
  }

  @override
  onSuccess() {}
}
