import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wall3ha_app/config/api_keys.dart';

class DialogueScreen extends StatefulWidget {
  @override
  _DialogueScreenState createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  final TextEditingController personController = TextEditingController();
  String relationship = 'زوج وزوجة';
  String tone = 'مضحك 😂';
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
              'انت مساعد ذكي — تكتب ردود مناسبة بين $relationship — بنبرة $tone — ردود واقعية فيها مشاعر او طرافة حسب الطلب.'
            },
            {
              'role': 'user',
              'content':
              'كلام الطرف الأول: ${personController.text}\nارسل لي رد مناسب باللهجة المناسبة وبنبرة $tone.',
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
        title: Text('ولّع حوارك الخاص ❤️'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                value: relationship,
                onChanged: (String? newValue) {
                  setState(() {
                    relationship = newValue!;
                  });
                },
                items: <String>[
                  'زوج وزوجة',
                  'أب وابن',
                  'صديق وصديق',
                  'قروب كروي',
                  'مدير وموظف',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: tone,
                onChanged: (String? newValue) {
                  setState(() {
                    tone = newValue!;
                  });
                },
                items: <String>[
                  'مضحك 😂',
                  'قصف جبهة 🔥',
                  'عاطفي 💕',
                  'رسمي 📝',
                  'حزين 😢',
                  'طقطقة كروية ⚽️🔥',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: personController,
                decoration: InputDecoration(
                  labelText: 'كلام الطرف الأول',
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
