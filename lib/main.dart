// import 'dart:html';
// import 'dart:io';
// import 'dart:js';
// import 'package:ollama/ollama.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'dart:convert';
import 'package:ollama_dart/ollama_dart.dart';

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
          decoration: const InputDecoration(
            helperText: "Analysis Prompt",
            border: OutlineInputBorder(),
            labelText: "Write your prompt here",
          ),
          onSubmitted: (String value){
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => ResultPage.resultPageFactory(prompt: value, url: Uri.base.toString(),)),
              MaterialPageRoute(builder: (context) => FutureBuilder(
                future: resultPageFactory(value),
                builder: (ctx, data) {
                  if (data.hasData ){
                    return Center(child: ResultPage(key: const Key("!"), url: Uri.base.toString(), prompt: data.data.toString()));  
                  } else if (data.hasError){
                    return Center(child: Text('Error: ${data.error}'));
                  } else{
                    return const Center(child: CircularProgressIndicator());
                  }
                })
            ));
          },
        ),
      ),
    );
  }
}

Future<String> resultPageFactory(String prompt) async {
  // var client = OllamaClient();
  // final generated = await client.generateCompletion(
  //   request: GenerateCompletionRequest(
  //     model: 'mistral:latest',
  //     prompt: prompt,
  //   ),
  // );

  // return Future.value(generated.response.toString());
  return Future.value(prompt);
}

class ResultPage extends StatelessWidget {
  final String url;
  final String prompt;

  const ResultPage({super.key, this.url="", this.prompt=""});



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
