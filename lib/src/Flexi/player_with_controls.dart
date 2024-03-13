import 'package:splayer/src/Flexi/flexi_player.dart';
import 'package:splayer/src/Flexi/helpers/adaptive_controls.dart';
import 'package:splayer/src/Flexi/notifiers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class PlayerWithControls extends StatelessWidget {
  final String tag;
  const PlayerWithControls({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final FlexiController flexiController = FlexiController.of(context);





    Widget buildControls(
      BuildContext context,
      FlexiController flexiController,

    ) {
      return flexiController.showControls
          ? flexiController.customControls ??   AdaptiveControls(tag:tag)
          : const SizedBox();
    }

    Widget buildPlayerWithControls(
      FlexiController flexiController,
      BuildContext context,
    ) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (flexiController.placeholder != null)
            flexiController.placeholder!,
          InteractiveViewer(
            transformationController: flexiController.transformationController,
            maxScale: flexiController.maxScale,
            panEnabled: flexiController.zoomAndPan,
            panAxis: PanAxis.free,
            scaleEnabled: flexiController.zoomAndPan,
            child:FittedBox(
              fit: BoxFit.cover,
                child:Container(
                  color: Colors.red,
                  width: MediaQuery.sizeOf(context).width,
                  height: 500,
                  child:  VideoPlayer(flexiController.videoPlayerController),
                ),

            ),
          ),

          if (flexiController.overlay != null) flexiController.overlay!,
          if (Theme.of(context).platform != TargetPlatform.iOS)
            Consumer<PlayerNotifier>(
              builder: (
                BuildContext context,
                PlayerNotifier notifier,
                Widget? widget,
              ) =>
                  Visibility(
                visible: !notifier.hideStuff,
                child: AnimatedOpacity(
                  opacity: notifier.hideStuff ? 0.0 : 0.8,
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: SizedBox(),
                  ),
                ),
              ),
            ),
          buildControls(context, flexiController),
        ],
      );
    }

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:  buildPlayerWithControls(flexiController, context),
      ),
    );
  }
}
