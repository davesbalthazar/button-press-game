import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:button_press_game/app/bloc/game_bloc.dart';

class CircularButton extends StatelessWidget {
  final int index;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final bool isBlinking;

  CircularButton({required this.index, required this.isBlinking});

  void _playSound(String sound) {
    _audioPlayer.play(AssetSource(sound));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        bool isActive = state is GameInProgress &&
            state.activeButtonIndexes.contains(index);
        bool shouldBlink = state is BlinkingLights && isBlinking;
        // bool blinking = state is BlinkingLights;

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
            duration: Duration(milliseconds: 500),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: shouldBlink
                  ? Random().nextBool()
                      ? Colors.black45
                      : Colors.black
                  : (isActive ? Colors.green : Colors.red),
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
