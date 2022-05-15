import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/set_pin_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'custom_amount_pad.dart';

class PinScreenWidget extends StatefulWidget {
  final int codeLength;
  final bool shuffle;
  final CodeVerify? codeVerify;
  final bool forPin;
  final String? title;
  final VoidCallback? clear;
  const PinScreenWidget({
    Key? key,
    this.title,
    this.clear,
    this.codeLength = 4,
    this.codeVerify,
    this.shuffle = false,
    this.forPin = true,
  }) : super(key: key);

  @override
  _PinScreenWidgetState createState() => _PinScreenWidgetState();
}

class _PinScreenWidgetState extends State<PinScreenWidget> {
  var _inputLength = 0;
  var _inputList = <int>[];
  List<int> values = List.generate(9, (i) => i + 1)..add(0);
  TextEditingController controller = TextEditingController(text: '₦ 0.0');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (widget.shuffle) {
      values.shuffle();
    }
    _inputLength = widget.codeLength;
    //ToDo check biometrics setup

    super.initState();
  }

  late PinController setPinController;
  @override
  Widget build(BuildContext context) {
    setPinController = Provider.of<PinController>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(EPImages.pinLock),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.title ?? 'Enter Your Transaction Pin',
          style: Theme.of(context).textTheme.headline1!.copyWith(
              fontWeight: FontWeight.w600, color: EPColors.appMainColor),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Iterable<int>.generate(_inputLength)
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Container(
                        child: Center(
                          child: Text(
                            setPinController.inputList.length > e ? "*" : "",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: EPColors.appMainColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      width: 40,
                      height: 40,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: AspectRatio(
            aspectRatio: .7,
            child: Wrap(
              children: Iterable<int>.generate(12).map(
                (e) {
                  switch (e.toInt()) {
                    case 9:
                      {
                        return FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: FlatButton(
                              child: Text(
                                ("clear").toString(),
                                style: TextStyle(
                                  color: EPColors.appMainColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed: () {
                                clearAll();
                                setState(() {});
                              },
                            ),
                          ),
                        );
                        // return FractionallySizedBox(
                        //   widthFactor: 1 / 3,
                        //   child: AspectRatio(
                        //     aspectRatio: 1,
                        //     child: Container(
                        //       child: Text("C"),
                        //     ),
                        //   ),
                        // );
                      }
                    case 10:
                      {
                        return FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: FlatButton(
                              child: Text(
                                (values[9]).toString(),
                                style: TextStyle(
                                  color: EPColors.appMainColor,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  addChar(values[9]);
                                });
                              },
                            ),
                          ),
                        );
                      }
                    case 11:
                      {
                        return FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: FlatButton(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: FaIcon(
                                  Icons.arrow_back_ios_sharp,
                                  color: EPColors.appMainColor,
                                )),
                              ),
                              onPressed: () {
                                setState(() {
                                  undoLastInput();
                                });
                              },
                            ),
                          ),
                        );
                      }
                    default:
                      {
                        return FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: FlatButton(
                              child: Text(
                                (values[e.toInt()]).toString(),
                                style: TextStyle(
                                  color: EPColors.appMainColor,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  addChar(values[e.toInt()]);
                                });
                              },
                            ),
                          ),
                        );
                      }
                  }
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  padBG({Widget? child}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [widget],
      ),
      height: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.1,
      decoration: BoxDecoration(
        color: EPColors.appMainColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }

  clearAll() {
    setPinController.inputList.clear();
  }

  void addChar(int value) {
    if (setPinController.inputList.length >= _inputLength) {
      _verifyPin();
      return;
    }
    setPinController.inputList.add(value);
    print(setPinController.inputList);

    if (setPinController.inputList.length >= _inputLength) {
      _verifyPin();
      return;
    }
  }

  void undoLastInput() {
    if (setPinController.inputList.isEmpty) {
      return;
    }
    setPinController.inputList.removeLast();
  }

  _verifyPin({bool isBio = false}) async {
    String _pin = setPinController.inputList.join();

    setState(() {});

    widget.codeVerify!(_pin).whenComplete(() {
      setState(() {});
    }).then((onValue) async {
      if (!mounted) return;
      if (onValue) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }
}
