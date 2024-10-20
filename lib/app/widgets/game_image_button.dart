import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:soundpool/soundpool.dart';

class GameImageButton extends StatefulWidget {
  const GameImageButton({
    required this.index,
    required this.isBlinking,
    required this.isPulsing, // Novo parâmetro
    this.shape = BoxShape.circle,
    this.width = 60,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.activeImage = 'assets/images/ball.png',
    this.inactiveImage = 'assets/images/green1.png',
    this.activeColorShadow = Colors.greenAccent,
    this.inactiveColorShadow = Colors.green,
    this.blinkingColor1 = Colors.greenAccent,
    this.blinkingColor2 = Colors.green,
    this.playSoundPick,
    this.playSoundError,
    super.key,
  });

  final int index;
  final bool isBlinking;
  final bool isPulsing; // Novo parâmetro
  final BoxShape shape;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final String activeImage;
  final String inactiveImage;
  final Color activeColorShadow;
  final Color inactiveColorShadow;
  final Color blinkingColor1;
  final Color blinkingColor2;
  final Function? playSoundPick;
  final Function? playSoundError;

  @override
  GameImageButtonState createState() => GameImageButtonState();
}

class GameImageButtonState extends State<GameImageButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Soundpool pool = Soundpool.fromOptions(
    options:
        const SoundpoolOptions(streamType: StreamType.alarm, maxStreams: 2),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // _animation = Tween<double>(begin: 0.8, end: 1.05).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    // );

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Listener para controlar o status da animação
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.isPulsing) {
          _controller.repeat(
              reverse: true); // Repetir a animação se isPulsing for true
        } else {
          _controller.stop();
        }
      }
    });

    if (widget.isPulsing) {
      _controller.forward(); // Começar a animação
    }
  }

  @override
  void didUpdateWidget(covariant GameImageButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Verificar se o valor de isPulsing mudou e iniciar/parar a animação
    if (widget.isPulsing && !_controller.isAnimating) {
      _controller.forward();
    } else if (!widget.isPulsing && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        bool isActive = state is GameInProgress &&
            state.activeButtonIndexes.contains(widget.index);
        bool shouldBlink = state is BlinkingLights && widget.isBlinking;
        // bool isPulsing = widget.isPulsing &&
        //     state is GameInProgress &&
        //     state.activeButtonIndexes.contains(widget.index);

        return GestureDetector(
          onTap: isActive
              ? () {
                  widget.playSoundPick?.call();
                  context.read<GameBloc>().add(ButtonPressed(widget.index));
                }
              : () {
                  widget.playSoundError?.call();
                },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: (widget.width ?? 60) *
                    _animation.value, // Pulsação no width
                height: (widget.height ?? 60) *
                    _animation.value, // Pulsação no height
                decoration: BoxDecoration(
                  shape: widget.shape,
                  boxShadow: [
                    BoxShadow(
                      color: isActive
                          ? widget.activeColorShadow
                          : widget.inactiveColorShadow,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: shouldBlink
                      ? Container(
                          color: Random().nextBool()
                              ? widget.blinkingColor1
                              : widget.blinkingColor2,
                        )
                      : Image.asset(
                          isActive ? widget.activeImage : widget.inactiveImage,
                          fit: BoxFit.cover,
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
