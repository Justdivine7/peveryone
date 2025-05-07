import 'package:flutter/material.dart';

double height(BuildContext context, double height) =>
    MediaQuery.of(context).size.height * height;

double width(BuildContext context, double width) =>
    MediaQuery.of(context).size.width * width;