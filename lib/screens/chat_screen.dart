import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController person1Controller = TextEditingController();
  final TextEditingController person2Controller = TextEditingController();
  String generatedReply = '';
  bool isLoading = false;

  void generateReply() async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    setState(() {
      isLoading = true;
      generatedReply = '';
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
              'انت مساعد ذكي — تكتب ردود طقطقة بين شخصين بطريقة فكاهية، قوية، وفيها لمسة مرحة.'
            },
            {
              'role': 'user',
              'content':
              'كلام الشخص الأول: ${person1Controller.text}\nكلام الشخص الثاني: ${person2Controller.text}\nارسل لي رد مناسب باللهجة المناسبة.',
            },
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];

        setState(() {
          generatedReply = reply;
        });
      } else {
        setState(() {
          generatedReply =
          '❌ حصل خطأ في الاتصال بـ GPT API. [Status code: ${response.statusCode}]';
        });
      }
    } catch (e) {
      setState(() {
        generatedReply = '❌ خطأ أثناء الاتصال: $e';
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
        title: Text('ولّع القروب 🔥'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: person1Controller,
                decoration: InputDecoration(
                  labelText: 'كلام الشخص الأول',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: person2Controller,
                decoration: InputDecoration(
                  labelText: 'كلام الشخص الثاني',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : generateReply,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('🔮 ولّعها!'),
              ),
              SizedBox(height: 16),
              generatedReply.isNotEmpty
                  ? Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  generatedReply,
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
