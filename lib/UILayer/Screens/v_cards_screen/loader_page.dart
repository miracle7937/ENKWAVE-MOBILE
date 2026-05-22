import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../DataLayer/controllers/vcard_controller.dart';

class LoaderPage extends StatefulWidget {
  final Function(bool) onChange;
  const LoaderPage({Key? key, required this.onChange}) : super(key: key);

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> with OnGetVCardDetails {
  VCardController? vCardController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vCardController?.getCardDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    vCardController = Provider.of<VCardController>(context)
      ..setGetCardView(this);

    return EPScaffold(
      builder: (_) => const LoaderWidget(message: 'Loading card…'),
    );
  }

  @override
  onError(String message) {
    Navigator.pop(context);
  }

  @override
  onSuccess(String message) {
    Navigator.pop(context);
    widget.onChange(true);
  }

  @override
  noCard(String message) {
    Navigator.pop(context);
    widget.onChange(false);
  }
}
