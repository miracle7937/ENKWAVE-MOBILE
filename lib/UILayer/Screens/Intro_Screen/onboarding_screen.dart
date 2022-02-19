import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/personal_registration.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int initialPage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EPScaffold(
        builder: (context) => Column(
          children: [
            SizedBox(
              child: PageView.builder(
                onPageChanged: (i) {
                  setState(() {
                    initialPage = i;
                  });
                },
                itemCount: ConstantString.introItems.length,
                itemBuilder: (context, i) => SvgPicture.asset(
                  ConstantString.introItems[i].image,
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.45,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                      ConstantString.introItems.length, (index) => index)
                  .map((index) => InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(vertical: 16.0),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: index == initialPage
                                  ? EPColors.appMainColor
                                  : const Color(0xffd8d8d8),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            Text(
              ConstantString.introItems[initialPage].title,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              ConstantString.introItems[initialPage].subTitle,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            const Spacer(),
            EPButton(
                title: "LOGIN",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()));
                }
                // onTap: ,
                ),
            EPButton(
              bgColor: Colors.grey,
              title: "SIGN UP",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PersonalRegistration()));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => const RegistrationTypeScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
