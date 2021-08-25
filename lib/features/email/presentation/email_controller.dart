import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jmap_dart_client/jmap/account_id.dart';
import 'package:jmap_dart_client/jmap/mail/email/email.dart';
import 'package:model/model.dart';
import 'package:tmail_ui_user/features/base/base_controller.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/get_email_content_interactor.dart';
import 'package:tmail_ui_user/features/mailbox_dashboard/presentation/mailbox_dashboard_controller.dart';

class EmailController extends BaseController {

  final mailboxDashBoardController = Get.find<MailboxDashBoardController>();
  final GetEmailContentInteractor _getEmailContentInteractor;

  final emailAddressExpandMode = ExpandMode.COLLAPSE.obs;

  EmailController(this._getEmailContentInteractor);

  @override
  void onReady() {
    super.onReady();
    mailboxDashBoardController.selectedEmail.listen((presentationEmail) {
      toggleDisplayEmailAddressAction(expandMode: ExpandMode.COLLAPSE);
      final accountId = mailboxDashBoardController.accountId.value;
      if (accountId != null && presentationEmail != null) {
        _getEmailContentAction(accountId, presentationEmail.id);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mailboxDashBoardController.selectedEmail.close();
  }

  void _getEmailContentAction(AccountId accountId, EmailId emailId) async {
    consumeState(_getEmailContentInteractor.execute(accountId, emailId));
  }

  @override
  void onData(Either<Failure, Success> newState) {
    super.onData(newState);
  }

  @override
  void onDone() {
  }

  @override
  void onError(error) {
  }

  void toggleDisplayEmailAddressAction({required ExpandMode expandMode}) {
    emailAddressExpandMode.value = expandMode;
  }

  void goToThreadView(BuildContext context) {
    Get.back();
  }
}