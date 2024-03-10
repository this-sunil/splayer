import 'dart:developer';


import '../splayer.dart';

void podLog(String message) =>
    PodVideoPlayer.enableLogs ? log(message, name: 'POD') : null;
