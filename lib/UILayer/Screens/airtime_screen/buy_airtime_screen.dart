import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/controllers/buy_airtime_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/airtime_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_form_section.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_wallet_picker.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BuyAirtimeScreen extends StatefulWidget {
  const BuyAirtimeScreen({super.key});

  @override
  State<BuyAirtimeScreen> createState() => _BuyAirtimeScreenState();
}

class _BuyAirtimeScreenState extends State<BuyAirtimeScreen> with AirtimeView {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late AirtimeController _airtimeController;

  @override
  void dispose() {
    _airtimeController.clearData();
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _airtimeController = Provider.of<AirtimeController>(context)
      ..setView(this)
      ..getWallet();

    return EPScaffold(
      appBar: EPAppBar(title: const Text('Buy Airtime')),
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: EPColors.appMainColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: EPColors.appMainColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_android_rounded, color: EPColors.appMainColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Top up any Nigerian network instantly',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            height: 1.35,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(
              step: 1,
              title: 'Network',
              subtitle: 'Select provider',
            ),
            TransferFormCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: AirtimeSelector(
                onSelect: (value) => _airtimeController.setAirtimeType = value,
              ),
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(
              step: 2,
              title: 'Pay from',
            ),
            TransferWalletPicker(
              wallets: _airtimeController.userWallet ?? [],
              selected: _airtimeController.selectedUserWallet,
              onSelected: (w) {
                _airtimeController.selectWallet = w;
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(
              step: 3,
              title: 'Recipient & amount',
            ),
            TransferFormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Phone number',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.mutedText,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 6),
                  TransferInputField(
                    controller: _phoneController,
                    hintText: '08012345678',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (v) => _airtimeController.setPhone = v,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        final phone = await LocalDataStorage.getPhone();
                        if (phone != null && mounted) {
                          _phoneController.text = phone;
                          _airtimeController.setPhone = phone;
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.contact_phone_outlined, size: 18),
                      label: const Text('Use my number'),
                      style: TextButton.styleFrom(
                        foregroundColor: EPColors.appMainColor,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.mutedText,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 6),
                  TransferInputField(
                    controller: _amountController,
                    hintText: 'Enter amount',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (v) => _airtimeController.setAmount = v,
                  ),
                  const SizedBox(height: 12),
                  _QuickAmountChips(
                    amounts: const [100, 200, 500, 1000],
                    onSelected: (v) {
                      _amountController.text = v;
                      _airtimeController.setAmount = v;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            EPButton(
              loading: _airtimeController.pageState == PageState.loading,
              title: 'Continue',
              onTap: () => _airtimeController.onSummit(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onError(String message) {
    if (!mounted) return;
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void onPInVerify() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        _airtimeController.setPin = pin;
        onBuyAirtime();
      } else {
        onError(message);
      }
    });
  }

  @override
  void onBuyAirtime() {
    _airtimeController.buyAirtel();
  }
}

class _QuickAmountChips extends StatelessWidget {
  final List<int> amounts;
  final ValueChanged<String> onSelected;

  const _QuickAmountChips({
    required this.amounts,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amounts.map((amount) {
        return Material(
          color: EPColors.appMainColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => onSelected(amount.toString()),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: EPColors.appMainColor.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'NGN $amount',
                style: TextStyle(
                  color: EPColors.appMainColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
