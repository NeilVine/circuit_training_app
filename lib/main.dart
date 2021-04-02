import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Circuit Training Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _exercise = -1;
  int _round = 0;
  String _roundsText = "Round/Set";
  String _exerciseText = "Exercise";
  Timer _timer;
  double _progressValue = 0.0;
  String exerciseFromMap = '';
  int _exerciseCountDown = 0;

  Map<int, String> _exerciseMap = {
    0: 'Legs: Lunge/Squat',
    1: 'Chest: Push-Ups',
    2: 'Abs: Sit-Ups/V-Ups',
    3: 'Poster Chain: Bridges',
    4: 'Rest: Keep Moving'
  };

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }
  void startTimer() {
    _counter = 0;
    _exercise = -1;
    _round = 0;
    _roundsText = "Round/Set";
    _exerciseText = "Exercise";
    _progressValue = 0.0;

    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _counter = 900;

      _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        //
        setState(() {
          //

          if (_counter == 150) {
            _round = 6;
          } else if (_counter == 300) {
            _round = 5;
          } else if (_counter == 450) {
            _round = 4;
          } else if (_counter == 600) {
            _round = 3;
          } else if (_counter == 750) {
            _round = 2;
          } else if (_counter == 900) {
            _round = 1;
          }

          _roundsText = 'Round ' + '$_round';

          _exerciseCountDown--;

          //exevery 30seconds, increament the exercise
          if (_counter % 30 == 0) {
            _exercise++;
            _exerciseCountDown = 30;
            if (_exercise > 4) {
              _exercise = 0;
            }
          }

          if (_exerciseCountDown == 10) {
            FlutterRingtonePlayer.play(
              android: AndroidSounds.notification,
              ios: const IosSound(1023),
              looping: false,
              volume: 0.1,
            );
          }

          exerciseFromMap = _exerciseMap[_exercise];
          _exerciseText = exerciseFromMap;

          // think of 5 exercises, with one of them being a rest before the next set

          //_exerciseText

          _counter--;

          _progressValue = (_counter / 900);

          if (_counter == 0) {
            _timer.cancel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Six rounds of four exercises, with 30sec rest after each round',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
            Text(
              ' ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 30.0,
              ),
            ),
            Text(
              '$_roundsText',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 30.0,
              ),
            ),
            Text(
              '$_exerciseText',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 30.0,
              ),
            ),
            ElevatedButton.icon(
                label: Text('Start'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                icon: Icon(Icons.play_arrow),
                onPressed: startTimer),
            Text(
              ' $_exerciseCountDown',
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 100.0,
              width: 100.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.green),
                strokeWidth: 30.0,
                backgroundColor: Colors.white,
                value: _progressValue,
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
