
import 'package:flutter/services.dart';
import 'package:splayer/src/Flexi/flexi_player.dart';
import 'package:splayer/src/Flexi/helpers/adaptive_controls.dart';
import 'package:splayer/src/Flexi/notifiers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


double calculateAspectRatio(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  return width > height ? width / height : height / width;
}




class PlayerWithControls extends StatelessWidget {
  final String tag;
  const PlayerWithControls({super.key, required this.tag});
  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    double scale=1.0;
    double prevScale=1.0;
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
      return GestureDetector(
          onScaleStart: (details){
            prevScale=scale;
            print("Scale Start");
          },
          trackpadScrollCausesScale: true,
          onScaleUpdate: (details){

              scale=prevScale*details.scale;
              print("Scale Update $scale");
              scale=scale.clamp(1.0, 100.0);
              flexiController.transformationController!.value=Matrix4.diagonal3Values(scale, scale, scale);

          },

          child:Stack(

            fit: StackFit.expand,
            children: <Widget>[

              if (flexiController.placeholder != null)
                flexiController.placeholder!,
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(double.infinity),
                alignment: Alignment.center,
                maxScale: flexiController.maxScale,
                panEnabled: flexiController.zoomAndPan,
                scaleEnabled: flexiController.zoomAndPan,
                panAxis: PanAxis.free,
                trackpadScrollCausesScale: true,
                clipBehavior: Clip.hardEdge,
                transformationController: flexiController.transformationController,
                child:  AspectRatio(
                  aspectRatio: calculateAspectRatio(context),
                    child:  VideoPlayer(flexiController.videoPlayerController),

                ),
                /* child: FittedBox(
              clipBehavior: Clip.hardEdge,
              fit: flexiController.isFullScreen?BoxFit.cover:BoxFit.fill,
              child: SizedBox(

                  width: MediaQuery.sizeOf(context).width,
                  height: 500,
                  child: VideoPlayer(flexiController.videoPlayerController)
              ),
            ),*/
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
          ));
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

