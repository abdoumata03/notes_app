import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:notes/home.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: NoteDetailsCol(note: note),
          ),
        ),
      ),
    );
  }
}

class NoteDetailsCol extends StatelessWidget {
  NoteDetailsCol({
    super.key,
    required this.note,
  });

  final Note note;
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/avatar.png',
          width: 100,
          height: 100,
        ),
        const Text('Matallah Abdallah'),
        Text(
          note.note,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          note.date.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        ElevatedButton(
          onPressed: () {
            flutterTts.speak(note.note);
          },
          child: Text('Speak'),
        ),
      ],
    );
  }
}