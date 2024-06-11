// import 'dart:html';
// import 'dart:io';
// import 'dart:js';
// import 'package:ollama/ollama.dart';
// import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

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
      body: Align(
        alignment: const Alignment(0.0, -0.9),
        child:  SizedBox(
          width: 500,
          height: 200,
          child: TextField(
          // keyboardType: TextInputType.multiline,
          // maxLines: null,
          // minLines: 4,
          controller: _controller,
          decoration: const InputDecoration(
            // helperText: "Analysis Prompt",
            border: OutlineInputBorder(),

            labelText: "Write your prompt here",
          ),
          onSubmitted: (String value){
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => ResultPage.resultPageFactory(prompt: value, url: Uri.base.toString(),)),
              MaterialPageRoute(builder: (context) => FutureBuilder(
                future: resultPageFactory(value, Uri.base.toString()),
                builder: (ctx, data) {
                  if (data.hasData ){
                    return Center(child: ResultPage(key: const Key("!"), url: Uri.base.toString(), response: data.data));  
                  } else if (data.hasError){
                    return Center(child: Text('Error: ${data.error}'));
                  } else{
                    return const Center(child: CircularProgressIndicator());
                  }
                })
            ));
          },
        )
        ),
      ),
    );
  }
}




Future<http.Response> resultPageFactory(String prompt, String url) async {
  // var client = OllamaClient();
  // final generated = await client.generateCompletion(
  //   request: GenerateCompletionRequest(
  //     model: 'mistral:latest',
  //     prompt: prompt,
  //   ),
  // );

  // return Future.value(generated.response.toString());
  String reqUrl = "https://localhost:5000/prompt?text=$prompt";
  if(url.contains("?")){
    final paramsLine = url.split("?")[1];
    final paramsArray = paramsLine.split("?");
    String taskId = "";
    String authToken = "";
    for (var i = 0; i < paramsArray.length; i++) {
      final valuePair = paramsArray[i].split("=");

      switch (valuePair[0]){
        case "taskId":
          taskId = valuePair[1];
          break;
        case "token":
          authToken = valuePair[1];
          break;
      }
    }

    
    if( taskId != ""){
      reqUrl += "&taskId=$taskId";
    }

    if( authToken != ""){
      reqUrl += "&token=$authToken";
    }

  }


  
  reqUrl = Uri.encodeFull(reqUrl.replaceAll("https", "http"));
  
  final response = await http.get(Uri.parse(reqUrl));
  
  return Future.value(response);
}


class ResultPage extends StatelessWidget {
  final String url;
  final http.Response? response;


  const ResultPage({super.key, this.url="", required this.response});



  @override
  Widget build(BuildContext context) {
    String? contentType = response?.headers['content-type'];

    if( contentType != null && contentType == "text/plain"){
        return Scaffold(
        appBar: AppBar(
          title: const Text('Write a new prompt'),
        ),
        body: Center(
          child: Text(response!.body),
        ),
      );
    } else {
          return Scaffold(
          appBar: AppBar(
            title: const Text('Write a new prompt'),
          ),
          body: Center(
            child: Image.memory(response!.bodyBytes),
          ),
        );
      }
    }

}
