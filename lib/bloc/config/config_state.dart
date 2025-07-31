part of 'config_cubit.dart';

class ConfigState {
  final VersionResponse? versionResponse;
  final bool isLoading;

  ConfigState({this.versionResponse, required this.isLoading});

  ConfigState copyWith({
    VersionResponse? versionResponse,
    bool? isLoading,
  }) {
    return ConfigState(
      isLoading: isLoading ?? this.isLoading,
      versionResponse: versionResponse ?? this.versionResponse
    );
  }
}
