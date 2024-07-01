import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:button_press_game/app/widgets/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';

class ButtonPressGamePage extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound(String sound) {
    _audioPlayer.play(AssetSource(sound));
  }

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
            message = state.message;
          } else if (state is GameInProgress) {
            message = state.message;
          } else if (state is GameWon) {
            message = state.message;
          } else if (state is GameOver) {
            message = state.message;
          }

          if (state is GameWon) {
            _playSound('assets/sounds/win.wav');
          } else if (state is GameOver) {
            _playSound('assets/sounds/lose.wav');
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message != null && message.isNotEmpty)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(message),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: false,
                    ),
                  ),
                SizedBox(height: 20),
                buildButtonRow(context, 0, 3, state),
                buildButtonRow(context, 3, 4, state),
                buildButtonRow(context, 7, 3, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildButtonRow(
      BuildContext context, int from, int count, GameState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularButton(
              index: index + from, isBlinking: state is BlinkingLights),
        );
      }),
    );
  }
}
