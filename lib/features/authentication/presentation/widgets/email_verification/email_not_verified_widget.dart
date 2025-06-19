import 'package:flutter/material.dart';

class EmailNotVerifiedWidget extends StatelessWidget {
  final Function onRequestButtonPressed;
  final Function onRefreshButtonPressed;  

  const EmailNotVerifiedWidget({
    super.key,
    required this.onRequestButtonPressed,
    required this.onRefreshButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning, color: Colors.orange, size: 48),
          const SizedBox(height: 8),
          const Text(
            'Please verify your email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Click the button below to send a verification email.'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  onRequestButtonPressed();
                },
                child: Text('Send Verification Email'),
              ),
              ElevatedButton(
                onPressed: () {
                  onRefreshButtonPressed();
                },
                child: const Text('I\'ve Verified'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
