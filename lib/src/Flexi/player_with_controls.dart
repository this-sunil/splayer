
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
      final aspectRatio=MediaQuery.sizeOf(context).aspectRatio;
      bool isLandscape=aspectRatio>1;
      print("Landscape$isLandscape");

      return GestureDetector(
          onScaleStart: (details){
            prevScale=scale;
            print("Scale Start");

          },
          onScaleUpdate: (details){
            scale=prevScale*details.scale;
              print("Scale Update $scale");
              scale=scale.clamp(1.0, 10.0);
              flexiController.transformationController!.value=Matrix4.identity()..scale(scale,scale,scale);
              },
          child:Stack(
            fit: StackFit.expand,

            children: <Widget>[

              InteractiveViewer(
                transformationController: flexiController.transformationController,
                alignment: Alignment.center,
                panAxis: PanAxis.free,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                maxScale: flexiController.maxScale,
                panEnabled: flexiController.zoomAndPan,
                scaleEnabled: flexiController.zoomAndPan,
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: !isLandscape?VideoPlayer(flexiController.videoPlayerController):AspectRatio(
                    aspectRatio: flexiController.videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(flexiController.videoPlayerController),
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
                            decoration: BoxDecoration(color: Colors.black54),
                            child: SizedBox.expand(),
                          ),
                        ),
                      ),
                ),

                buildControls(context, flexiController)


            ],
          ));
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: Container(
              color: Colors.black,
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: AspectRatio(
                aspectRatio: calculateAspectRatio(context),
                child: buildPlayerWithControls(flexiController, context),
              ),
            ),
          );
        });
  }
}

