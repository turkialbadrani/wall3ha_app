import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';

class AnalyzeScreen extends StatefulWidget {
  @override
  _AnalyzeScreenState createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final TextEditingController textController = TextEditingController();
  String analysisResult = '';
  bool isLoading = false;

  void analyzeText() async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    setState(() {
      isLoading = true;
      analysisResult = '';
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiKeys.openaiApiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content':
              'أنت محلل نفسي محترف. أعطني تحليل نفسي عميق للنص التالي...',
            },
            {
              'role': 'user',
              'content': 'النص:\n${textController.text}',
            },
          ],
          'max_tokens': 200,
          'temperature': 0.6,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];

        setState(() {
          analysisResult = reply;
        });
      } else {
        setState(() {
          analysisResult =
          '❌ حصل خطأ في الاتصال بـ GPT API. [Status code: ${response.statusCode}]';
        });
      }
    } catch (e) {
      setState(() {
        analysisResult = '❌ خطأ أثناء الاتصال: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🧠 تحليل نفسي للنص'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: textController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'ضع هنا كلام الشخص المراد تحليله',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : analyzeText,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('🔍 حلل النص نفسياً'),
              ),
              SizedBox(height: 16),
              analysisResult.isNotEmpty
                  ? Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  analysisResult,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
