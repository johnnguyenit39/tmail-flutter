import 'package:core/presentation/resources/assets_paths.dart';

class ImagePaths {
  String get icTMailLogo => _getImagePath('tmail_logo.svg');
  String get icCloseMailbox => _getImagePath('ic_close.svg');
  String get icSearch => _getImagePath('ic_search.svg');
  String get icNextArrow => _getImagePath('ic_next_arrow.svg');
  String get icMailboxInbox => _getImagePath('ic_mailbox_inbox.svg');
  String get icMailboxTrash => _getImagePath('ic_mailbox_trash.svg');
  String get icMailboxAllMail => _getImagePath('ic_mailbox_allmail.svg');
  String get icMailboxDrafts => _getImagePath('ic_mailbox_draft.svg');
  String get icMailboxSent => _getImagePath('ic_mailbox_sent.svg');
  String get icMailboxSpam => _getImagePath('ic_mailbox_spam.svg');
  String get icMailboxTemplate => _getImagePath('ic_mailbox_template.svg');
  String get icMailboxFolder => _getImagePath('ic_mailbox_folder.svg');
  String get icMailboxNewFolder => _getImagePath('ic_mailbox_new_folder.svg');
  String get icFolderArrow => _getImagePath('ic_folder_arrow.svg');
  String get icExpandFolder => _getImagePath('ic_expand_folder.svg');
  String get icBack => _getImagePath('ic_back.svg');
  String get icEyeDisable => _getImagePath('ic_eye_disable.svg');
  String get icFolder => _getImagePath('ic_folder.svg');
  String get icForward => _getImagePath('ic_forward.svg');
  String get icReply => _getImagePath('ic_reply.svg');
  String get icReplyAll => _getImagePath('ic_reply_all.svg');
  String get icStar => _getImagePath('ic_star.svg');
  String get icTrash => _getImagePath('ic_trash.svg');
  String get icCalendar => _getImagePath('ic_calendar.svg');
  String get icShare => _getImagePath('ic_share.svg');

  String _getImagePath(String imageName) {
    return AssetsPaths.images + imageName;
  }
}