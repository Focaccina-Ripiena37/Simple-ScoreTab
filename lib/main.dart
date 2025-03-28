import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ScoreboardApp());
}

class ScoreboardApp extends StatelessWidget {
  const ScoreboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScoreboardScreen(),
    );
  }
}

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  int scoreHome = 0;
  int scoreGuest = 0;
  int setHome = 0;
  int setGuest = 0;
  String time = "";
  String date = "";
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        time = DateFormat('HH:mm:ss').format(DateTime.now());
        date = DateFormat('dd MMM yyyy').format(DateTime.now());
      });
    });
  }

  void _playSound() async {
    await player.play(AssetSource('score.mp3'));
  }

  void _incrementScore(bool isHome) {
    setState(() {
      if (isHome) {
        scoreHome++;
      } else {
        scoreGuest++;
      }
      _playSound();
    });
  }

  void _decrementScore(bool isHome) {
    setState(() {
      if (isHome && scoreHome > 0) {
        scoreHome--;
      } else if (!isHome && scoreGuest > 0) {
        scoreGuest--;
      }
    });
  }

  void _incrementSet(bool isHome) {
    setState(() {
      if (isHome && setHome < 5) {
        setHome++;
      } else if (!isHome && setGuest < 5) {
        setGuest++;
      }
    });
  }

  void _decrementSet(bool isHome) {
    setState(() {
      if (isHome && setHome > 0) {
        setHome--;
      } else if (!isHome && setGuest > 0) {
        setGuest--;
      }
    });
  }

  void _resetScores() {
    setState(() {
      scoreHome = 0;
      scoreGuest = 0;
      setHome = 0;
      setGuest = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(date, style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(time, style: TextStyle(color: Colors.white, fontSize: 30)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreBox("Casa", scoreHome, true),
              _buildSetBox(setHome, setGuest),
              _buildScoreBox("Ospite", scoreGuest, false),
            ],
          ),
          SizedBox(height: 40),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildScoreBox(String title, int score, bool isHome) {
    return GestureDetector(
      onTap: () => _incrementScore(isHome),
      onSecondaryTap: () => _decrementScore(isHome),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: isHome ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.white24, blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 30)),
            Text(
              "$score",
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetBox(int setHome, int setGuest) {
    return Column(
      children: [
        Text("Set", style: TextStyle(color: Colors.white, fontSize: 24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _setButton(setHome, true),
            SizedBox(width: 10),
            _setButton(setGuest, false),
          ],
        ),
      ],
    );
  }

  Widget _setButton(int setCount, bool isHome) {
    return GestureDetector(
      onTap: () => _incrementSet(isHome),
      onSecondaryTap: () => _decrementSet(isHome),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "$setCount",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_controlButton("Reset", _resetScores)],
    );
  }

  Widget _controlButton(String title, Function onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: () => onPressed(),
      child: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
