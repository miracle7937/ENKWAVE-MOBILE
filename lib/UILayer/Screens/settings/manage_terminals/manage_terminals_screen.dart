import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/manage_terminals/terminal_history_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../DataLayer/controllers/manage_terminal_controller.dart';
import '../../../CustomWidget/ReUseableWidget/snack_bar.dart';

class ManageTerminalScreen extends StatefulWidget {
  const ManageTerminalScreen({Key? key}) : super(key: key);

  @override
  State<ManageTerminalScreen> createState() => _ManageTerminalScreenState();
}

class _ManageTerminalScreenState extends State<ManageTerminalScreen>
    with OnGetTerminal {
  late ManageTerminalController controller;
  @override
  void dispose() {
    super.dispose();
    controller.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<ManageTerminalController>(context)
      ..getListOFTerminal()
      ..onGetTerminal = this;
    return EPScaffold(
      state: AppState(pageState: controller.pageState),
      appBar: EPAppBar(
        title: const Text("MANAGE TERMINALS"),
      ),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "List of Active Terminals",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Colors.black87, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 30,
          ),
          (controller.terminalData ?? []).isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: controller.terminalData?.length ?? 0,
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            ListTile(
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                controller.setSelectedTerminal =
                                    controller.terminalData?[index];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const TerminalHistoryScreen()));
                              },
                              title: Text(
                                controller.terminalData?[index].description ??
                                    "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                              ),
                              subtitle: Text(
                                controller.terminalData?[index].serialNo ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87),
                              ),
                            ),
                            const Divider()
                          ],
                        );
                      }))
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.list,
                        size: 50,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "No Terminals",
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  @override
  onError(String? message) {
    snackBar(context, message: message);
  }

  @override
  onSuccess(String? message) {}
}
