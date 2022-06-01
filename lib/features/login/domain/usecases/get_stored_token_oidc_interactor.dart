import 'package:core/presentation/state/failure.dart';
import 'package:core/presentation/state/success.dart';
import 'package:core/utils/app_logger.dart';
import 'package:dartz/dartz.dart';
import 'package:model/oidc/token_oidc.dart';
import 'package:tmail_ui_user/features/login/domain/exceptions/authentication_exception.dart';
import 'package:tmail_ui_user/features/login/domain/extensions/uri_extension.dart';
import 'package:tmail_ui_user/features/login/domain/repository/authentication_oidc_repository.dart';
import 'package:tmail_ui_user/features/login/domain/repository/credential_repository.dart';
import 'package:tmail_ui_user/features/login/domain/state/get_stored_token_oidc_state.dart';

class GetStoredTokenOidcInteractor {
  final AuthenticationOIDCRepository _authenticationOIDCRepository;
  final CredentialRepository _credentialRepository;

  GetStoredTokenOidcInteractor(this._authenticationOIDCRepository, this._credentialRepository);

  Stream<Either<Failure, Success>> execute(String tokenIdHash) async* {
    try {
      yield Right<Failure, Success>(LoadingState());
      final futureValue = await Future.wait([
        _credentialRepository.getBaseUrl(),
        _authenticationOIDCRepository.getStoredTokenOIDC(tokenIdHash)
      ], eagerError: true);

      final baseUrl = futureValue.first as Uri;
      final tokenOidc = futureValue.last as TokenOIDC;
      log('GetStoredTokenOidcInteractor::execute(): $tokenOidc');

      if (_isCredentialValid(baseUrl)) {
        yield Right(GetStoredTokenOidcSuccess(baseUrl, tokenOidc));
      } else {
        yield Left(GetStoredTokenOidcFailure(const InvalidBaseUrl()));
      }
    } catch (e) {
      log('GetStoredTokenOidcInteractor::execute(): $e');
      yield Left(GetStoredTokenOidcFailure(e));
    }
  }

  bool _isCredentialValid(Uri baseUrl) => baseUrl.isBaseUrlValid();
}