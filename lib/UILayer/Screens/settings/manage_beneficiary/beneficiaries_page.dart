import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/controllers/beneficiary_controller.dart';
import '../../../../DataLayer/model/bank_list_response.dart';
import '../../../../services/navigation_service.dart';
import '../../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../../CustomWidget/ReUseableWidget/snack_bar.dart';

class BeneficiariesPage extends StatefulWidget {
  const BeneficiariesPage({Key? key}) : super(key: key);

  @override
  State<BeneficiariesPage> createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<BeneficiariesPage>
    with BeneficiaryView {
  var provider;
  @override
  void dispose() {
    super.dispose();
    provider.clear();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BeneficiaryController>(context)
      ..getBeneficiary()
      ..setView(this);
    return EPScaffold(
      state: AppState(pageState: provider.pageState),
      appBar: AppBar(
        title: const Text('Beneficiaries'),
      ),
      builder: (_) => RefreshIndicator(
        onRefresh: () async {
          provider.getBeneficiary();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Column(
            children: [
              EPForm(
                hintText: "Search Beneficiary",
                enabledBorderColor: EPColors.appGreyColor,
                onChange: (v) {
                  provider.filterBeneficiaries(v);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.filteredBeneficiaries.length,
                  itemBuilder: (context, index) {
                    final beneficiary = provider.filteredBeneficiaries[index];
                    return ListTile(
                      title: Text(
                        beneficiary.name ?? "",
                        style: const TextStyle(fontSize: 11),
                      ),
                      subtitle: Text(
                        beneficiary.acctNo ?? "",
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showEditNameDialog(context, beneficiary, (name) {
                                provider.edit(beneficiary.id.toString(), name);
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDeleteConfirmationDialog(context, beneficiary,
                                  () {
                                provider.delete(beneficiary.id.toString());
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showEditNameDialog(BuildContext context, Beneficariy beneficiary,
      Function(String) onSelect) async {
    TextEditingController _nameController =
        TextEditingController(text: beneficiary.name);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Edit Name',
            style: TextStyle(fontSize: 11),
          ),
          content: EPForm(
            controller: _nameController,
            labelText: "Enter new name",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                onSelect(_nameController.text);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context,
      Beneficariy beneficiary, Function() onConfirmDelete) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete ${beneficiary.name}?',
            style: const TextStyle(fontSize: 11),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                onConfirmDelete();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  onError(String message) {
    snackBar(NavigationService.navigatorKey.currentState!.context,
        message: message, forError: true);
  }

  @override
  onSuccess(String message) {
    snackBar(NavigationService.navigatorKey.currentState!.context,
        message: message, forError: false);
    Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pop(
            NavigationService.navigatorKey.currentState!.context));
  }
}
