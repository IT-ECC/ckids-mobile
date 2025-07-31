import 'package:bloc/bloc.dart';
import 'package:eccmobile/data/repository/joke_repository.dart';
import 'package:equatable/equatable.dart';
import '../../models/joke_model.dart';

part 'joke_event.dart';
part 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final JokeRepository jokeRepository;

  JokeBloc(this.jokeRepository) : super(JokeInitial()) {
    on<JokeEvent>((event, emit) async {
      emit(JokeLoadingState());
      try {
        final joke = await jokeRepository.getJoke();
        emit(JokeLoadedState(joke));
      } catch (e) {
        emit(JokeErrorState(e.toString()));
      }
    });
  }
}
