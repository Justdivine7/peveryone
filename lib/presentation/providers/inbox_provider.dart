import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/data/model/inbox_model/inbox_model.dart';
import 'package:peveryone/presentation/providers/home_view_provider.dart';

final inboxProvider = StreamProvider.family<List<InboxModel>, String>((
  ref,
  userId,
) {
  final repo = ref.watch(homeViewProvider);
  return repo.getInbox(userId);
});
