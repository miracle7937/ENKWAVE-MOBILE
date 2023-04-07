import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../Constant/colors.dart';
import '../selection_listBottom_sheet.dart';
import 'drop_down_helper.dart';

const Duration _kDropdownMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = 60.0;
const double _kDenseButtonHeight = 24.0;
const EdgeInsetsGeometry _kAlignedButtonPadding =
    EdgeInsetsDirectional.only(start: 16.0, end: 4.0);
const EdgeInsets _kUnalignedButtonPadding = EdgeInsets.zero;

class _DropdownMenuPainter extends CustomPainter {
  _DropdownMenuPainter({
    this.color,
    this.elevation,
    this.selectedIndex,
    this.resize,
  })  : _painter = BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2.0),
          boxShadow: kElevationToShadow[elevation],
        ).createBoxPainter(),
        super(repaint: resize);

  final Color? color;
  final int? elevation;
  final int? selectedIndex;
  final Animation<double>? resize;

  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final double selectedItemOffset =
        selectedIndex! * _kMenuItemHeight + kMaterialListPadding.top;
    final Tween<double> top = Tween<double>(
      begin: selectedItemOffset.clamp(0.0, size.height - _kMenuItemHeight),
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin:
          (top.begin! + _kMenuItemHeight).clamp(_kMenuItemHeight, size.height),
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(
        0.0, top.evaluate(resize!), size.width, bottom.evaluate(resize!));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_DropdownMenuPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.elevation != elevation ||
        oldPainter.selectedIndex != selectedIndex ||
        oldPainter.resize != resize;
  }
}

class _DropdownScrollBehavior extends ScrollBehavior {
  const _DropdownScrollBehavior();

  @override
  TargetPlatform getPlatform(BuildContext context) =>
      Theme.of(context).platform;

  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}

class _DropdownMenu<T> extends StatefulWidget {
  const _DropdownMenu({
    Key? key,
    this.padding,
    this.route,
  }) : super(key: key);

  final _DropdownRoute<T>? route;
  final EdgeInsets? padding;

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  CurvedAnimation? _fadeOpacity;
  CurvedAnimation? _resize;

  @override
  void initState() {
    super.initState();

    _fadeOpacity = CurvedAnimation(
      parent: widget.route!.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route!.animation!,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final _DropdownRoute<T> route = widget.route!;
    final double unit = 0.5 / (route.items!.length + 1.5);
    final List<Widget> children = <Widget>[];
    for (int itemIndex = 0; itemIndex < route.items!.length; ++itemIndex) {
      CurvedAnimation opacity;
      if (itemIndex == route.selectedIndex) {
        opacity = CurvedAnimation(
            parent: route.animation!, curve: const Threshold(0.0));
      } else {
        final double start = (0.5 + (itemIndex + 1) * unit).clamp(0.0, 1.0);
        final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
        opacity = CurvedAnimation(
            parent: route.animation!, curve: Interval(start, end));
      }
      children.add(FadeTransition(
        opacity: opacity,
        child: InkWell(
          child: Container(
            padding: widget.padding,
            child: route.items![itemIndex],
          ),
          onTap: () => Navigator.pop(
            context,
            _DropdownRouteResult<T>(route.items![itemIndex].value!),
          ),
        ),
      ));
    }

    return FadeTransition(
      opacity: _fadeOpacity!,
      child: CustomPaint(
        painter: _DropdownMenuPainter(
          color: Theme.of(context).canvasColor,
          elevation: route.elevation,
          selectedIndex: route.selectedIndex,
          resize: _resize,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: Material(
            type: MaterialType.transparency,
            textStyle: route.style,
            child: ScrollConfiguration(
              behavior: const _DropdownScrollBehavior(),
              child: Scrollbar(
                child: ListView(
                  controller: widget.route!.scrollController,
                  padding: kMaterialListPadding,
                  itemExtent: _kMenuItemHeight,
                  shrinkWrap: true,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _DropdownMenuRouteLayout({
    required this.buttonRect,
    required this.menuTop,
    required this.menuHeight,
    required this.textDirection,
  });

  final Rect buttonRect;
  final double menuTop;
  final double menuHeight;
  final TextDirection textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final double maxHeight =
        math.max(0.0, constraints.maxHeight - 2 * _kMenuItemHeight);

    final double width = math.min(constraints.maxWidth, buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        assert(menuTop >= 0.0);
        assert(menuTop + menuHeight <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);
    double left;
    switch (textDirection) {
      case TextDirection.rtl:
        left = buttonRect.right.clamp(0.0, size.width) - childSize.width;
        break;
      case TextDirection.ltr:
        left = buttonRect.left.clamp(0.0, size.width - childSize.width);
        break;
    }
    return Offset(left, menuTop);
  }

  @override
  bool shouldRelayout(_DropdownMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        menuTop != oldDelegate.menuTop ||
        menuHeight != oldDelegate.menuHeight ||
        textDirection != oldDelegate.textDirection;
  }
}

class _DropdownRouteResult<T> {
  const _DropdownRouteResult(this.result);

  final T result;

  @override
  bool operator ==(dynamic other) {
    if (other is! _DropdownRouteResult<T>) return false;
    final _DropdownRouteResult<T> typedOther = other;
    return result == typedOther.result;
  }

  @override
  int get hashCode => result.hashCode;
}

class _DropdownRoute<T> extends PopupRoute<_DropdownRouteResult<T>> {
  _DropdownRoute({
    this.items,
    this.padding,
    this.buttonRect,
    this.selectedIndex,
    this.elevation = 8,
    this.theme,
    @required this.style,
    this.barrierLabel,
  }) : assert(style != null);

  final List<DropdownMenuItem<T>>? items;
  final EdgeInsetsGeometry? padding;
  final Rect? buttonRect;
  final int? selectedIndex;
  final int? elevation;
  final ThemeData? theme;
  final TextStyle? style;

  ScrollController? scrollController;

  @override
  Duration get transitionDuration => _kDropdownMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return _DropdownRoutePage<T>(
        route: this,
        constraints: constraints,
        items: items!,
        padding: padding!,
        buttonRect: buttonRect!,
        selectedIndex: selectedIndex!,
        elevation: elevation!,
        theme: theme!,
        style: style!,
      );
    });
  }

  void _dismiss() {
    navigator?.removeRoute(this);
  }
}

class _DropdownRoutePage<T> extends StatelessWidget {
  const _DropdownRoutePage({
    Key? key,
    this.route,
    this.constraints,
    this.items,
    this.padding,
    this.buttonRect,
    this.selectedIndex,
    this.elevation = 8,
    this.theme,
    this.style,
  }) : super(key: key);

  final _DropdownRoute<T>? route;
  final BoxConstraints? constraints;
  final List<DropdownMenuItem<T>>? items;
  final EdgeInsetsGeometry? padding;
  final Rect? buttonRect;
  final int? selectedIndex;
  final int? elevation;
  final ThemeData? theme;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final double availableHeight = constraints!.maxHeight;
    final double maxMenuHeight = availableHeight - 2.0 * _kMenuItemHeight;

    final double buttonTop = buttonRect!.top;
    final double buttonBottom = math.min(buttonRect!.bottom, availableHeight);

    final double topLimit = math.min(_kMenuItemHeight, buttonTop);
    final double bottomLimit =
        math.max(availableHeight - _kMenuItemHeight, buttonBottom);

    final double selectedItemOffset =
        selectedIndex! * _kMenuItemHeight + kMaterialListPadding.top;

    double menuTop = (buttonTop - selectedItemOffset) -
        (_kMenuItemHeight - buttonRect!.height) / 2.0;
    final double preferredMenuHeight =
        (items!.length * _kMenuItemHeight) + kMaterialListPadding.vertical;

    final double menuHeight = math.min(maxMenuHeight, preferredMenuHeight);

    double menuBottom = menuTop + menuHeight;

    if (menuTop < topLimit) menuTop = math.min(buttonTop, topLimit);

    if (menuBottom > bottomLimit) {
      menuBottom = math.max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    if (route!.scrollController == null) {
      final double scrollOffset = preferredMenuHeight > maxMenuHeight
          ? math.max(0.0, selectedItemOffset - (buttonTop - menuTop))
          : 0.0;
      route!.scrollController =
          ScrollController(initialScrollOffset: scrollOffset);
    }

    final TextDirection textDirection = Directionality.of(context);
    Widget menu = _DropdownMenu<T>(
      route: route,
      padding: padding!.resolve(textDirection),
    );

    if (theme != null) menu = Theme(data: theme!, child: menu);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _DropdownMenuRouteLayout<T>(
              buttonRect: buttonRect!,
              menuTop: menuTop,
              menuHeight: menuHeight,
              textDirection: textDirection,
            ),
            child: menu,
          );
        },
      ),
    );
  }
}

class DropdownButtonHideUnderline extends InheritedWidget {
  const DropdownButtonHideUnderline({
    Key? key,
    required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static bool at(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
            DropdownButtonHideUnderline>() !=
        null;
  }

  @override
  bool updateShouldNotify(DropdownButtonHideUnderline oldWidget) => false;
}

class EPDropdownButton<T> extends StatefulWidget {
  EPDropdownButton({
    Key? key,
    @required this.items,
    this.value,
    this.hint,
    this.disabledHint,
    @required this.onChanged,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 16.0,
    this.isDense = false,
    this.isExpanded = false,
    this.disabled = false,
    this.searchMatcher,
    this.itemsListTitle,
    this.emptyListMessage,
    this.emptyListIcon,
    this.shouldPop,
    this.segregationMap,
    this.defaultSegregationTitleStyle,
    this.segregationTitlePadding,
    this.segregationTitlesStylesMap,
    this.seperatorColor,
    this.hideSegregationTitle = false,
  })  : assert(elevation != null),
        assert(elevation != null),
        assert(iconSize != null),
        assert(isDense != null),
        assert(isExpanded != null),
        super(key: key);

  final List<DropdownMenuItem<T>>? items;

  final T? value;

  final Widget? hint;

  final Widget? disabledHint;

  final ValueChanged<T>? onChanged;

  final bool? disabled;

  final int? elevation;

  final TextStyle? style;

  final Widget? underline;

  final Widget? icon;

  final Color? iconDisabledColor;

  final Color? iconEnabledColor;

  final double? iconSize;

  final bool? isDense;

  final bool? isExpanded;

  final String? itemsListTitle;

  final bool Function(T, String)? searchMatcher;

  final String? emptyListMessage;

  final String? emptyListIcon;

  final bool? shouldPop;

  final Map<String, SegregationFunction<T>>? segregationMap;

  final TextStyle? defaultSegregationTitleStyle;

  final EdgeInsets? segregationTitlePadding;

  final Map<String, TextStyle>? segregationTitlesStylesMap;

  final bool? hideSegregationTitle;

  final Color? seperatorColor;

  @override
  _COXDropdownButtonState<T> createState() => _COXDropdownButtonState<T>();
}

class _COXDropdownButtonState<T> extends State<EPDropdownButton<T>>
    with WidgetsBindingObserver {
  int? _selectedIndex;
  _DropdownRoute<T>? _dropdownRoute;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeDropdownRoute();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _removeDropdownRoute();
  }

  void _removeDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
  }

  @override
  void didUpdateWidget(EPDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    // if (!_enabled) {
    //   return;
    // }

    // assert(widget.value == null ||
    //     widget.items
    //             .where((DropdownMenuItem<T> item) => item.value == widget.value)
    //             .length ==
    //         1);
    _selectedIndex = null;
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  TextStyle get _textStyle =>
      widget.style ??
      Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.w100, color: EPColors.appGreyColor);

  void _handleTap() {
    return displayBottomSheetDropUp();
  }

  displayBottomSheetDropUp() {
    FocusScope.of(context).unfocus();
    return showBottomSheetList<DropdownMenuItem>(
      context: context,
      items: widget.items,
      title: widget.itemsListTitle,
      shouldPop: widget.shouldPop ?? true,
      itemBuilder: (DropdownMenuItem item) {
        return item.child;
      },
      hasSearch: widget.searchMatcher != null,
      searchHint: widget.searchMatcher != null ? 'Search' : null,
      searchMatcher: widget.searchMatcher != null
          ? (DropdownMenuItem item, String text) {
              return widget.searchMatcher!(item.value, text);
            }
          : null,
      onItemSelected: (DropdownMenuItem item) {
        widget.onChanged!(item.value);
      },
      segregationMap: widget.segregationMap?.map(
        (key, value) => MapEntry(
          key,
          (DropdownMenuItem item) {
            return widget.segregationMap![key]!(item.value);
          },
        ),
      ),
      defaultSegregationTitleStyle: widget.defaultSegregationTitleStyle,
      segregationTitlePadding: widget.segregationTitlePadding,
      segregationTitlesStylesMap: widget.segregationTitlesStylesMap,
      seperatorColor: widget.seperatorColor ?? Colors.white,
      hideSegregationTitle: widget.hideSegregationTitle!,
    );
  }

  double get _denseButtonHeight {
    return math.max(
        _textStyle.fontSize!, math.max(widget.iconSize!, _kDenseButtonHeight));
  }

  Color get _iconColor {
    if (_enabled) {
      if (widget.iconEnabledColor != null) {
        return widget.iconEnabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade700;
        case Brightness.dark:
          return Colors.white70;
      }
    } else {
      if (widget.iconDisabledColor != null) {
        return widget.iconDisabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade400;
        case Brightness.dark:
          return Colors.white10;
      }
    }

    assert(false);
  }

  bool get _enabled =>
      widget.items != null &&
      widget.items!.isNotEmpty &&
      widget.onChanged != null &&
      !widget.disabled!;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final List<Widget> items = List<Widget>.from(widget.items ?? []);
    int? hintIndex;
    if (widget.hint != null || (!_enabled && widget.disabledHint != null)) {
      final Widget emplacedHint = _enabled
          ? widget.hint!
          : DropdownMenuItem<Widget>(
              child: widget.disabledHint ?? widget.hint!);
      hintIndex = items.length;
      items.add(DefaultTextStyle(
        style: _textStyle,
        child: IgnorePointer(
          child: emplacedHint,
          ignoringSemantics: false,
        ),
      ));
    }

    final EdgeInsetsGeometry padding = ButtonTheme.of(context).alignedDropdown
        ? _kAlignedButtonPadding
        : _kUnalignedButtonPadding;

    final int index = _selectedIndex ?? hintIndex!;
    Widget innerItemsWidget;
    if (items.isEmpty) {
      innerItemsWidget = Container();
    } else {
      innerItemsWidget = IndexedStack(
        index: index,
        alignment: AlignmentDirectional.centerStart,
        children: items,
      );
    }

    const Icon defaultIcon = Icon(Icons.arrow_drop_down);

    Widget result = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: EPColors.appGreyColor,
            ),
          ),
          child: DefaultTextStyle(
            style: _textStyle,
            child: Container(
              padding: padding.resolve(Directionality.of(context)),
              height: widget.isDense! ? _denseButtonHeight : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.value == null
                      ? Text(
                          widget.itemsListTitle ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: EPColors.appGreyColor),
                        )
                      : Container(),
                  widget.isExpanded!
                      ? Expanded(child: innerItemsWidget)
                      : innerItemsWidget,
                  IconTheme(
                    data: IconThemeData(
                      color: _iconColor,
                      size: widget.iconSize,
                    ),
                    child: widget.disabled!
                        ? Container()
                        : widget.icon ?? defaultIcon,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );

    void showNoItemsDialog() {
      // if (widget.items.isEmpty && _enabled) {
      //   FocusScope.of(context).unfocus();
      //   showHalfExtensibleBottomSheetDialog(context,
      //       body: Column(
      //         children: [
      //           isNotEmpty(widget.emptyListIcon)
      //               ? Image.asset(
      //                   IVImages.chequeStopReason,
      //                 )
      //               : Container(),
      //           IVPadding(
      //             type: WidgetType.TextField,
      //             child: Text(
      //               "${isNotEmpty(widget.emptyListMessage) ? widget.emptyListMessage :  'no_info'}",
      //               style: Theme.of(context).textTheme.bodyText1.copyWith(
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //               textAlign: TextAlign.center,
      //             ),
      //           ),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.stretch,
      //             children: [
      //               IVRaisedButton(
      //                 title: Localization.of(context, 'close'),
      //                 onPressed: () {
      //                   Navigator.pop(context);
      //                 },
      //               ),
      //             ],
      //           ),
      //         ],
      //       ));
      //   return;
      // }
    }

    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: _enabled ? _handleTap : showNoItemsDialog,
        behavior: HitTestBehavior.opaque,
        child: result,
      ),
    );
  }
}

class DropdownButtonFormField<T> extends FormField<T> {
  DropdownButtonFormField({
    Key? key,
    T? value,
    required List<DropdownMenuItem<T>> items,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    Widget? hint,
  })  : assert(decoration != null),
        super(
            key: key,
            onSaved: onSaved,
            initialValue: value,
            validator: validator,
            builder: (FormFieldState<T> field) {
              final InputDecoration effectiveDecoration = decoration
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              return InputDecorator(
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                isEmpty: value == null,
                child: DropdownButtonHideUnderline(
                  child: EPDropdownButton<T>(
                    isDense: true,
                    value: value,
                    items: items,
                    hint: hint,
                    onChanged: field.didChange,
                  ),
                ),
              );
            });

  final ValueChanged<T>? onChanged;

  @override
  FormFieldState<T> createState() => _DropdownButtonFormFieldState<T>();
}

class _DropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  FormField<T> get widget => super.widget;

  @override
  void didChange(T? value) {
    super.didChange(value);
    if ((widget as DropdownButtonFormField).onChanged != null)
      (widget as DropdownButtonFormField).onChanged!(value!);
  }
}
