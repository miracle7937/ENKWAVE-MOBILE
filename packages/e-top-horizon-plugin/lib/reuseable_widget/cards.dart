import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/color.dart';

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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(4, 4),
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 15)
                ]),
          )),
    );
  }
}

class CardWidgetWithBG extends StatelessWidget {
  final String title;

  final Function()? callback;
  const CardWidgetWithBG({Key? key, required this.title, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback!(),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_sharp,
                      size: 10, color: Colors.white)
                ],
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: EPColors.appMainColor,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(4, 4),
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 15)
                ]),
          )),
    );
  }
}
