import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/on_mobile_data_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/mobile_data_controller.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/Screens/data_screen/mobile_data_plan_sheet.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/airtime_selector.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_form_section.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_wallet_picker.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BuyDataScreen extends StatefulWidget {
  const BuyDataScreen({super.key});

  @override
  State<BuyDataScreen> createState() => _BuyDataScreenState();
}

class _BuyDataScreenState extends State<BuyDataScreen> with OnMobileDataView {
  final TextEditingController _phoneController = TextEditingController();
  late MobileDataController _mobileDataController;
  String _amount = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = context.read<MobileDataController>();
      controller.setView = this;
      controller.initialize();
    });
  }

  @override
  void dispose() {
    _mobileDataController.clearData();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mobileDataController = Provider.of<MobileDataController>(context);

    return EPScaffold(
      appBar: EPAppBar(title: const Text('Buy Data')),
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
                  Icon(Icons.wifi_rounded, color: EPColors.appMainColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Buy data bundles for any network',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            height: 1.35,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (_mobileDataController.productFetchError != null) ...[
              const SizedBox(height: 12),
              Material(
                color: EPColors.appDanger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: EPColors.appDanger, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _mobileDataController.productFetchError!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: EPColors.appDanger,
                                height: 1.3,
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _mobileDataController.clearResponse();
                          _mobileDataController.initialize();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const TransferSectionHeader(
              step: 1,
              title: 'Network',
              subtitle: 'Select provider',
            ),
            TransferFormCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: AirtimeSelector(
                onSelect: (value) {
                  _mobileDataController.setNetworkSelector = value;
                  _mobileDataController.basePackage = null;
                  setState(() {
                    _amount = '';
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(step: 2, title: 'Pay from'),
            TransferWalletPicker(
              wallets: _mobileDataController.getAccount(),
              selected: _mobileDataController.userWallet,
              onSelected: (w) {
                _mobileDataController.pickWallet(w);
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            const TransferSectionHeader(
              step: 3,
              title: 'Details',
              subtitle: 'Phone number and data plan',
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
                    onChanged: (v) => _mobileDataController.setPhoneNumber = v,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        final phone = await LocalDataStorage.getPhone();
                        if (phone != null && mounted) {
                          _phoneController.text = phone;
                          _mobileDataController.setPhoneNumber = phone;
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
                  const SizedBox(height: 12),
                  Text(
                    'Data plan',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.mutedText,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Material(
                    color: context.isDarkMode
                        ? const Color(0xFF120A1C)
                        : EPColors.appSurface,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _selectDataPackage,
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
                                _mobileDataController.basePackage?.getDesc ??
                                    'Choose a data bundle',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _mobileDataController
                                                  .basePackage !=
                                              null
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
                ],
              ),
            ),
            if (isNotEmpty(_amount)) ...[
              const SizedBox(height: 16),
              TransferSummaryCard(
                label: 'Plan amount',
                amount: amountFormatterWithoutDecimal(_amount),
              ),
            ],
            const SizedBox(height: 28),
            EPButton(
              loading: _mobileDataController.pageState == PageState.loading,
              title: 'Continue',
              onTap: () => _mobileDataController.validateDataForm(),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDataPackage() {
    if (_mobileDataController.getNetworkSelector == null) {
      snackBar(context, message: 'Select a network first', forError: true);
      return;
    }

    if (_mobileDataController.pageState == PageState.loading) {
      snackBar(context, message: 'Loading data bundles…');
      return;
    }

    List<BasePackage>? packages;
    switch (_mobileDataController.getNetworkSelector) {
      case NetworkSelector.mtn:
        packages = _mobileDataController.getMTNDataProduct();
        break;
      case NetworkSelector.glo:
        packages = _mobileDataController.getGloDataProduct();
        break;
      case NetworkSelector.airtel:
        packages = _mobileDataController.getAirtelDataProduct();
        break;
      case NetworkSelector.n9Mobile:
        packages = _mobileDataController.get9mobileDataProduct();
        break;
      default:
        break;
    }

    if (packages == null || packages.isEmpty) {
      final err = _mobileDataController.productFetchError;
      snackBar(
        context,
        message: err ??
            'No data bundles for this network. Pull to retry or check VTpass on the server.',
        forError: true,
      );
      return;
    }

    showMobileDataPlanSheet(
      context,
      packages: packages,
      onSelected: (package) {
        setState(() {
          _amount = package.getAmount ?? '';
          _mobileDataController.setPackage = package;
        });
      },
    );
  }

  @override
  void onPInVerify() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        _mobileDataController.setPin = pin;
        onBuyData();
      } else {
        onError(message);
      }
    });
  }

  @override
  void onBuyData() {
    _mobileDataController.onBuyMobileData();
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
}
