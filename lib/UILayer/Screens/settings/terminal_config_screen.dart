import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/terminal_config_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/widget/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TerminalConfigScreen extends StatefulWidget {
  const TerminalConfigScreen({super.key});

  @override
  State<TerminalConfigScreen> createState() => _TerminalConfigScreenState();
}

class _TerminalConfigScreenState extends State<TerminalConfigScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TerminalConfigController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TerminalConfigController>();

    return EPScaffold(
      state: AppState(pageState: controller.pageState),
      appBar: EPAppBar(title: const Text('Terminal configuration')),
      builder: (_) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'POS host, component keys, and API base URL used for card transactions and key sync.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 20),
          SettingsGroupCard(
            children: [
              _field('Host IP', controller.ipController),
              _field('Port', controller.portController),
              _field('SSL', controller.sslController),
              _field('Component key 1', controller.compKey1Controller),
              _field('Component key 2', controller.compKey2Controller),
              _field('API base URL', controller.baseUrlController),
              _field('Logo URL', controller.logoUrlController),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: EPColors.appMainColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: controller.pageState == PageState.loading
                  ? null
                  : () async {
                      final ok = await controller.save();
                      if (!context.mounted) return;
                      if (ok) {
                        snackBar(context, message: 'Terminal configuration saved');
                        Navigator.pop(context);
                      } else {
                        snackBar(context,
                            message: 'Could not save configuration', forError: true);
                      }
                    },
              child: const Text('Save configuration'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
      ),
    );
  }
}
