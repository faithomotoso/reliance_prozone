import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

InputDecoration textFieldDecoration(String hint) {
  return InputDecoration(
      fillColor: Colors.grey.withOpacity(0.3),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: textFieldBorderRadius,
      ));
}

class TextFieldWHeader extends StatelessWidget {
  String header;
  TextEditingController textEditingController;
  Function validator;
  bool multiLine;

  TextFieldWHeader(
      {@required this.header,
      @required this.textEditingController,
      this.validator,
      this.multiLine = false});

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
          decoration: textFieldDecoration(header),
        )
      ],
    );
  }
}
