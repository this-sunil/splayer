import 'package:flutter/material.dart';
import 'package:splayer/splayer.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PodPlayerController controller;
  /*fetchData() async{
    final yt=YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest("IMLLUfpUb3s",ytClients:
    [Platform.isAndroid?YoutubeApiClient.androidVr:YoutubeApiClient.ios]);
    var streamInfo = manifest.streams;
      print("Manifest ${manifest.muxed.map((e)=>e.qualityLabel.split("p")[0].toString()).toList()} ${streamInfo[0].url} ${streamInfo[0].qualityLabel.split("p")[0]}");
  }*/
  @override
  void initState() {
    controller = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(
          isLive: true,
          autoPlay: false,
          videoQualityPriority: [1080,720,480,360,240],
          tap: true,
        ),
        playVideoFrom: PlayVideoFrom.youtube("https://www.youtube.com/watch?v=mDNzj0njUZU"))
      ..initialise();
    controller.pause();
    //fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        SizedBox(
          height: 250,
          child: PodVideoPlayer(controller: controller, isLive: true),
        ),
      ],
    )));
  }
}
