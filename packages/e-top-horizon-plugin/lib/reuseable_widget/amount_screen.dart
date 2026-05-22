import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant/color.dart';
import '../utils/null_checker.dart';

typedef DeleteCode = void Function();
typedef CodeVerify = Function(String code);

class AmountScreen extends StatefulWidget {
  final int codeLength;
  final bool shuffle;
  final CodeVerify? codeVerify;
  final bool forPin;
  final String? title;

  AmountScreen(
      {this.codeLength = 2,
      this.codeVerify,
      this.shuffle = false,
      this.forPin = true,
      this.title})
      : assert(codeLength > 0),
        assert(codeVerify != null);

  @override
  State<StatefulWidget> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  var _inputLength = 6;
  var _inputList = <int>[];
  List<int> values = List.generate(9, (i) => i + 1)..add(0);
  TextEditingController controller = TextEditingController(text: 'NGN 0');
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
    final compact = MediaQuery.sizeOf(context).height < 520;
    final amountFontSize = compact ? 28.0 : 36.0;
    final keyFontSize = compact ? 20.0 : 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Text(
          widget.title ?? 'Enter Your Transaction Amount',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: EPColors.appMainColor,
                fontSize: compact ? 14 : 16,
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            showCursor: false,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: amountFontSize,
                  fontWeight: FontWeight.bold,
                  color: EPColors.appMainColor,
                ),
            textAlign: TextAlign.center,
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: compact ? 1.45 : 1.25,
          children: List.generate(12, (e) => _keyButton(e, keyFontSize)),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _keyButton(int e, double keyFontSize) {
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
              fontSize: keyFontSize - 2,
              fontWeight: FontWeight.w500,
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
              fontSize: keyFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 11:
        return TextButton(
          onPressed: () {
            setState(() => undoLastInput());
          },
          child: Icon(
            Icons.backspace_outlined,
            color: EPColors.appMainColor,
            size: keyFontSize + 4,
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
              fontSize: keyFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  checkingEmptyValue() {
    print("hello ${_inputList.join()}");
    var amount =
        _inputList.join().isEmpty ? "NGN 0" : moneyFormatter(_inputList.join());
    controller.text = amount;
    String _amount = _inputList.isEmpty ? "0" : _inputList.join();
    setState(() {});

    widget.codeVerify!(int.parse(_amount).toString()).whenComplete(() {
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

  String moneyFormatter(String? amount) {
    if (isEmpty(amount)) {
      return "0";
    }

    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'en_US', // Replace with your desired locale
      symbol: 'NGN ', // Replace with your desired currency symbol
      decimalDigits: 0, // Number of decimal places
    );
    return currencyFormatter.format(int.parse(amount!));
  }

  clearAll() {
    controller.text = "NGN0";
    _inputList.clear();
  }

  void addChar(int value) {
    _verifyAmount(value);

    // if (_inputList.isEmpty && value == 0) {
    // } else {
    //   _inputList.add(value);
    // }
    // checkingEmptyValue();
    // print(_inputList);
  }

  void undoLastInput() {
    if (_inputList.isEmpty) {
      return;
    }
    _inputList.removeLast();

    checkingEmptyValue();
  }

  _verifyAmount(int value) async {
    if (_inputList.isEmpty && value == 0) {
      return;
    }
    _inputList.add(value);
    String _amount = _inputList.join();
    controller.text = moneyFormatter(_amount);
    setState(() {});

    widget.codeVerify!(_amount).whenComplete(() {
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
