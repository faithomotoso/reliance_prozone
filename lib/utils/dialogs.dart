import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/ui/components/AppButton.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

void showAlertDialog(
    {@required BuildContext context,
      @required String message,
      double width,
      List<Widget> actions}) {
  showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                  width: width ?? constraints.maxWidth * 0.65,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          message,
                          style: TextStyle(
                              inherit: false,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      actions.length > 1
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: actions,
                      )
                          : Center(child: actions.first),
                    ],
                  ));
            },
          ),
        );
      }).then((value) {
    removeKeyboard(context);
  });
}

void showOkDialog(
    {@required BuildContext context,
      @required String message,
      @required VoidCallback onOkButtonPressed,
      double width}) {
  showAlertDialog(context: context, message: message, width: width, actions: [
    Center(
      child: AppButton(
        buttonText: "Ok",
        onPressed: onOkButtonPressed,
        context: context
      ),
    )
  ]);
}

void showYesNoDialog({
  @required BuildContext context,
  @required String message,
  @required VoidCallback noPressed,
  @required VoidCallback yesPressed,
}) {
  showAlertDialog(context: context, message: message, actions: [
    AppButton(
      context: context,
      buttonText: "No",
      onPressed: () => noPressed?.call(),
      buttonColor: Colors.redAccent,
      textColor: Colors.black,
      useOutlineColor: true,
    ),
    SizedBox(width: 12,),
    AppButton(
      context: context,
      buttonText: "Yes",
      onPressed: () => yesPressed?.call(),
    )
  ]);
}
