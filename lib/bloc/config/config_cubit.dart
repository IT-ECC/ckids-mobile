import 'package:bloc/bloc.dart';
import 'package:eccmobile/data/models/response/config_response.dart';
import 'package:eccmobile/data/repository/config_repository.dart';
import 'package:meta/meta.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  final ConfigRepository _configRepository;

  ConfigCubit(this._configRepository) : super(ConfigState(isLoading: true));

  void getVersion() async {
    _configRepository.getConfig().listen((VersionResponse event) {
      emit(state.copyWith(
        isLoading: false,
        versionResponse: event
      ));
    });
  }
}
