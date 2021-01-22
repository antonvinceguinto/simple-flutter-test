// Inspired by https://github.com/RedBrogdon/building_for_ios_IO19/blob/master/lib/adaptive_widgets.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdaptiveActivityIndicator extends StatelessWidget {
  const AdaptiveActivityIndicator({
    Key key,
    this.size = 20, // See CupertinoActivityIndicator._kDefaultIndicatorRadius
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return theme.platform == TargetPlatform.iOS
        ? CupertinoActivityIndicator(
            radius: size / 2,
          )
        : Center(
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          );
  }
}

class AdaptiveAlertDialog extends StatelessWidget {
  const AdaptiveAlertDialog({
    Key key,
    this.title,
    this.content,
    this.actions,
  }) : super(key: key);

  final List<Widget> actions;
  final Widget content;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoAlertDialog(
              title: title,
              content: content,
              actions: actions,
            )
          : AlertDialog(
              title: title,
              content: content,
              actions: actions.reversed.toList(),
              shape: theme.cardTheme.shape,
            ),
    );
  }
}

class AdaptiveDialogAction extends StatelessWidget {
  const AdaptiveDialogAction({
    Key key,
    @required this.child,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    @required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return theme.platform == TargetPlatform.iOS
        ? CupertinoDialogAction(
            child: child,
            onPressed: onPressed,
            isDestructiveAction: isDestructiveAction,
            isDefaultAction: isDefaultAction,
          )
        : FlatButton(
            textColor: isDestructiveAction
                ? theme.colorScheme.error
                : theme.buttonColor,
            shape: theme.buttonTheme.shape,
            child: child,
            onPressed: onPressed,
          );
  }
}

Future showGenericNormalAlertDialog(String title, String message,
    {bool barrierDismissible = true, Function onOk}) async {
  if (Get.context == null) {
    return;
  }

  try {
    await showAdaptiveDialog(
      context: Get.context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AdaptiveAlertDialog(
          title: title == null ? SizedBox() : Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            AdaptiveDialogAction(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: onOk == null
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : onOk,
            )
          ],
        );
      },
    );
  } on FlutterError catch (error) {
    print(error);
  }
}

Future<T> showAdaptiveDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  @required WidgetBuilder builder,
}) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? showCupertinoDialog<T>(
          context: context,
          builder: builder,
        )
      : showDialog<T>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: builder,
        );
}

class AdaptiveSimpleDialog extends StatelessWidget {
  const AdaptiveSimpleDialog({
    Key key,
    @required this.title,
    this.content,
    @required this.children,
    this.cancelButton,
  }) : super(key: key);

  final Widget cancelButton;
  final List<Widget> children;
  final Widget content;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return theme.platform == TargetPlatform.iOS
        ? CupertinoActionSheet(
            title: title,
            message: content,
            actions: children,
            cancelButton: cancelButton,
          )
        : SimpleDialog(
            title: title,
            children: [
              if (content != null) ...{
                Padding(
                  padding: const EdgeInsets.only(
                    right: 24,
                    bottom: 8,
                    left: 24,
                  ),
                  child: content,
                ),
              },
              ...children,
            ],
          );
  }
}

class AdaptiveSimpleDialogOption extends StatelessWidget {
  const AdaptiveSimpleDialogOption({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.isDefault = false,
  }) : super(key: key);

  final Widget child;
  final bool isDefault;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoActionSheetAction(
            child: child,
            onPressed: onPressed,
            isDefaultAction: isDefault,
          )
        : SimpleDialogOption(
            child: child,
            onPressed: onPressed,
          );
  }
}

Future<DateTime> showAdaptiveDatePicker({
  @required DateTime firstDateTime,
  @required DateTime initialDateTime,
  @required DateTime lastDateTime,
  Brightness brightness,
}) {
  final theme = Theme.of(Get.context);
  return theme.platform == TargetPlatform.iOS
      ? showCupertinoModalPopup<DateTime>(
          context: Get.context,
          builder: (BuildContext context) {
            return _CupertinoDatePicker(
              firstDateTime: firstDateTime,
              initialDateTime: initialDateTime,
              lastDateTime: lastDateTime,
            );
          },
        )
      : showDatePicker(
          context: Get.context,
          firstDate: firstDateTime,
          initialDate: initialDateTime,
          lastDate: lastDateTime,
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: theme.brightness == Brightness.dark
                  ? ThemeData.dark()
                  : ThemeData.fallback(),
              child: child,
            );
          },
        );
}

class _CupertinoDatePicker extends StatefulWidget {
  const _CupertinoDatePicker({
    Key key,
    @required this.firstDateTime,
    @required this.initialDateTime,
    @required this.lastDateTime,
  }) : super(key: key);

  final DateTime firstDateTime;
  final DateTime initialDateTime;
  final DateTime lastDateTime;

  @override
  __CupertinoDatePickerState createState() => __CupertinoDatePickerState();
}

class __CupertinoDatePickerState extends State<_CupertinoDatePicker> {
  DateTime selectedDateTime;

  @override
  Widget build(BuildContext context) {
    // https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/cupertino/cupertino_picker_demo.dart#L58
    return Container(
      height: 216,
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              // Based on iOS's Address Book behavior
              CupertinoTheme(
                data: CupertinoThemeData(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done'),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(selectedDateTime ?? widget.initialDateTime);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: widget.firstDateTime,
                  minimumYear: widget.firstDateTime.year,
                  initialDateTime: widget.initialDateTime,
                  maximumDate: widget.lastDateTime,
                  maximumYear: widget.lastDateTime.year,
                  onDateTimeChanged: (DateTime value) {
                    selectedDateTime = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
