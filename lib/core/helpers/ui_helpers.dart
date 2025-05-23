import 'package:flutter/material.dart';

double height(BuildContext context, double height) =>
    MediaQuery.of(context).size.height * height;

double width(BuildContext context, double width) =>
    MediaQuery.of(context).size.width * width;

String? validateField({required String? value, required String fieldName}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }

  return null;
}

String? validatePassword({required String? value, required String fieldName}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }

  if (value.length < 6) {
    return '$fieldName must be at least 6 characters';
  }

  return null;
}
