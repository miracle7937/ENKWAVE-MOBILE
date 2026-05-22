import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef DeleteCode = void Function();
typedef CodeVerify = Future<bool> Function(String code);

class AmountScreen extends StatefulWidget {
  final int codeLength;
  final bool shuffle;
  final CodeVerify? codeVerify;
  final bool forPin;

  AmountScreen({
    this.codeLength = 2,
    this.codeVerify,
    this.shuffle = false,
    this.forPin = true,
  })  : assert(codeLength > 0),
        assert(codeVerify != null);

  @override
  State<StatefulWidget> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  var _inputLength = 6;
  var _inputList = <int>[];
  List<int> values = List.generate(9, (i) => i + 1)..add(0);
  TextEditingController controller = TextEditingController(text: '0.0');
  @override
  void initState() {
    if (widget.shuffle) {
      values.shuffle();
    }
    //ToDo check biometrics setup
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final amountStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: EPColors.appMainColor,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
          const SizedBox(height: 8),
          Text(
            'Enter Your Transaction Amount',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: EPColors.appMainColor,
                ),
          ),
          const SizedBox(height: 12),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NGN ',
                    style: amountStyle,
                  ),
                  Flexible(
                    child: Text(
                    controller.text,
                    overflow: TextOverflow.ellipsis,
                    style: amountStyle?.copyWith(fontSize: 22),
                  ),
                  ),
                  //
                  // TextFormField(
                  //   showCursor: false,
                  //   style: Theme.of(context).textTheme.overline!.copyWith(
                  //       fontWeight: FontWeight.bold,
                  //       color: EPColors.appMainColor),
                  //   textAlign: TextAlign.center,
                  //   controller: controller,
                  //   decoration: const InputDecoration(
                  //     border: InputBorder.none,
                  //   ),
                  // ),
                ],
              )),
          // Text(_inputList.join()),

          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     vertical: 0,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: Iterable<int>.generate(_inputLength)
          //         .map(
          //           (e) => Container(
          //             padding: EdgeInsets.all(10),
          //             child: SizedBox(
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                   color: _inputList.length > e
          //                       ? Colors.black
          //                       : Colors.white,
          //                   border:
          //                       new Border.all(color: Colors.red, width: 2.0),
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(5),
          //                   ),
          //                 ),
          //               ),
          //               width: 10,
          //               height: 10,
          //             ),
          //           ),
          //         )
          //         .toList(),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1.35,
              ),
              itemCount: 12,
              itemBuilder: (context, e) {
                switch (e) {
                  case 9:
                    return TextButton(
                      onPressed: () {
                        clearAll();
                        setState(() {});
                      },
                      child: Text(
                        'clear',
                        style: TextStyle(
                          color: EPColors.appMainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  case 10:
                    return TextButton(
                      onPressed: () {
                        setState(() => addChar(values[9]));
                      },
                      child: Text(
                        values[9].toString(),
                        style: TextStyle(
                          color: EPColors.appMainColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  case 11:
                    return TextButton(
                      onPressed: () {
                        setState(() => undoLastInput());
                      },
                      child: FaIcon(
                        Icons.arrow_back_ios_sharp,
                        color: EPColors.appMainColor,
                        size: 20,
                      ),
                    );
                  default:
                    return TextButton(
                      onPressed: () {
                        setState(() => addChar(values[e]));
                      },
                      child: Text(
                        values[e].toString(),
                        style: TextStyle(
                          color: EPColors.appMainColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
    );
  }

  checkingEmptyValue() {
    var amount = _inputList.join().isEmpty
        ? 0
        : double.parse(_inputList.join()).toCurrencyString(mantissaLength: 0);
    controller.text = "${amount.toString()}";
  }

  clearAll() {
    controller.text = "0.0";
    _inputList.clear();
  }

  void addChar(int value) {
    if (_inputList.length >= _inputLength) {
      _verifyPin();
      return;
    }

    if (_inputList.isEmpty && value == 0) {
    } else {
      _inputList.add(value);
    }
    checkingEmptyValue();
    print(_inputList);
  }

  void undoLastInput() {
    if (_inputList.isEmpty) {
      return;
    }
    _inputList.removeLast();
    checkingEmptyValue();
  }

  _verifyPin({bool isBio = false}) async {
    String _pin = _inputList.join();

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
