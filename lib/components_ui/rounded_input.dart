import 'package:ar_sketcher/components_ui/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboard;
  final TextEditingController controller;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.keyboard,
    this.validator,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: keyboard,
        onChanged: onChanged,
        validator: validator,
        cursorColor: Colors.black,
        controller: controller,
        decoration: InputDecoration(
          icon: icon,

          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// class RoundedPasswordField extends State<FormFieldSample> {
//   final ValueChanged<String> onChanged;
//   const RoundedPasswordField({
//     Key key,
//     this.onChanged,
//   }) : super(key: key);
//
//   final bool _obscureText = true;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFieldContainer(
//       child: TextField(
//         obscureText: _obscureText,
//         onChanged: onChanged,
//         cursorColor: Colors.black,
//         decoration: InputDecoration(
//           hintText: "Password",
//           icon: Icon(
//             Icons.lock,
//             color: Colors.black,
//           ),
//           suffixIcon: IconButton(icon: Icon(
//             Icons.visibility,
//             color: Colors.black,),onPressed: (){},),
//             border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }