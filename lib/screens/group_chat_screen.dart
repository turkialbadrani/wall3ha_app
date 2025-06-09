import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wall3ha_app/config/api_keys.dart';
import 'package:wall3ha_app/widgets/reply_actions_widget.dart';

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController person1Controller = TextEditingController();
  final TextEditingController person2Controller = TextEditingController();
  final TextEditingController person3Controller = TextEditingController();
  final TextEditingController person4Controller = TextEditingController();

  String generatedConversation = '';
  bool isLoading = false;

  void generateGroupChat() async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    setState(() {
      isLoading = true;
      generatedConversation = '';
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
أنت مساعد ذكي.

مهمتك: توليد محادثة جماعية ممتعة جدًا بين 4 أشخاص في قروب واتساب.

- الشخص 1 كتب: "${person1Controller.text}"
- الشخص 2 كتب: "${person2Controller.text}"
- الشخص 3 كتب: "${person3Controller.text}"
- الشخص 4 كتب: "${person4Controller.text}"

اكتب محادثة كاملة بينهم باللهجة العامية، ممتعة جدًا، واقعية كأنهم يتكلمون طبيعي في قروب واتساب.

✅ يجب أن تكون المحادثة ممتعة — مع طقطقة — سخرية خفيفة — Emojis — خلي الناس يضحكون لما يقرؤونها.

✅ كل رسالة تبدأ باسم الشخص (مثال: 🧑‍💻 أحمد: ...)

✅ رتب الرسائل كأنها محادثة طبيعية، مو مجرد سرد.

✅ لا تكتب عناوين أو مقدمات — ابدأ بالمحادثة مباشرة.

✅ ختام المحادثة مفتوح — كأن القروب ما زال فيه تفاعل.
'''
            },
            {
              'role': 'user',
              'content': 'رجاءً أعطني المحادثة الآن.',
            },
          ],
          'max_tokens': 600,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];

        setState(() {
          generatedConversation = reply;
        });
      } else {
        setState(() {
          generatedConversation =
          '❌ حصل خطأ في الاتصال بـ GPT API. [Status code: ${response.statusCode}]';
        });
      }
    } catch (e) {
      setState(() {
        generatedConversation = '❌ خطأ أثناء الاتصال: $e';
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
        title: Text('👥 ولّع القروب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: person1Controller,
                decoration: InputDecoration(
                  labelText: '💬 كلام الشخص 1',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: person2Controller,
                decoration: InputDecoration(
                  labelText: '💬 كلام الشخص 2',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: person3Controller,
                decoration: InputDecoration(
                  labelText: '💬 كلام الشخص 3',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: person4Controller,
                decoration: InputDecoration(
                  labelText: '💬 كلام الشخص 4',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : generateGroupChat,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('🎁 ولّع القروب!'),
              ),
              SizedBox(height: 16),
              generatedConversation.isNotEmpty
                  ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      generatedConversation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ReplyActionsWidget(
                    onRegenerate: generateGroupChat,
                    replyText: generatedConversation,
                  ),
                ],
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
