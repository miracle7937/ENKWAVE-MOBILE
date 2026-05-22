import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/text_theme_compat.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EPPageStateWidget extends StatelessWidget {
  final PageState? pageState;
  final Widget? loadingWidget;
  final WidgetBuilder? builder;
  final WidgetBuilder? noDataBuilder;
  final String? textUnderLoader;
  final VoidCallback? onRetry;
  final dynamic error;
  final String? noDataMessage;
  final EdgeInsetsGeometry? padding;

  const EPPageStateWidget({
    Key? key,
    this.pageState,
    this.loadingWidget,
    this.builder,
    this.noDataBuilder,
    this.textUnderLoader,
    this.onRetry,
    this.error,
    this.noDataMessage,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget pageBody = const SizedBox.shrink();
    switch ((pageState ?? PageState.loaded)) {
      case PageState.loading:
        pageBody = loadingWidget ??
            ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SizedBox.expand(
                child: LoaderWidget(
                  message: textUnderLoader ?? 'Loading',
                  showCard: true,
                ),
              ),
            );
        break;
      case PageState.loaded:
        if (builder != null) {
          pageBody = Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            child: Builder(builder: builder!),
          );
        }
        break;
      case PageState.error:
        pageBody = ErrorSwitcher(
          message: 'An error has occurred',
          onRetry: onRetry,
          error: error,
        );
        break;
      case PageState.noData:
        if (noDataBuilder != null) {
          pageBody = Builder(builder: noDataBuilder!);
        } else if (noDataMessage != null) {
          pageBody = NoData(noDataMessage);
        }
        break;
    }

    return pageBody;
  }
}

class NoData extends StatelessWidget {
  const NoData(
    this.message, {
    this.child,
    Key? key,
    this.size = 18,
  }) : super(key: key);

  final Widget? child;
  final String? message;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child ??
          Text(
            message!,
            style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
    );
  }
}

class ErrorSwitcher extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message, subMessage;
  final dynamic error;

  const ErrorSwitcher({
    Key? key,
    this.onRetry,
    this.error,
    @required this.message,
    this.subMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return _ErrorWidget(
      message: message,
      onRetry: onRetry,
      subMessage: subMessage,
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    Key? key,
    this.onRetry,
    @required this.message,
    this.subMessage,
  }) : super(key: key);

  final VoidCallback? onRetry;
  final String? message, subMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Image.asset(
          //   IVImages.ivConnection,
          //   fit: BoxFit.contain,
          // ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Something went wrong",
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: context.primaryText,
                  fontSize: 18,
                ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Lottie.asset(
                EPImages.errorIcons,
              )),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EPButton(
                title: "Retry",
                onTap: onRetry ?? () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
