import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'database_helper.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  Map<String, int> _wordCount = {};
  List<String> _synonyms = [];

  void _calculateWordCount() {
    setState(() {
      _wordCount = {};
      _synonyms = [];

      // Split the text into words
      List<String> words = _textController.text.split(' ');

      // Count the frequency of each word
      for (String word in words) {
        if (_wordCount.containsKey(word)) {
          _wordCount[word] = (_wordCount[word] ?? 0) + 1;
        } else {
          _wordCount[word] = 1;
        }
      }

      // Get synonyms for each word
      for (String word in _wordCount.keys) {
        // Replace this with a call to your synonym API
        _synonyms.add('synonym for "$word"');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              onChanged: (text) {
                _calculateWordCount();
              },
            ),
            SizedBox(height: 16),
            Text('Number of characters: ${_textController.text.length}'),
            SizedBox(height: 16),
            Text('Number of words: ${_wordCount.length}'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _wordCount.length,
                itemBuilder: (context, index) {
                  String key = _wordCount.keys.elementAt(index);
                  int? value = _wordCount[key];
                  String synonym = _synonyms[index];
                  return ListTile(
                    title: Text('$key: $value'),
                    subtitle: Text(synonym),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
