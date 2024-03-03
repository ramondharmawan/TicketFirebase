part of 'auth_page_cubit.dart';

@freezed
class AuthPageState with _$AuthPageState {
  const factory AuthPageState.initial() = Initial;
  const factory AuthPageState.loading() = Loading;
  const factory AuthPageState.success() = Success;
  const factory AuthPageState.error(String message) = Error;
}
