import '../model.dart';
import 'button.dart';
import 'package:flutter/material.dart';


Row builControlsRow(PlayerModel model) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Spacer(),
      SizedBox(
        width: 35,
      ),
      PlayerButton(
        radius: 20,
        iconPrimary: Icon(Icons.skip_previous),
        iconAlternate: Icon(Icons.skip_previous),
        musicNo: model.currentTrack + 1,
      ),
      SizedBox( 
        width: 5,
      ),
      GestureDetector(
        onTap: () {
          model.currentTrack = model.currentTrack;
          model.musicList[model.currentTrack].isplayer =
              !model.musicList[model.currentTrack].isplayer;
              
        },
        child: PlayerButton(
          radius: 35,
          iconPrimary: Icon(Icons.play_arrow),
          iconAlternate: Icon(Icons.pause),
          musicNo: model.currentTrack,
        ),
      ),
      SizedBox(
        width: 5,
      ),
      PlayerButton(
        radius: 20,
        iconPrimary: Icon(Icons.skip_next),
        iconAlternate: Icon(Icons.skip_next),
        musicNo: model.currentTrack + 1,
      ),
      SizedBox(
        width: 35,
      ),
      Spacer()
    ],
  );
}
