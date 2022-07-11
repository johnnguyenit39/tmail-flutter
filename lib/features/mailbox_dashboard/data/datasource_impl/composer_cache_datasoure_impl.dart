import 'dart:convert';
import 'package:jmap_dart_client/jmap/mail/email/email.dart';
import 'package:model/model.dart';
import 'package:tmail_ui_user/features/mailbox_dashboard/data/model/composer_cache.dart';
import 'package:tmail_ui_user/features/mailbox_dashboard/data/datasource/composer_cache_datasource.dart';
import 'package:universal_html/html.dart' as html;

class ComposerCacheDataSourceImpl extends ComposerCacheDataSource {

  @override
  ComposerCache? getComposerCacheOnWeb() {
    final result = html.window.localStorage.entries
        .where((e) => e.key == EmailActionType.edit.name)
        .toList();
    if (result.isNotEmpty) {
      final jsonHandle = json.decode(result.first.value) as Map<String, dynamic>;
      final emailCache = ComposerCache.fromJson(jsonHandle);
      return emailCache;
    } else {
      return null;
    }
  }

  @override
  void removeComposerCacheOnWeb() {
    html.window.localStorage.removeWhere((key, value) => key == EmailActionType.edit.name);
  }

  @override
  void saveComposerCacheOnWeb(Email email) {
    Map<String,String> entries = { EmailActionType.edit.name: json.encode(email.toJson()) };
    html.window.localStorage.addAll(entries);
  }
}