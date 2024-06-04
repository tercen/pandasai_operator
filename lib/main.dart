import 'dart:html';

import 'package:flutter/material.dart';

/// Flutter code sample for [TextField].

void main() => runApp(const TextFieldExampleApp());

class TextFieldExampleApp extends StatelessWidget {
  const TextFieldExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TextFieldExample(),
    );
  }
}

class TextFieldExample extends StatefulWidget {
  const TextFieldExample({super.key});

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            helperText: "Analysis Prompt",
            border: const OutlineInputBorder(),
            labelText: Uri.base.toString(),
          ),
          onSubmitted: (String value){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResultPage(prompt: value, url: Uri.base.toString(),)),
            );
          },
        ),
      ),
    );
  }
}


class ResultPage extends StatelessWidget {
  final String url;
  final String prompt;

  const ResultPage({super.key, this.url="", this.prompt=""});

  const ResultPage.params({super.key, this.url="", this.prompt=""});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: Text("$url - $prompt"),
      ),
    );
  }
}
