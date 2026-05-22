import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/cable_tv_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/cable_tv_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/cable_tv_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/bill_payment/bill_payment_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/airtime_screen/airtime_transaction_preview.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_form_section.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_wallet_picker.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CableTVScreen extends StatefulWidget {
  const CableTVScreen({super.key});

  @override
  State<CableTVScreen> createState() => _CableTVScreenState();
}

class _CableTVScreenState extends State<CableTVScreen> with OnCableTV {
  late CableTVController _controller;
  final TextEditingController _decoderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _amount = '';
  String _productType = 'prepaid';

  @override
  void dispose() {
    _decoderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<CableTVController>(context)..setView = this;

    return EPScaffold(
      appBar: EPAppBar(title: const Text('Cable TV')),
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BillPaymentInfoBanner(
              icon: Icons.tv_rounded,
              message: 'Renew DSTV, GOtv, StarTimes or Showmax subscriptions',
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(
              step: 1,
              title: 'Provider',
              subtitle: 'Select your cable network',
            ),
            TransferFormCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: CableTVSelector(
                initialSelection: _controller.getCableEnum,
                onSelect: (value) {
                  _controller.setCableTVSelector = value;
                  _controller.customerName = null;
                  _controller.basePackage = null;
                  setState(() {
                    _amount = '';
                    _decoderController.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(step: 2, title: 'Pay from'),
            TransferWalletPicker(
              wallets: _controller.getAccount() ?? [],
              selected: _controller.selectedUserWallet,
              onSelected: (w) {
                _controller.selectWallet = w;
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(
              step: 3,
              title: 'Subscription details',
              subtitle: 'Decoder, plan type and package',
            ),
            TransferFormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Plan type',
                    style: billPaymentFieldLabel(context),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: BillPaymentPlanChip(
                          label: 'Prepaid',
                          selected: _productType == 'prepaid',
                          onTap: () {
                            _controller.setProductType = 'prepaid';
                            setState(() => _productType = 'prepaid');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BillPaymentPlanChip(
                          label: 'Postpaid',
                          selected: _productType == 'postpaid',
                          onTap: () {
                            _controller.setProductType = 'postpaid';
                            setState(() => _productType = 'postpaid');
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_controller.getCableEnum != null) ...[
                    const SizedBox(height: 16),
                    Text('Decoder / smartcard number',
                        style: billPaymentFieldLabel(context)),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TransferInputField(
                            controller: _decoderController,
                            hintText: 'Enter decoder number',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => _controller.setDecoderNumber(v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 96,
                          child: EPButton(
                            loading:
                                _controller.pageState == PageState.loading,
                            title: 'Verify',
                            onTap: _controller.getCableEnum == null
                                ? null
                                : () => _controller.searchLook(),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (isNotEmpty(_controller.customerName)) ...[
                    const SizedBox(height: 12),
                    BillPaymentVerifiedBanner(
                      name: _controller.customerName!,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text('Cable package', style: billPaymentFieldLabel(context)),
                  const SizedBox(height: 6),
                  Material(
                    color: context.inputFill,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _controller.getCableEnum == null
                          ? null
                          : _selectPackage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _controller.basePackage?.dataDesc ??
                                    (_controller.getCableEnum == null
                                        ? 'Select a provider first'
                                        : 'Choose a package'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _controller.basePackage != null
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                          : context.mutedText,
                                    ),
                              ),
                            ),
                            Icon(
                              Icons.expand_more_rounded,
                              color: context.mutedText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Notification phone', style: billPaymentFieldLabel(context)),
                  const SizedBox(height: 6),
                  TransferInputField(
                    controller: _phoneController,
                    hintText: '08012345678',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (v) => _controller.setPhone(v),
                  ),
                ],
              ),
            ),
            if (isNotEmpty(_amount)) ...[
              const SizedBox(height: 16),
              TransferSummaryCard(
                label: 'Package amount',
                amount: amountFormatterWithoutDecimal(_amount),
              ),
            ],
            const SizedBox(height: 28),
            EPButton(
              title: 'Continue',
              onTap: isNotEmpty(_amount) ? onPreview : null,
            ),
          ],
        ),
      ),
    );
  }

  void _selectPackage() {
    final packages = _controller.getSelectedProduct();
    if (packages == null || packages.isEmpty) {
      onError('No packages available for this provider');
      return;
    }
    showListOFDataPackage(context, packages, (package) {
      setState(() {
        _controller.selectPackage = package;
        _amount = package.getAmount?.toString() ?? '';
      });
    });
  }

  @override
  void onBuyData() {
    _controller.payment();
  }

  @override
  void onError(String message) {
    if (!mounted) return;
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onPInVerify() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        onBuyData();
      } else {
        onError(message);
      }
    });
  }

  @override
  void onPreview() async {
    if (!_controller.validateForm()) return;
    final isPop = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AirtimeTransactionPreview()),
    );
    if (isPop == true && mounted) {
      onPInVerify();
    }
  }

  @override
  void onSuccess(String message) {
    if (!mounted) return;
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
