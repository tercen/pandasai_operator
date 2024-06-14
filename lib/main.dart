// import 'dart:html';
// import 'dart:io';
// import 'dart:js';
// import 'package:ollama/ollama.dart';
// import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:flutter/material.dart';
// import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(const PromptApp());

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PromptWidget(),
    );
  }
}

class PromptWidget extends StatefulWidget {
  const PromptWidget({super.key});

  @override
  State<PromptWidget> createState() => _PromptWidgetState();
}




class _PromptWidgetState extends State<PromptWidget> {
  late TextEditingController _controller;
  late TextEditingController _apiController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _apiController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Material(  
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 800,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "API Key (OpenAPI)",
              ),
              controller: _apiController,
            )
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 800,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLength: 128000,
              minLines: 5,
              maxLines: null,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Write your prompt here",
              )
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 800,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                label: const Text("Send"),
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                onPressed: (){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => FutureBuilder(
                      future: resultPageFactory(_controller.text, _apiController.text),
                      builder: (ctx, data) {
                        if (data.hasData ){
                          return Center(child: ResultPage(key: const Key("!"), url: Uri.base.toString(), response: data.data));  
                        } else if (data.hasError){
                          return Center(child: Text('Error: ${data.error}'));
                        } else{
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                      })
                    )
                  );
                }
              ),
            ),
          ),
        ],
      )
    );

  }

}




Future<http.Response> resultPageFactory(String prompt, String apiKey) async {
  String reqUrl = "https://localhost:5000/prompt?text=$prompt";
  

  final taskId = Uri.base.queryParameters['taskId'];
  final authToken = Uri.base.queryParameters['token'];


    
  if( taskId != null && taskId != "" ){
    reqUrl += "&taskId=$taskId";
  }

  if( authToken != null && authToken != ""){
    reqUrl += "&token=$authToken";
  }

  if( apiKey != ""){
    reqUrl += "&apiKey=$authToken";
  }

  
  reqUrl = Uri.encodeFull(reqUrl.replaceAll("https", "http"));
  
  final response = await http.get(Uri.parse(reqUrl));
  
  return Future.value(response);
}


class ResultPage extends StatelessWidget {
  final String url;
  
  final http.Response? response;


  const ResultPage({super.key, this.url="", required this.response});

  Future<void> saveImg(Uint8List imageBytes) async {
    await WebImageDownloader.downloadImageFromUInt8List(uInt8List: imageBytes);
  }



  @override
  Widget build(BuildContext context) {
    // String? contentType = response?.headers['content-type'];
    final responseData = jsonDecode(response!.body);

    // String? contentType = responseData["content_type"];
    List<Text> logWidgets = [];

    for( var i = 0 ; i < responseData["logs"].length ; i++ ) { 
      logWidgets.add(Text(responseData["logs"][i])) ;
    } 


    Widget responseWidget;
    if(responseData["content_type"] == "text/plain"){
      responseWidget = Align(alignment: Alignment.topLeft, child:SelectableText(responseData!["content"]));
    }else{
      responseWidget = Column(
            children: [
              Center(child: Image.memory(base64Decode(responseData!["content"]))),
              Center(
                child: ElevatedButton(
                  child: const Text("Download Image"),
                  onPressed: () => saveImg(base64Decode(responseData!["content"])),
                ),
              ),
            ],
          );
    }

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 1000,
              child: responseWidget,
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 800,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Color.fromARGB(255, 220, 220, 220)),
                child: ExpansionTile(
                  title: const Text("Chat Agent Logs"),
                  children: [
                    SizedBox(
                      width: 800,
                      height: 300,

                      child: SingleChildScrollView(child: SelectableText(responseData["logs"].join("\n"))),
                    )
                  ]
                )
              )
            )
          ],
        ),
      ),
    );

    // // if( contentType != null && contentType == "text/plain"){
    //     return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Write a new prompt'),
    //     ),
    //     body: Center(
    //       // child: Text(response!.body),
    //       child: Text(responseData["logs"].join("\n")),
    //     ),
    //   );
    // // } else {
    // //       return Scaffold(
    // //       appBar: AppBar(
    // //         title: const Text('Write a new prompt'),
    // //       ),
    // //       body: Column(
    // //         children: [
    // //           Center(child: Image.memory(response!.bodyBytes)),
    // //           Center(
    // //             child: ElevatedButton(
    // //               child: const Text("Download Image"),
    // //               onPressed: () => saveImg(),
    // //             ),
    // //           ),
    // //         ],
            
    // //       ),
    // //     );
    // //   }
  }

}
