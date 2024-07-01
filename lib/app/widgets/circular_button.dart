import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

class CircularButton extends StatelessWidget {
  final int index;
  final AudioPlayer _audioPlayer = AudioPlayer();

  CircularButton({required this.index});

  void _playSound(String sound) {
    _audioPlayer.play(AssetSource(sound));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        bool isActive = state is GameInProgress &&
            state.activeButtonIndexes.contains(index);

        return GestureDetector(
          onTap: isActive
              ? () {
                  _playSound('assets/sounds/click.wav');
                  context.read<GameBloc>().add(ButtonPressed(index));
                }
              : () {
                  _playSound('assets/sounds/error.wav');
                },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isActive ? Colors.greenAccent : Colors.redAccent,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
