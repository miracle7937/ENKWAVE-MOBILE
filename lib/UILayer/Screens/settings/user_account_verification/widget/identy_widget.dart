import 'dart:io';

import 'package:enk_pay_project/Constant/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../Constant/colors.dart';

class IdentityWidget extends StatefulWidget {
  final String? title, subTitle;
  final File? image;
  final VoidCallback? onTap;
  const IdentityWidget(
      {Key? key, this.title, this.subTitle, this.image, this.onTap})
      : super(key: key);

  @override
  State<IdentityWidget> createState() => _IdentityWidgetState();
}

class _IdentityWidgetState extends State<IdentityWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            child: Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: widget.image != null
                        ? Image.file(widget.image!)
                        : Image.asset(EPImages.cloudImageUpload)),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: EPColors.appBlackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.subTitle!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: EPColors.appBlackColor,
                              fontSize: 12,
                            ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: EPColors.appWhiteColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
    );
  }
}
