import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

InputDecoration textFieldDecoration(String hint, {EdgeInsets contentPadding}) {
  return InputDecoration(
      fillColor: Colors.grey.withOpacity(0.3),
      contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 10),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: appBorderRadius,
      ));
}

class TextFieldWHeader extends StatelessWidget {
  String header;
  TextEditingController textEditingController;
  Function validator;
  bool multiLine;
  TextCapitalization textCapitalization;
  EdgeInsets contentPadding;
  bool enabled;

  TextFieldWHeader(
      {@required this.header,
      @required this.textEditingController,
      this.validator,
        this.enabled = true,
      this.multiLine = false,
      this.textCapitalization = TextCapitalization.sentences,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: textEditingController,
          validator: validator,
          maxLines: multiLine ? 2 : 1,
          decoration: textFieldDecoration(header, contentPadding: contentPadding),
          textCapitalization: textCapitalization,
          enabled: enabled,
        )
      ],
    );
  }
}
