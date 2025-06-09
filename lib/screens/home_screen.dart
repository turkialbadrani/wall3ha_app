import 'package:flutter/material.dart';
import 'group_chat_screen.dart';
import 'unified_dialogue_screen.dart';
import 'analyze_screen.dart';
import 'trending_topics_screen.dart';
import 'premium_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🔥 ولّعها'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupChatScreen()),
                );
              },
              child: Text('👥 ولّع القروب'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnifiedDialogueScreen()),
                );
              },
              child: Text('💬 حوار بين طرفين'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalyzeScreen()),
                );
              },
              child: Text('🧠 تحليل نفسي للنص'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrendingTopicsScreen()),
                );
              },
              child: Text('🔥 مواضيع ترند اليوم'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PremiumScreen()),
                );
              },
              child: Text('💎 Premium'),
            ),
          ],
        ),
      ),
    );
  }
}
