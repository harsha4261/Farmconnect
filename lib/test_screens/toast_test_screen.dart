import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

class ToastTestScreen extends StatelessWidget {
  const ToastTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toast Examples'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('Basic Toasts'),
              _buildToastButton(
                'Simple Text Toast',
                () => BotToast.showText(text: 'This is a simple text toast'),
              ),
              _buildToastButton(
                'Longer Duration Toast',
                () => BotToast.showText(
                  text: 'This toast will stay for 5 seconds',
                  duration: const Duration(seconds: 5),
                ),
              ),
              
              _buildSectionHeader('Notification Style'),
              _buildToastButton(
                'Notification Toast',
                () => BotToast.showSimpleNotification(
                  title: 'New Message',
                  subTitle: 'You have a new notification from the app',
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.green[700]!,
                ),
              ),
              _buildToastButton(
                'Custom Notification',
                () => BotToast.showSimpleNotification(
                  title: 'Success!',
                  subTitle: 'Your action was completed successfully',
                  titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  subTitleStyle: const TextStyle(fontSize: 14, color: Colors.white70),
                  backgroundColor: Colors.green[800]!,
                  duration: const Duration(seconds: 3),
                ),
              ),

              _buildSectionHeader('Loading & Progress'),
              _buildToastButton(
                'Show Loading',
                () {
                  final cancel = BotToast.showLoading();
                  // Auto close after 3 seconds
                  Future.delayed(const Duration(seconds: 3), cancel);
                },
              ),
              _buildToastButton(
                'Custom Loading',
                () {
                  final cancel = BotToast.showCustomLoading(
                    toastBuilder: (cancelFunc) => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
                          SizedBox(height: 10),
                          Text('Processing...', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                  // Auto close after 3 seconds
                  Future.delayed(const Duration(seconds: 3), cancel);
                },
              ),

              _buildSectionHeader('Custom Position'),
              _buildToastButton(
                'Top Toast',
                () => BotToast.showText(
                  text: 'This appears at the top',
                  align: const Alignment(0, -0.7),
                ),
              ),
              _buildToastButton(
                'Center Toast',
                () => BotToast.showText(
                  text: 'Centered toast message',
                  align: Alignment.center,
                ),
              ),
              _buildToastButton(
                'Bottom Toast',
                () => BotToast.showText(
                  text: 'This appears at the bottom',
                  align: const Alignment(0, 0.8),
                ),
              ),

              const SizedBox(height: 30),
              Text(
                'Note: You can customize the appearance and behavior of toasts by modifying the BotToastInit in main.dart',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildToastButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[800],
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
