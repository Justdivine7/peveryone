import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseView extends ConsumerStatefulWidget {
  const BaseView({super.key});

  @override
  ConsumerState<BaseView> createState() => _BaseView();
}

class _BaseView extends ConsumerState<BaseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
