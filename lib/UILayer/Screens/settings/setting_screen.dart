import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/UILayer/Screens/request_device/request_device_main_page.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/update_bank_info/update_account_information.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/update_pin_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/user_account_verification/verification_main_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/widget/settings_ui.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/controllers/signin_controller.dart';
import '../../../DataLayer/model/login_response_model.dart';
import '../../utils/show_alert_dialog.dart';
import '../../utils/sync_keys.dart';
import 'business_info_screen.dart';
import 'change_organization_screen.dart';
import 'customer_care_screen.dart';
import 'disputes/my_disputes_screen.dart';
import 'manage_beneficiary/beneficiaries_page.dart';
import 'manage_terminals/manage_terminals_screen.dart';
import 'terminal_config_screen.dart';

class SettingScreen extends StatefulWidget {
  final VoidCallback? onRefresh;
  const SettingScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLogout = false;
  bool isDeleteAccount = false;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: RefreshIndicator(
        color: EPColors.appMainColor,
        onRefresh: () async => widget.onRefresh?.call(),
        child: FutureBuilder<UserData?>(
          future: LocalDataStorage.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoaderWidget());
            }

            final user = snapshot.data;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                SettingsProfileCard(user: user),
                SettingsVerificationBanner(
                  isVerified: user?.isStatusCompleted(),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VerificationMainScreen(),
                      ),
                    );
                    widget.onRefresh?.call();
                    setState(() {});
                  },
                ),
                const SettingsSectionLabel('Preferences'),
                SettingsGroupCard(
                  children: [
                    Consumer<BrandingController>(
                      builder: (context, branding, _) {
                        return SettingsMenuTile(
                          icon: Icons.business_outlined,
                          title: 'Organization code',
                          subtitle: branding.hasOrganization
                              ? branding.orgSlug
                              : 'Not set',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ChangeOrganizationScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SettingsThemeTile(),
                  ],
                ),
                const SettingsSectionLabel('Security'),
                SettingsGroupCard(
                  children: [
                    SettingsMenuTile(
                      image: EPImages.changePinIcon,
                      title: 'Change transfer PIN',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UpdatePinScreen(),
                        ),
                      ),
                    ),
                    SettingsMenuTile(
                      image: EPImages.syncKey,
                      title: 'Sync terminal keys',
                      onTap: () =>
                          SyncKeys().init(context, showLoader: true),
                    ),
                    SettingsMenuTile(
                      image: EPImages.manageTerminal,
                      title: 'Terminal configuration',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TerminalConfigScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SettingsSectionLabel('Account'),
                SettingsGroupCard(
                  children: [
                    SettingsMenuTile(
                      image: EPImages.businessInfoIcon,
                      title: 'Business information',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BusinessInfoScreen(),
                        ),
                      ),
                    ),
                    SettingsMenuTile(
                      image: EPImages.updateBankAccount,
                      title: 'Bank account details',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateAccountScreen(
                            refresh: widget.onRefresh,
                          ),
                        ),
                      ),
                    ),
                    SettingsMenuTile(
                      image: EPImages.manageTerminal,
                      title: 'Manage terminals',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageTerminalScreen(),
                        ),
                      ),
                    ),
                    SettingsMenuTile(
                      image: EPImages.requestDevice,
                      title: 'Manage beneficiaries',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BeneficiariesPage(),
                        ),
                      ),
                    ),
                    SettingsMenuTile(
                      image: EPImages.requestDevice,
                      title: 'Request a new device',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RequestDevicePage(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SettingsSectionLabel('Support'),
                SettingsGroupCard(
                  children: [
                    SettingsMenuTile(
                      icon: Icons.gavel_rounded,
                      title: 'Dispute management',
                      subtitle: 'Track disputes you have raised',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyDisputesScreen(),
                        ),
                      ),
                    ),
                    SettingsMenuTile(
                      image: EPImages.customerCare,
                      title: 'Contact customer care',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomerCareScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SettingsSectionLabel('Session'),
                SettingsGroupCard(
                  children: [
                    if (isLogout)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: LoaderIndicator(
                            color: EPColors.appMainColor,
                          ),
                        ),
                      )
                    else
                      SettingsMenuTile(
                        image: EPImages.logOut,
                        title: 'Log out',
                        onTap: () => _confirmLogout(context),
                      ),
                    if (isDeleteAccount)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: EPColors.appDanger,
                          ),
                        ),
                      )
                    else
                      SettingsMenuTile(
                        image: EPImages.deleteAccount,
                        title: 'Delete account',
                        destructive: true,
                        onTap: () => _confirmDelete(context),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showAlertDialog(
      context,
      message: 'Are you sure you want to log out?',
      onTap: () {
        Navigator.pop(context);
        setState(() => isLogout = true);
        SignInController().logOut().whenComplete(() {
          if (!mounted) return;
          setState(() => isLogout = false);
          LocalDataStorage.clearUser();
          Provider.of<DashBoardController>(context, listen: false).clearAll();
          Navigator.pushNamed(context, '/');
        }).onError((_, __) {
          if (!mounted) return;
          setState(() => isLogout = false);
          Provider.of<DashBoardController>(context, listen: false).clearAll();
          LocalDataStorage.clearUser();
          Navigator.pushNamed(context, '/');
        });
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showAlertDialog(
      context,
      message: 'Are you sure you want to delete your account?',
      onTap: () {
        Navigator.pop(context);
        setState(() => isDeleteAccount = true);
        SignInController().deleteAccount().then((value) {
          if (!mounted) return;
          setState(() => isDeleteAccount = false);
          if (value == true) {
            LocalDataStorage.clearUser();
            Provider.of<DashBoardController>(context, listen: false)
                .clearAll();
            Navigator.pushNamed(context, '/');
          }
        }).onError((_, __) {
          if (!mounted) return;
          setState(() => isDeleteAccount = false);
          Provider.of<DashBoardController>(context, listen: false).clearAll();
          LocalDataStorage.clearUser();
          Navigator.pushNamed(context, '/');
        });
      },
    );
  }
}
