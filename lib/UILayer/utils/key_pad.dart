import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/controllers/signin_controller.dart';
import '../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../Screens/main_screens/nav_ui.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> with PinSignInView {
  String enteredPin = '';
  bool isPinVisible = false;

  /// this widget will be use for each digit
  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
            }
            print(enteredPin);
            if (enteredPin.length >= 4) {
              signInController.pinSignIn(enteredPin);
              //do request here
              enteredPin = "";
            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  late SignInController signInController;
  @override
  Widget build(BuildContext context) {
    signInController = Provider.of<SignInController>(context)..pinView = this;
    return EPScaffold(
      state: AppState(pageState: signInController.pageState),
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const Center(
                child: Text(
                  'Enter Your Pin',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              /// pin code area
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        width: isPinVisible ? 50 : 16,
                        height: isPinVisible ? 50 : 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: index < enteredPin.length
                              ? isPinVisible
                                  ? EPColors.appMainColor
                                  : EPColors.appMainColor
                              : CupertinoColors.activeBlue.withOpacity(0.1),
                        ),
                        child: isPinVisible && index < enteredPin.length
                            ? Center(
                                child: Text(
                                  enteredPin[index],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ),

              /// digits
              for (var i = 0; i < 3; i++)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) => numButton(1 + 3 * i + index),
                    ).toList(),
                  ),
                ),

              /// 0 digit with back remove
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextButton(onPressed: null, child: SizedBox()),
                    numButton(0),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            if (enteredPin.isNotEmpty) {
                              enteredPin = enteredPin.substring(
                                  0, enteredPin.length - 1);
                            }
                          },
                        );
                      },
                      child: const Icon(
                        Icons.backspace,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(String message) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const NavUI()),
      (route) => false,
    );
  }
}
