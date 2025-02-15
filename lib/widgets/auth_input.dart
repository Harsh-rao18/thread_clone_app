import 'package:flutter/material.dart';
import 'package:thread_clone_app/utils/type_def.dart';

class AuthInput extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isObsecure;
  final ValidatorCallBack? validator;

  const AuthInput({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObsecure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecure,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        labelText: labelText,
        hintText: hintText,
      ),
      validator: validator,
    );
  }
}
