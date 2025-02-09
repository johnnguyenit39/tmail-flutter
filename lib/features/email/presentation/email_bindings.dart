import 'package:core/core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmail_ui_user/features/base/base_bindings.dart';
import 'package:tmail_ui_user/features/caching/state_cache_client.dart';
import 'package:tmail_ui_user/features/email/data/datasource/email_datasource.dart';
import 'package:tmail_ui_user/features/email/data/datasource/html_datasource.dart';
import 'package:tmail_ui_user/features/email/data/datasource_impl/email_datasource_impl.dart';
import 'package:tmail_ui_user/features/email/data/datasource_impl/html_datasource_impl.dart';
import 'package:tmail_ui_user/features/email/data/local/html_analyzer.dart';
import 'package:tmail_ui_user/features/email/data/network/email_api.dart';
import 'package:tmail_ui_user/features/email/data/repository/email_repository_impl.dart';
import 'package:tmail_ui_user/features/email/domain/repository/email_repository.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/download_attachment_for_web_interactor.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/download_attachments_interactor.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/export_attachment_interactor.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/get_email_content_interactor.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/mark_as_email_read_interactor.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/move_to_mailbox_interactor.dart';
import 'package:tmail_ui_user/features/email/domain/usecases/mark_as_star_email_interactor.dart';
import 'package:tmail_ui_user/features/email/presentation/email_controller.dart';
import 'package:tmail_ui_user/features/login/data/datasource/account_datasource.dart';
import 'package:tmail_ui_user/features/login/data/datasource/authentication_oidc_datasource.dart';
import 'package:tmail_ui_user/features/login/data/datasource_impl/authentication_oidc_datasource_impl.dart';
import 'package:tmail_ui_user/features/login/data/datasource_impl/hive_account_datasource_impl.dart';
import 'package:tmail_ui_user/features/login/data/local/account_cache_manager.dart';
import 'package:tmail_ui_user/features/login/data/local/oidc_configuration_cache_manager.dart';
import 'package:tmail_ui_user/features/login/data/local/token_oidc_cache_manager.dart';
import 'package:tmail_ui_user/features/login/data/network/authentication_client/authentication_client_base.dart';
import 'package:tmail_ui_user/features/login/data/network/config/authorization_interceptors.dart';
import 'package:tmail_ui_user/features/login/data/network/oidc_http_client.dart';
import 'package:tmail_ui_user/features/login/data/repository/account_repository_impl.dart';
import 'package:tmail_ui_user/features/login/data/repository/authentication_oidc_repository_impl.dart';
import 'package:tmail_ui_user/features/login/data/repository/credential_repository_impl.dart';
import 'package:tmail_ui_user/features/login/domain/repository/account_repository.dart';
import 'package:tmail_ui_user/features/login/domain/repository/authentication_oidc_repository.dart';
import 'package:tmail_ui_user/features/login/domain/repository/credential_repository.dart';
import 'package:tmail_ui_user/features/login/domain/usecases/refresh_token_oidc_interactor.dart';
import 'package:tmail_ui_user/features/mailbox/data/datasource/mailbox_datasource.dart';
import 'package:tmail_ui_user/features/mailbox/data/datasource/state_datasource.dart';
import 'package:tmail_ui_user/features/mailbox/data/datasource_impl/mailbox_cache_datasource_impl.dart';
import 'package:tmail_ui_user/features/mailbox/data/datasource_impl/mailbox_datasource_impl.dart';
import 'package:tmail_ui_user/features/mailbox/data/datasource_impl/state_datasource_impl.dart';
import 'package:tmail_ui_user/features/mailbox/data/local/mailbox_cache_manager.dart';
import 'package:tmail_ui_user/features/mailbox/data/network/mailbox_api.dart';
import 'package:tmail_ui_user/features/mailbox/data/network/mailbox_isolate_worker.dart';
import 'package:tmail_ui_user/features/mailbox/data/repository/mailbox_repository_impl.dart';
import 'package:tmail_ui_user/features/mailbox/domain/repository/mailbox_repository.dart';

class EmailBindings extends BaseBindings {

  @override
  void bindingsController() {
    Get.put(EmailController(
        Get.find<GetEmailContentInteractor>(),
        Get.find<MarkAsEmailReadInteractor>(),
        Get.find<DownloadAttachmentsInteractor>(),
        Get.find<DeviceManager>(),
        Get.find<ExportAttachmentInteractor>(),
        Get.find<MoveToMailboxInteractor>(),
        Get.find<MarkAsStarEmailInteractor>(),
        Get.find<DownloadAttachmentForWebInteractor>(),
    ));
  }

  @override
  void bindingsDataSource() {
    Get.lazyPut<MailboxDataSource>(() => Get.find<MailboxDataSourceImpl>());
    Get.lazyPut<EmailDataSource>(() => Get.find<EmailDataSourceImpl>());
    Get.lazyPut<HtmlDataSource>(() => Get.find<HtmlDataSourceImpl>());
    Get.lazyPut<StateDataSource>(() => Get.find<StateDataSourceImpl>());
    Get.lazyPut<AccountDatasource>(() => Get.find<HiveAccountDatasourceImpl>());
    Get.lazyPut<AuthenticationOIDCDataSource>(() => Get.find<AuthenticationOIDCDataSourceImpl>());
  }

  @override
  void bindingsDataSourceImpl() {
    Get.lazyPut(() => MailboxDataSourceImpl(Get.find<MailboxAPI>(), Get.find<MailboxIsolateWorker>()));
    Get.lazyPut(() => MailboxCacheDataSourceImpl(Get.find<MailboxCacheManager>()));
    Get.lazyPut(() => EmailDataSourceImpl(Get.find<EmailAPI>()));
    Get.lazyPut(() => HiveAccountDatasourceImpl(Get.find<AccountCacheManager>()));
    Get.lazyPut(() => HtmlDataSourceImpl(
        Get.find<HtmlAnalyzer>(),
        Get.find<DioClient>(),
    ));
    Get.lazyPut(() => StateDataSourceImpl(Get.find<StateCacheClient>()));
    Get.lazyPut(() => AuthenticationOIDCDataSourceImpl(
        Get.find<OIDCHttpClient>(),
        Get.find<AuthenticationClientBase>(),
        Get.find<TokenOidcCacheManager>(),
        Get.find<OidcConfigurationCacheManager>()
    ));
  }

  @override
  void bindingsInteractor() {
    Get.lazyPut(() => GetEmailContentInteractor(Get.find<EmailRepository>()));
    Get.lazyPut(() => MarkAsEmailReadInteractor(
        Get.find<EmailRepository>(),
        Get.find<MailboxRepository>()));
    Get.lazyPut(() => DownloadAttachmentsInteractor(
        Get.find<EmailRepository>(),
        Get.find<CredentialRepository>(),
        Get.find<AccountRepository>(),
        Get.find<AuthenticationOIDCRepository>(),
        Get.find<AuthorizationInterceptors>(),
    ));
    Get.lazyPut(() => ExportAttachmentInteractor(
        Get.find<EmailRepository>(),
        Get.find<CredentialRepository>(),
        Get.find<AccountRepository>(),
        Get.find<AuthenticationOIDCRepository>(),
    ));
    Get.lazyPut(() => MoveToMailboxInteractor(
        Get.find<EmailRepository>(),
        Get.find<MailboxRepository>()));
    Get.lazyPut(() => MarkAsStarEmailInteractor(Get.find<EmailRepository>()));
    Get.lazyPut(() => DownloadAttachmentForWebInteractor(
      Get.find<EmailRepository>(),
      Get.find<CredentialRepository>(),
      Get.find<AccountRepository>(),
      Get.find<AuthenticationOIDCRepository>()));
    Get.lazyPut(() => RefreshTokenOIDCInteractor(
      Get.find<AuthenticationOIDCRepository>(),
      Get.find<AccountRepository>(),
    ));
  }

  @override
  void bindingsRepository() {
    Get.lazyPut<MailboxRepository>(() => Get.find<MailboxRepositoryImpl>());
    Get.lazyPut<EmailRepository>(() => Get.find<EmailRepositoryImpl>());
    Get.lazyPut<CredentialRepository>(() => Get.find<CredentialRepositoryImpl>());
    Get.lazyPut<AccountRepository>(() => Get.find<AccountRepositoryImpl>());
    Get.lazyPut<AuthenticationOIDCRepository>(() => Get.find<AuthenticationOIDCRepositoryImpl>());
  }

  @override
  void bindingsRepositoryImpl() {
    Get.lazyPut(() => MailboxRepositoryImpl(
      {
        DataSourceType.network: Get.find<MailboxDataSource>(),
        DataSourceType.local: Get.find<MailboxCacheDataSourceImpl>()
      },
      Get.find<StateDataSource>(),
    ));
    Get.lazyPut(() => EmailRepositoryImpl(
        Get.find<EmailDataSource>(),
        Get.find<HtmlDataSource>(),
        Get.find<StateDataSource>()
    ));
    Get.lazyPut(() => CredentialRepositoryImpl(Get.find<SharedPreferences>()));
    Get.lazyPut(() => AccountRepositoryImpl(Get.find<AccountDatasource>()));
    Get.lazyPut(() => AuthenticationOIDCRepositoryImpl(Get.find<AuthenticationOIDCDataSource>()));
  }
}