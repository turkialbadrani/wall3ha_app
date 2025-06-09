// lib/screens/trending_topics_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';

class TrendingTopicsScreen extends StatefulWidget {
  @override
  _TrendingTopicsScreenState createState() => _TrendingTopicsScreenState();
}

class _TrendingTopicsScreenState extends State<TrendingTopicsScreen> {
  final List<String> trendingTopics = [
    'مباراة الهلال والنصر اليوم',
    'ترند اليوم في تويتر',
    'قضية المشهور فلان',
    'ايفون الجديد',
    'اغنية ضاربة في السناب',
  ];

  String generatedReply = '';
  bool isLoading = false;

  Future<void> generateReply(String topic) async {
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
              'أنت كاتب محتوى ذكي — اكتب رد طريف أو مثير أو تعليق قوي على الترند التالي باللهجة العامية السعودية:',
            },
            {
              'role': 'user',
              'content': topic,
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
        title: Text('🔥 مواضيع ترند اليوم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: trendingTopics.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(trendingTopics[index]),
                    trailing: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => generateReply(trendingTopics[index]),
                      child: Text('🗯️ ولّعها'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            if (isLoading) CircularProgressIndicator(),
            if (generatedReply.isNotEmpty)
              Container(
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
              ),
          ],
        ),
      ),
    );
  }
}
