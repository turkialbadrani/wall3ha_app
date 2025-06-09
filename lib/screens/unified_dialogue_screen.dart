import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';

class UnifiedDialogueScreen extends StatefulWidget {
  @override
  _UnifiedDialogueScreenState createState() => _UnifiedDialogueScreenState();
}

class _UnifiedDialogueScreenState extends State<UnifiedDialogueScreen> {
  final TextEditingController person1TextController = TextEditingController();
  final TextEditingController person2TextController = TextEditingController();

  String person1RelationDropdown = 'أنا (المستخدم)';
  final TextEditingController person1RelationController = TextEditingController();

  String person2RelationDropdown = 'زوجة';
  final TextEditingController person2RelationController = TextEditingController();

  String toneDropdown = 'مضحك 😂';
  final TextEditingController toneController = TextEditingController();

  String generatedReply = '';
  bool isLoading = false;

  void generateReply() async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    setState(() {
      isLoading = true;
      generatedReply = '';
    });

    final person1Relation = person1RelationController.text.isNotEmpty
        ? person1RelationController.text
        : person1RelationDropdown;

    final person2Relation = person2RelationController.text.isNotEmpty
        ? person2RelationController.text
        : person2RelationDropdown;

    final tone = toneController.text.isNotEmpty ? toneController.text : toneDropdown;

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
              'content':
              'أنت مساعد ذكي. حلل الحوار بين طرفين حسب المعلومات التالية:\n\n'
                  '- علاقة الطرف الأول بالمستخدم: $person1Relation\n'
                  '- علاقة الطرف الثاني بالمستخدم: $person2Relation\n'
                  '- النبرة المطلوبة: $tone\n\n'
                  'النص:\n'
                  '- كلام الطرف الأول: ${person1TextController.text}\n'
                  '- كلام الطرف الثاني: ${person2TextController.text}\n\n'
                  'اكتب رد مناسب جدًا يعكس العلاقة والنبرة، ويكون ممتع للقراءة باللغة العربية.'
            },
            {
              'role': 'user',
              'content': 'رجاءً أعطني الرد الآن.',
            },
          ],
          'max_tokens': 200,
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
        title: Text('💬 حوار بين طرفين'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('🧑‍🤝‍🧑 علاقة الطرف الأول:'),
              DropdownButton<String>(
                value: person1RelationDropdown,
                onChanged: (String? newValue) {
                  setState(() {
                    person1RelationDropdown = newValue!;
                  });
                },
                items: <String>[
                  'أنا (المستخدم)',
                  'أب',
                  'أم',
                  'أخ',
                  'أخت',
                  'زوج',
                  'زوجة',
                  'صديق',
                  'مدير',
                  'زميل عمل',
                  'جار',
                  'خصم',
                  'معلم',
                  'طالب',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: person1RelationController,
                decoration: InputDecoration(
                  labelText: '🖊️ أو اكتب علاقة مخصصة للطرف الأول',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('🧑‍🤝‍🧑 علاقة الطرف الثاني:'),
              DropdownButton<String>(
                value: person2RelationDropdown,
                onChanged: (String? newValue) {
                  setState(() {
                    person2RelationDropdown = newValue!;
                  });
                },
                items: <String>[
                  'زوجة',
                  'زوج',
                  'أب',
                  'أم',
                  'أخ',
                  'أخت',
                  'صديق',
                  'مدير',
                  'زميل عمل',
                  'جار',
                  'خصم',
                  'معلم',
                  'طالب',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: person2RelationController,
                decoration: InputDecoration(
                  labelText: '🖊️ أو اكتب علاقة مخصصة للطرف الثاني',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('🎭 نبرة الرد:'),
              DropdownButton<String>(
                value: toneDropdown,
                onChanged: (String? newValue) {
                  setState(() {
                    toneDropdown = newValue!;
                  });
                },
                items: <String>[
                  'مضحك 😂',
                  'رسمي 📝',
                  'قصف جبهة 🔥',
                  'عاطفي 💕',
                  'حزين 😢',
                  'سخرية 🤭',
                  'طقطقة كروية ⚽️🔥',
                  'غبي 🤪',
                  'حازم 💪',
                  'فاهي 🤪',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: toneController,
                decoration: InputDecoration(
                  labelText: '🖊️ أو اكتب نبرة مخصصة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: person1TextController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'كلام الطرف الأول',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: person2TextController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'كلام الطرف الثاني (اختياري)',
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
