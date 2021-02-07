import 'dart:math' as Math;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dragonslayer_music/wave_base_painter.dart';
import 'package:dragonslayer_music/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'clipper.dart';
import 'model.dart';
import 'wave_color_painter.dart';
import 'widgets/distorted_circle.dart';
import 'widgets/player_control.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        iconTheme: IconThemeData(color: Color(0xFF6B54AA)),
        textTheme: TextTheme(body1: TextStyle(color: Color(0xff75889B)))),
    debugShowCheckedModeBanner: false,
    home: ChangeNotifierProvider(
        create: (context) => PlayerModel(), child: PlayerApp()),
  ));
}

class PlayerApp extends StatefulWidget {
  @override
  _PlayerAppState createState() => _PlayerAppState();
}

class _PlayerAppState extends State<PlayerApp> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _perspectiveController;
  Animation<double> _waveAnim;
  Animation<double> _waveConstAmpAnim;
  Animation<double> _perspectiveAnim;
  Animation<double> _coverAnim;
  Animation<Duration> _timeCounters;

  bool isListVisible = false;

  PlayerModel model;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 1))
          ..addListener(() => setState(() {}));
    _perspectiveController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() => setState(() {}));

    _waveAnim = Tween<double>(begin: 1, end: 1).animate(_controller);
    _waveConstAmpAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _coverAnim = Tween<double>(begin: 0, end: 200 * Math.pi)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: _controller));
    _perspectiveAnim = Tween<double>(begin: 0, end: Math.pi / 6).animate(
        CurvedAnimation(
            curve: Curves.elasticInOut, parent: _perspectiveController));
  }

  @override
  void dispose() {
    _controller.dispose();
    _perspectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final widgth = MediaQuery.of(context).size.width;
    model = Provider.of<PlayerModel>(context);
    if (model.currentTrack == 0)
      _controller.duration = model.musicList[model.currentTrack].duration;
    if (model.musicList[model.currentTrack].isplayer) {
      _controller.duration = model.musicList[model.currentTrack].duration;

      _controller.forward();
    } else {
      _controller.stop();
    }
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        model.musicList[model.currentTrack].isplayer = false;
        _controller.reset();
      }
    });

    _timeCounters =
        Tween<Duration>(begin: Duration(seconds: 0), end: _controller.duration)
            .animate(_controller);
    return Scaffold(
        backgroundColor: Color(0xFF7a6ebb),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 210,
              width: widgth,
              height: height,
              child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(Math.pi / 6 - _perspectiveAnim.value),
                  child: buildMusicList()),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              bottom: isListVisible ? height - 210 : 0,
              // height: height,
              width: widgth,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_perspectiveController.isAnimating
                      ? -_perspectiveAnim.value
                      : 0),
                child: Material(
                  elevation: 16,
                  color: Color(0xFFd6dde5),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 90,
                        ),
                        Text(model.musicList[model.currentTrack].name,
                            style: TextStyle(
                                fontSize: 34,
                                color: Colors.black,
                                fontFamily: 'laos')),
                        Text(
                          model.musicList[model.currentTrack].arListName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'laos'),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        DistortedCircle(
                          child: buildRecordPlayer(),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Row(children: <Widget>[
                          /// Change to time coouter
                          Text(_timeCounters.value.toString().substring(3, 7)),
                          SizedBox(
                            width: 8,
                          ),
                          buildWave(widgth),
                          SizedBox(
                            width: 8,
                          ),
                          Text(_controller.duration.toString().substring(3, 7)),
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        builControlsRow(model),
                        SizedBox(
                          height: 30,
                        ),
                        Text('All TRACKS'),
                        SizedBox(
                          height: 25,
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (!isListVisible)
                              _perspectiveController.forward();
                            else
                              _perspectiveController.reverse();
                            setState(() {
                              isListVisible = !isListVisible;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              top: isListVisible ? 15 : 80,
              left: 30,
              right: 30,
              child: Row(
                children: <Widget>[
                  Icon(Icons.search, size: 30),
                  Spacer(),
                  Icon(Icons.playlist_play, size: 33)
                ],
              ),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              top: isListVisible ? 100 : 670,
              left: 30,
              right: 30,
              child: Row(
                children: <Widget>[
                  Icon(Icons.repeat, size: 25),
                  Spacer(),
                  Icon(Icons.add, size: 30)
                ],
              ),
            )
          ],
        ));
  }

  Widget buildRecordPlayer() {
    return Transform.rotate(
      angle: _coverAnim.value,
      child: Container(
          height: 290,
          width: 290,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage('images/rose.jpg'),
                  fit: BoxFit.fitHeight,
                  colorFilter: ColorFilter.mode(Colors.blue, BlendMode.color)),
              shape: BoxShape.circle),
          child: Transform.rotate(
            angle: _coverAnim.value,
            child: ClipOval(
              child: new Image.asset(
                'images/rgb.png',
                height: 150,
                width: 150,
                fit: BoxFit.fill,
              ),
            ),
          )),
    );
  }

  Widget buildWave(double width) {
    return Container(
      width: 260 * _waveAnim.value,
      height: 40,
      child: CustomPaint(
        painter: WaveBasePainter(),
        child: ClipRect(
          clipper: WaveClipper(_waveConstAmpAnim.value * width),
          child: CustomPaint(
            painter: WaveBasePainter(),
            foregroundPainter: WaveColorPainter(_waveAnim),
          ),
        ),
      ),
    );
  }

  ListView buildMusicList() {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) =>
          Divider(thickness: 1, height: 0, color: Color(0xff97980cd)),
      itemCount: model.musicList.length,
      itemBuilder: (context, index) {
        bool isIndexCurrentTrack = false;
        if (index == model.currentTrack) isIndexCurrentTrack = true;

        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: !isIndexCurrentTrack ? Color(0xff7a5ebb) : Color(0xff6a52a4),
          child: GestureDetector(
            onTap: () {
              if (!isIndexCurrentTrack) {
                model.resetList();
                _controller.reset();
              }
              model.currentTrack = index;
              model.musicList[index].isplayer =
                  !model.musicList[index].isplayer;
            },
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              leading: PlayerButton(
                iconAlternate: Icon(Icons.pause),
                iconPrimary: Icon(Icons.play_arrow),
                musicNo: index,
                isInnerColorFill: true,
                radius: 18,
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  model.musicList[index].name,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Text(model.musicList[index].arListName,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  )),
              trailing: Text(
                  model.musicList[index].duration.toString().substring(3, 7),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  )),
            ),
          ),
        );
      },
    );
  }
}
