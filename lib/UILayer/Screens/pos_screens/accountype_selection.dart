import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountTypeSelectionScreen extends StatefulWidget {
  final Function(String) onSelectAccountType;
  const AccountTypeSelectionScreen({
    Key? key,
    required this.onSelectAccountType,
  }) : super(key: key);

  @override
  State<AccountTypeSelectionScreen> createState() =>
      _AccountTypeSelectionScreenState();
}

class _AccountTypeSelectionScreenState
    extends State<AccountTypeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: EPColors.appMainColor,
          title: const Text(
            "Account Type",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CardWidget(
                  value: "00",
                  title: "Default Account",
                  callback: (v) {
                    widget.onSelectAccountType(v);
                  }),
              CardWidget(
                value: "10",
                title: "Savings Account",
                callback: (v) {
                  widget.onSelectAccountType(v);
                },
              ),
              CardWidget(
                value: "20",
                title: "Current Account",
                callback: (v) {
                  widget.onSelectAccountType(v);
                },
              ),
              CardWidget(
                value: "30",
                title: "Corporate Account",
                callback: (v) {
                  widget.onSelectAccountType(v);
                },
              ),
            ],
          ),
        ));
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String? value;
  final Function(String v)? callback;
  const CardWidget({Key? key, required this.title, this.callback, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback!(value!),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(4, 4),
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 15)
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
          )),
    );
  }
}
