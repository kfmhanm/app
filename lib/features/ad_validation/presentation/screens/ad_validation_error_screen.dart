import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/shared/widgets/button_widget.dart';

class AdValidationErrorScreen extends StatelessWidget {
  final String errorMessage;

  const AdValidationErrorScreen({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة التحقق'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 30),
            Text(
              'فشل التحقق',
              style: context.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                errorMessage,
                style: context.bodyLarge?.copyWith(
                  color: Colors.red.shade900,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ButtonWidget(
              title: 'المحاولة مرة أخرى',
              onTap: () {
                Navigator.pop(context);
              },
              height: 50,
              buttonColor: Colors.red.shade600,
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'رجوع',
                style: context.bodyLarge?.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

