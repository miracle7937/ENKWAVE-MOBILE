import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_enum.dart';
import 'package:flutter/cupertino.dart';

class HistoryIcon extends StatefulWidget {
  final TransactionEnum transactionEnum;
  const HistoryIcon({Key? key, required this.transactionEnum})
      : super(key: key);

  @override
  State<HistoryIcon> createState() => _HistoryIconState();
}

class _HistoryIconState extends State<HistoryIcon> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(_getIcon(widget.transactionEnum));
  }

  _getIcon(TransactionEnum transactionEnum) {
    String image;
    switch (transactionEnum) {
      case TransactionEnum.TRANSFERIN:
        image = EPImages.inwardTransaction;
        break;
      case TransactionEnum.TRANSFEROUT:
        image = EPImages.outwardIcon;
        break;
      case TransactionEnum.BILLS:
        image = EPImages.billsIcon;
        break;
      case TransactionEnum.REVERSED:
        image = EPImages.refundIcon;
        break;
      case TransactionEnum.POS:
        image = EPImages.posIcons;
        break;
      default:
        image = EPImages.billsIcon;
    }
    return image;
  }
}
