import 'package:flutter/material.dart';
import 'package:thread_clone_app/core/utils/type_def.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final InputCallBack callBack;
  const SearchInput({super.key, required this.controller, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: callBack,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: const Color(0xff242424),
        hintText: "search user..",
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
