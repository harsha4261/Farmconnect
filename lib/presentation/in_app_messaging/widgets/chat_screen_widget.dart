import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './message_input_widget.dart';
import './quick_reply_widget.dart';

class ChatScreenWidget extends StatefulWidget {
  final String conversationId;
  final Map<String, dynamic> conversation;
  final VoidCallback onBack;

  const ChatScreenWidget({
    Key? key,
    required this.conversationId,
    required this.conversation,
    required this.onBack,
  }) : super(key: key);

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _showQuickReplies = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Sample messages for demonstration
    setState(() {
      _messages.addAll([
        {
          'id': '1',
          'text':
              'Hi! I saw your job posting for corn harvesting. I\'m interested and available.',
          'sender': 'other',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'type': 'text',
        },
        {
          'id': '2',
          'text':
              'Great! Can you tell me about your experience with harvesting equipment?',
          'sender': 'me',
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          'type': 'text',
        },
        {
          'id': '3',
          'text':
              'I have 5 years of experience with John Deere combines and Case IH equipment.',
          'sender': 'other',
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          'type': 'text',
        },
        {
          'id': '4',
          'text':
              'Perfect! The job starts tomorrow at 7 AM. Are you available?',
          'sender': 'me',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'type': 'text',
        },
        {
          'id': '5',
          'text':
              'Yes, I\'ll be there at 7 AM sharp. Could you share the exact location?',
          'sender': 'other',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
          'type': 'text',
        },
        {
          'id': '6',
          'location': '123 Farm Road, Countryside, State 12345',
          'latitude': 40.7128,
          'longitude': -74.0060,
          'sender': 'me',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
          'type': 'location',
        },
      ]);
    });
  }

  void _sendMessage(String text, {String type = 'text'}) {
    if (text.trim().isEmpty) return;

    final message = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text,
      'sender': 'me',
      'timestamp': DateTime.now(),
      'type': type,
    };

    setState(() {
      _messages.add(message);
      _showQuickReplies = false;
    });

    _scrollToBottom();
  }

  void _sendQuickReply(String text) {
    _sendMessage(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _shareLocation() {
    // Simulate sharing location
    _sendMessage('Current location shared', type: 'location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.textPrimaryLight),
          onPressed: widget.onBack,
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.conversation['avatar']),
              backgroundColor: AppTheme.primaryLight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation['name'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: widget.conversation['isOnline']
                              ? AppTheme.successLight
                              : AppTheme.textSecondaryLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.conversation['isOnline'] ? 'Online' : 'Offline',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: AppTheme.primaryLight),
            onPressed: () {
              // Voice call functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.textPrimaryLight),
            onPressed: () {
              _showChatOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withAlpha(26),
              border: Border(
                bottom: BorderSide(color: AppTheme.dividerLight),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.work,
                  size: 16,
                  color: AppTheme.primaryLight,
                ),
                const SizedBox(width: 8),
                Text(
                  'Job Context: ${widget.conversation['jobContext']}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'me';
                final isLocation = message['type'] == 'location';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              NetworkImage(widget.conversation['avatar']),
                          backgroundColor: AppTheme.primaryLight,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? AppTheme.primaryLight
                                    : AppTheme.surfaceLight,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: Radius.circular(isMe ? 12 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 12),
                                ),
                                border: isMe
                                    ? null
                                    : Border.all(color: AppTheme.dividerLight),
                              ),
                              child: isLocation
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: isMe
                                                  ? AppTheme.onPrimaryLight
                                                  : AppTheme.primaryLight,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Location Shared',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isMe
                                                    ? AppTheme.onPrimaryLight
                                                    : AppTheme.primaryLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          message['location'] ?? 'Location',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: isMe
                                                ? AppTheme.onPrimaryLight
                                                : AppTheme.textPrimaryLight,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      message['text'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: isMe
                                            ? AppTheme.onPrimaryLight
                                            : AppTheme.textPrimaryLight,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatMessageTime(message['timestamp']),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.primaryLight,
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: AppTheme.onPrimaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          if (_showQuickReplies)
            QuickReplyWidget(
              onQuickReply: _sendQuickReply,
              onDismiss: () => setState(() => _showQuickReplies = false),
            ),
          MessageInputWidget(
            onSendMessage: _sendMessage,
            onShareLocation: _shareLocation,
            onShowQuickReplies: () =>
                setState(() => _showQuickReplies = !_showQuickReplies),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.translate, color: AppTheme.primaryLight),
              title: const Text('Translate Messages'),
              onTap: () {
                Navigator.pop(context);
                // Translation functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: AppTheme.primaryLight),
              title: const Text('Search in Chat'),
              onTap: () {
                Navigator.pop(context);
                // Search functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off,
                  color: AppTheme.warningLight),
              title: const Text('Mute Notifications'),
              onTap: () {
                Navigator.pop(context);
                // Mute functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: AppTheme.errorLight),
              title: const Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                // Report functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
