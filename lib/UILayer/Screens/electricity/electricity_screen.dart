import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/controllers/electric_company_controller.dart';
import 'package:enk_pay_project/DataLayer/model/electricity_model/electric_company_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/bill_payment/bill_payment_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_form_section.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_wallet_picker.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen>
    with ElectricView {
  ElectricCompanyController? _controller;
  String _meterType = 'prepaid';

  @override
  void dispose() {
    _controller?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(title: const Text('Electricity Payment')),
      builder: (_) => FutureBuilder<void>(
        future: Provider.of<ElectricCompanyController>(context, listen: false)
            .fetchElectricCompany(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderWidget(message: 'Loading providers…');
          }
          return Consumer<ElectricCompanyController>(
            builder: (context, provider, _) {
              _controller = provider..setView(this);
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BillPaymentInfoBanner(
                      icon: Icons.bolt_rounded,
                      message:
                          'Pay prepaid or postpaid electricity bills instantly',
                    ),
                    const SizedBox(height: 20),
                    const TransferSectionHeader(step: 1, title: 'Pay from'),
                    TransferWalletPicker(
                      wallets: provider.userWallet ?? [],
                      selected: provider.setWallet,
                      onSelected: (w) {
                        provider.selectedWallet = w;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    const TransferSectionHeader(
                      step: 2,
                      title: 'Discos & meter',
                      subtitle: 'Provider, meter number and plan type',
                    ),
                    TransferFormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Electricity provider',
                              style: billPaymentFieldLabel(context)),
                          const SizedBox(height: 6),
                          _ProviderDropdown(provider: provider),
                          const SizedBox(height: 16),
                          Text('Meter number',
                              style: billPaymentFieldLabel(context)),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TransferInputField(
                                  hintText: 'Enter meter number',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (v) =>
                                      provider.selectMeterNO = v,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _MeterVerifyButton(
                                loading: provider.pageState ==
                                    PageState.loading,
                                enabled:
                                    provider.selectedElectricCompany != null,
                                onTap: provider.bankMeterNoVerification,
                              ),
                            ],
                          ),
                          if (isNotEmpty(provider.meterAccountName)) ...[
                            const SizedBox(height: 12),
                            BillPaymentVerifiedBanner(
                              name: provider.meterAccountName!,
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text('Meter type',
                              style: billPaymentFieldLabel(context)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: BillPaymentPlanChip(
                                  label: 'Prepaid',
                                  selected: _meterType == 'prepaid',
                                  onTap: () {
                                    provider.setProductType = 'prepaid';
                                    setState(() => _meterType = 'prepaid');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: BillPaymentPlanChip(
                                  label: 'Postpaid',
                                  selected: _meterType == 'postpaid',
                                  onTap: () {
                                    provider.setProductType = 'postpaid';
                                    setState(() => _meterType = 'postpaid');
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('Amount (₦)',
                              style: billPaymentFieldLabel(context)),
                          const SizedBox(height: 6),
                          TransferInputField(
                            hintText: 'Enter amount',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => provider.setAmount = v,
                          ),
                          const SizedBox(height: 16),
                          Text('Phone number',
                              style: billPaymentFieldLabel(context)),
                          const SizedBox(height: 6),
                          TransferInputField(
                            hintText: '08012345678',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => provider.phoneNumber = v,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    EPButton(
                      loading: provider.pageState == PageState.loading,
                      title: 'Continue',
                      onTap: () => provider.onStartTransaction(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onPinVerification() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        Provider.of<ElectricCompanyController>(context, listen: false).setPin =
            pin;
        onBuyPower();
      } else {
        onError(message);
      }
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
  void onBuyPower() {
    _controller?.buyPower();
  }
}

class _MeterVerifyButton extends StatelessWidget {
  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  const _MeterVerifyButton({
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled && !loading;

    return Semantics(
      button: true,
      enabled: active,
      label: 'Verify meter number',
      child: Material(
        color: active
            ? EPColors.appMainColor
            : EPColors.appMainColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: active ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderDropdown extends StatelessWidget {
  final ElectricCompanyController provider;

  const _ProviderDropdown({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.inputFill,
      borderRadius: BorderRadius.circular(12),
      child: EPDropdownButton<ElectricCompanyData>(
        itemsListTitle: 'Select provider',
        iconSize: 22,
        value: provider.selectedElectricCompany,
        hint: Text(
          'Choose disco',
          style: TextStyle(color: context.mutedText, fontSize: 13),
        ),
        isExpanded: true,
        underline: const SizedBox.shrink(),
        searchMatcher: (item, text) =>
            (item.name ?? '').toLowerCase().contains(text.toLowerCase()),
        onChanged: (v) => provider.setElectricCompany = v,
        items: (provider.electricCompany ?? [])
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.name ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
