import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wall3ha_app/config/api_keys.dart';
import 'package:wall3ha_app/widgets/reply_actions_widget.dart';

class TrendingTopicsScreen extends StatefulWidget {
  @override
  _TrendingTopicsScreenState createState() => _TrendingTopicsScreenState();
}

class _TrendingTopicsScreenState extends State<TrendingTopicsScreen> {
  final List<String> trendingTopics = [
    'الهلال والنصر امس 🔥',
    'نتائج الثانوية العامة 📚',
    'خبر ترند عن فنان مشهور 🎤',
    'جدال على تويتر عن القيادة',
    'فوز ريال مدريد بدوري الأبطال 🏆',
  ];

  String generatedReply = '';
  bool isLoading = false;

  void generateResponse(String topic) async {
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
          'Authorization': 'Bearer $openaiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': '''
مهمتك: تولد رد ساخر/ذكي/فكاهي عن موضوع ترند في القروبات.

- لا تشرح الموضوع.
- اكتب رد جاهز كأن المستخدم يرسله للقروب.
- باللهجة العامية.
- فيها طقطقة أو ردة فعل ممتعة.

لا تكتب مقدمة — فقط الرد النهائي.
'''
            },
            {
              'role': 'user',
              'content': 'الموضوع:\n$topic',
            },
          ],
          'max_tokens': 150,
          'temperature': 0.8,
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
          generatedReply = '❌ خطأ في الاتصال. [${response.statusCode}]';
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

  Widget buildTopicButton(String topic) {
    return ListTile(
      title: Text(topic),
      trailing: ElevatedButton(
        onPressed: () => generateResponse(topic),
        child: Text('🗯️ ولّعها'),
      ),
    );
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
            ...trendingTopics.map(buildTopicButton).toList(),
            SizedBox(height: 20),
            if (generatedReply.isNotEmpty)
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      generatedReply,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  ReplyActionsWidget(
                    replyText: generatedReply,
                    onRegenerate: () {
                      // تكرار آخر موضوع تم الضغط عليه:
                      generateResponse(trendingTopics.lastWhere((t) => generatedReply.contains(t), orElse: () => trendingTopics[0]));
                    },
                  ),
                ],
              ),
            if (isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
