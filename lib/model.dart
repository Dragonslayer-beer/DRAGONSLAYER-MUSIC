import 'dart:math';

import 'package:flutter/material.dart';
import 'musicdata.dart';

class PlayerModel extends ChangeNotifier {
  List<Music> musicList = [];
  int _currentTrack = 0;

  PlayerModel() {
    for (int i = 0; i < Data.nameList.length; i++)
      musicList
          .add(Music(arListName: Data.arListList[i], name: Data.nameList[i]));
    musicList.removeWhere(
        (musicItem) => musicItem.name == null || musicItem.arListName == null);

    musicList.forEach((musicList) {
      musicList.duration = Duration(
          minutes: Random().nextInt(5).clamp(1, 5),
          seconds: Random().nextInt(59));
    });

    musicList.forEach((music) => print(music.name));
  }

  int get currentTrack => _currentTrack;

  set currentTrack(int currentTrack) {
    _currentTrack = currentTrack;
    notifyListeners();
  }

resetList(){
  musicList.forEach((music) => music.isplayer = false);
}

}

class Music {
  String name;
  String arListName;
  Duration duration;
  bool isplayer = false;
  Music({this.duration, this.arListName, this.name});
}
