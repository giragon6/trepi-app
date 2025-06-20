import 'package:flutter/material.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';

class EmailSentWidget extends StatelessWidget {
  final Function onRefreshButtonPressed;

  const EmailSentWidget({
    super.key,
    required this.onRefreshButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        border: Border.all(color: TrepiColor.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning, color: TrepiColor.orange, size: 48),
          const SizedBox(height: 8),
          const Text(
            'Please verify your email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Check your inbox for a verification link.'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TODO: Implement resend email functionality
              ElevatedButton(
                onPressed: () {
                  onRefreshButtonPressed();
                },
                child: const Text('I\'ve Verified', style: TextStyle(fontSize: 14, color: Colors.black),
              )),
            ],
          ),
        ],
      ),
    );
  }
}