import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bloc/joke/joke_bloc.dart';
import '../../data/repository/joke_repository.dart';

class JokeScreen extends StatelessWidget {
  const JokeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => JokeRepository(),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JokeBloc(
        RepositoryProvider.of<JokeRepository>(context),
      )..add(LoadJokeEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('The Joke App'),
        ),
        body: BlocBuilder<JokeBloc, JokeState>(
          builder: (context, state) {
            if (state is JokeLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is JokeLoadedState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    ExpansionTile(
                      title: Text(
                        state.joke.setup,
                        textAlign: TextAlign.center,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            state.joke.delivery,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<JokeBloc>(context).add(LoadJokeEvent());
                      },
                      child: const Text('Load New Joke'),
                    ),
                  ],
                ),
              );
            }
            if (state is JokeErrorState) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
