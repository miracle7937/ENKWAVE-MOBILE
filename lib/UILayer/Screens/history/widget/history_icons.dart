import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_enum.dart';
import 'package:flutter/material.dart';

class HistoryIcon extends StatelessWidget {
  final TransactionEnum transactionEnum;

  const HistoryIcon({super.key, required this.transactionEnum});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EPColors.appMainColor.withValues(alpha: 0.18),
            EPColors.appMainLightColor.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: EPColors.appMainColor.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          _iconAsset(transactionEnum),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  String _iconAsset(TransactionEnum transactionEnum) {
    switch (transactionEnum) {
      case TransactionEnum.cashOut:
      case TransactionEnum.selfCashOutTransfer:
      case TransactionEnum.virtualFundWallet:
        return EPImages.inwardTransaction;
      case TransactionEnum.bankTransfer:
      case TransactionEnum.enkPayTransfer:
        return EPImages.outwardIcon;
      default:
        return EPImages.billsIcon;
    }
  }
}
