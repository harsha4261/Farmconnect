import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ConversationListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> conversations;
  final Function(String) onConversationTap;
  final String filter;

  const ConversationListWidget({
    Key? key,
    required this.conversations,
    required this.onConversationTap,
    required this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredConversations = conversations.where((conv) {
      if (filter == 'all') return true;
      return conv['type'] == filter;
    }).toList();

    if (filteredConversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppTheme.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start messaging to coordinate your work',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredConversations.length,
      itemBuilder: (context, index) {
        final conversation = filteredConversations[index];
        final DateTime timestamp = conversation['timestamp'];
        final bool hasUnread = conversation['unreadCount'] > 0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasUnread
                  ? AppTheme.primaryLight.withAlpha(77)
                  : AppTheme.dividerLight,
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(conversation['avatar']),
                  backgroundColor: AppTheme.primaryLight,
                ),
                if (conversation['isOnline'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.successLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.surfaceLight,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    conversation['name'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w500,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withAlpha(26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    conversation['jobContext'],
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  conversation['lastMessage'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: hasUnread
                        ? AppTheme.textPrimaryLight
                        : AppTheme.textSecondaryLight,
                    fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppTheme.textSecondaryLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimestamp(timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    const Spacer(),
                    if (hasUnread)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          conversation['unreadCount'].toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onPrimaryLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            onTap: () => onConversationTap(conversation['id']),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
