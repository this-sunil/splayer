import 'package:splayer/src/Flexi/animated_play_pause.dart';
import 'package:flutter/material.dart';

class CenterPlayButton extends StatelessWidget {
  const CenterPlayButton({
    Key? key,
    required this.backgroundColor,
    this.iconColor,
    required this.show,
    required this.isPlaying,
    required this.isFinished,
    this.onPressed,
    this.isPhone,
  }) : super(key: key);

  final Color backgroundColor;
  final Color? iconColor;
  final bool show;
  final bool isPlaying;
  final bool isFinished;
  final bool? isPhone;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Center(
        child: UnconstrainedBox(
          child:  AnimatedOpacity(
              opacity: show ? 1.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child:
              InkWell(
                onTap: (){
                  onPressed;
                },
                child:
              DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                // Always set the iconSize on the IconButton, not on the Icon itself:
                // https://github.com/flutter/flutter/issues/52980
                child: IconButton(
                  iconSize: isPhone == null ?  32 : (isPhone! ? 32 : 40),
                  padding: const EdgeInsets.all(12.0),
                  icon: isFinished
                      ? Icon(Icons.replay, color: iconColor)
                      : AnimatedPlayPause(
                    color: iconColor,
                    playing: isPlaying,
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}
