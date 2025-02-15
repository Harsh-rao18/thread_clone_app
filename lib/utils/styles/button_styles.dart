import 'package:flutter/material.dart';

ButtonStyle customOutlineStyle() {
  return ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
    ),
  );
}
