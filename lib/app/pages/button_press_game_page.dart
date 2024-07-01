import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:button_press_game/app/widgets/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

          print(state);

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
                buildButtonRow(context, 0, 3),
                buildButtonRow(context, 3, 4),
                buildButtonRow(context, 7, 3),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, int from, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularButton(index: index + from),
        );
      }),
    );
  }
}
