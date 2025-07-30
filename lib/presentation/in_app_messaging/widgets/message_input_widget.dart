import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MessageInputWidget extends StatefulWidget {
  final Function(String, {String type}) onSendMessage;
  final VoidCallback onShareLocation;
  final VoidCallback onShowQuickReplies;

  const MessageInputWidget({
    Key? key,
    required this.onSendMessage,
    required this.onShareLocation,
    required this.onShowQuickReplies,
  }) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _textController.text.trim().isNotEmpty;
    });
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      widget.onSendMessage(_textController.text.trim());
      _textController.clear();
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    // Voice recording functionality would be implemented here
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    // Send voice message
    widget.onSendMessage('Voice message sent', type: 'voice');
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Content',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  Icons.camera_alt,
                  'Camera',
                  () {
                    Navigator.pop(context);
                    widget.onSendMessage('Photo taken', type: 'photo');
                  },
                ),
                _buildAttachmentOption(
                  Icons.photo_library,
                  'Gallery',
                  () {
                    Navigator.pop(context);
                    widget.onSendMessage('Photo from gallery', type: 'photo');
                  },
                ),
                _buildAttachmentOption(
                  Icons.location_on,
                  'Location',
                  () {
                    Navigator.pop(context);
                    widget.onShareLocation();
                  },
                ),
                _buildAttachmentOption(
                  Icons.attach_file,
                  'File',
                  () {
                    Navigator.pop(context);
                    widget.onSendMessage('Document attached', type: 'file');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
      IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryLight,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(
          top: BorderSide(color: AppTheme.dividerLight),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.textSecondaryLight),
            onPressed: _showAttachmentOptions,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.dividerLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textPrimaryLight,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: AppTheme.textSecondaryLight,
                    ),
                    onPressed: () {
                      // Emoji picker functionality
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (_hasText)
            IconButton(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: AppTheme.onPrimaryLight,
                  size: 16,
                ),
              ),
              onPressed: _sendMessage,
            )
          else
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.flash_on, color: AppTheme.accentLight),
                  onPressed: widget.onShowQuickReplies,
                ),
                GestureDetector(
                  onTapDown: (_) => _startRecording(),
                  onTapUp: (_) => _stopRecording(),
                  onTapCancel: () => _stopRecording(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? AppTheme.errorLight
                          : AppTheme.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: AppTheme.onPrimaryLight,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
