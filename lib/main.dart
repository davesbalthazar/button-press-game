// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_bloc.dart';

void main() {
  runApp(ButtonPressGameApp());
}

class ButtonPressGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Press Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: ButtonPressGamePage(),
      ),
    );
  }
}

class ButtonPressGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Press Game'),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          String? message = '';

          if (state is GameInitial) {
            message =
                state.message; // Corrigido para acessar a propriedade correta
          } else if (state is GameInProgress) {
            message = state.message;
          } else if (state is GameWon) {
            message = state.message;
          } else if (state is GameOver) {
            message = state.message;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message != null && message.isNotEmpty)
                  Text(
                    message!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                buildButtonRow(context, 3),
                buildButtonRow(context, 4),
                buildButtonRow(context, 3),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularButton(index: index),
        );
      }),
    );
  }
}

class CircularButton extends StatelessWidget {
  final int index;

  CircularButton({required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        bool isActive = state is GameInProgress &&
            state.activeButtonIndexes.contains(index);

        return GestureDetector(
          onTap: isActive
              ? () {
                  context.read<GameBloc>().add(ButtonPressed(index));
                }
              : null,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
