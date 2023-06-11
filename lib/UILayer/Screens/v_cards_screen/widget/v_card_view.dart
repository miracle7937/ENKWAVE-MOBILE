import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/card_details_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Constant/image.dart';

class VCardView extends StatelessWidget {
  final CardDetails? cardDetails;
  const VCardView({Key? key, this.cardDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      back: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 220,
            child: Image.asset(
              EPImages.cardView,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
                child: Container(
                  child: Row(
                    children: [
                      Text(
                        cardDetails?.cvv ?? "",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      front: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 220,
            child: Image.asset(
              EPImages.cardView,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        cardDetails?.nameOnCard ?? "",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        "USD ${cardDetails?.amount}",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Text(
                    formatCardPan(cardDetails?.cardNumber ?? ""),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      expireDate(context, cardDetails?.expiration ?? ""),
                      const Spacer(),
                      Text(
                        cardDetails?.cardType ?? "",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String formatCardPan(String cardPan) {
    if (isEmpty(cardPan)) {
      return "";
    }
    final List<String> panSegments = [];

    for (var i = 0; i < cardPan.length; i += 4) {
      final segment = cardPan.substring(i, i + 4);
      panSegments.add(segment);
    }

    return panSegments.join(' ');
  }

  expireDate(BuildContext context, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Expire date",
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          data,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        )
      ],
    );
  }
}
