part of 'user_page_cubit.dart';

@freezed
class UserPageState with _$UserPageState {
  const factory UserPageState.initial() = _Initial;
  const factory UserPageState.loading() = _Loading;
  const factory UserPageState.success(String user, bool? passUpdate) = _Success;
  const factory UserPageState.imagePicked(XFile? image) = _ImagePicked;
  const factory UserPageState.error(String message) = _Error;
}
