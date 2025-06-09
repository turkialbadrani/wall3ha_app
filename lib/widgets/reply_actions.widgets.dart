import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReplyActionsWidget extends StatelessWidget {
  final VoidCallback onRegenerate;
  final String replyText;

  const ReplyActionsWidget({
    required this.onRegenerate,
    required this.replyText,
    Key? key,
  }) : super(key: key);

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: replyText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ تم نسخ الرد')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: onRegenerate,
          icon: Icon(Icons.refresh),
          label: Text('🎁 ولّعها أكثر'),
        ),
        SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => copyToClipboard(context),
          icon: Icon(Icons.copy),
          label: Text('💾 نسخ الرد'),
        ),
      ],
    );
  }
}
