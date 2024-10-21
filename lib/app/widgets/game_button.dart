import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:soundpool/soundpool.dart';

class GameButton extends StatelessWidget {
  GameButton({
    required this.index,
    required this.isBlinking,
    this.shape = BoxShape.circle,
    this.width = 60,
    this.height = 60,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.red,
    this.activeColorShadow = Colors.greenAccent,
    this.inactiveColorShadow = Colors.redAccent,
    this.blinkingColor1 = Colors.black,
    this.blinkingColor2 = Colors.black45,
    this.playSoundPick,
    this.playSoundError,
    super.key,
  });

  final int index;
  final bool isBlinking;
  final BoxShape shape;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeColorShadow;
  final Color inactiveColorShadow;
  final Color blinkingColor1;
  final Color blinkingColor2;
  final Function? playSoundPick;
  final Function? playSoundError;

  // final AudioPlayer _audioPlayer = AudioPlayer();

  Soundpool pool = Soundpool.fromOptions(
    options:
        const SoundpoolOptions(streamType: StreamType.alarm, maxStreams: 2),
  );

  void _playSound(String sound) async {
//    _audioPlayer.play(AssetSource(sound));

    var soundId = await rootBundle.load(sound).then((ByteData soundData) {
      return pool.load(soundData);
    });
    pool.play(soundId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        bool isActive = state is GameInProgress &&
            state.activeButtonIndexes.contains(index);
        bool shouldBlink = state is BlinkingLights && isBlinking;

        return GestureDetector(
          onTap: isActive
              ? () {
                  // _playSound('sounds/pick.wav');
                  // _playSound('sounds/pop' +
                  //     (Random().nextInt(10) + 1).toString() +
                  //     '.wav');
                  // _playSound(soundPick);
                  playSoundPick?.call();

                  context.read<GameBloc>().add(ButtonPressed(index));
                }
              : () {
                  // _playSound(soundError);
                  playSoundError?.call();
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: shouldBlink
                  ? Random().nextBool()
                      ? blinkingColor1
                      : blinkingColor2
                  : (isActive ? activeColor : inactiveColor),
              shape: shape,
              // boxShadow: [
              //   BoxShadow(
              //     color: isActive ? activeColorShadow : inactiveColorShadow,
              //     blurRadius: 10,
              //     spreadRadius: 2,
              //   ),
              // ],
            ),
            child: isActive
                ? Image.asset('assets/images/marble.png')
                : Image.asset('assets/images/marble.png'),
          ),
        );
      },
    );
  }
}
