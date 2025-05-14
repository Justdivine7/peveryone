import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/main.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';

final toastProvider = Provider<ToastWidget>((ref) => ToastWidget(navigatorKey));
