import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💎 Premium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🔥 اشترك في Premium:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('✅ شخصيات إضافية'),
              Text('✅ نبرات إضافية'),
              Text('✅ مواضيع ترند خاصة'),
              Text('✅ ردود أطول وأقوى'),
              Text('✅ بدون حدود يومية'),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // هنا تقدر تربط مع بوابة دفع لو تبغى
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('💎 Premium قريباً!')),
                  );
                },
                child: Text('✨ اشترك الآن'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
