import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/chat_screen_widget.dart';
import './widgets/conversation_list_widget.dart';
import './widgets/message_search_widget.dart';

class InAppMessaging extends StatefulWidget {
  const InAppMessaging({Key? key}) : super(key: key);

  @override
  State<InAppMessaging> createState() => _InAppMessagingState();
}

class _InAppMessagingState extends State<InAppMessaging>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedConversationId;
  bool _isSearchActive = false;

  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'John Martinez',
      'type': 'worker',
      'lastMessage': 'I\'ll be there at 7 AM sharp',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 0,
      'jobContext': 'Corn Harvesting',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'type': 'worker',
      'lastMessage': 'Weather looks good for tomorrow',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 2,
      'jobContext': 'Apple Picking',
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b9e74e04?w=100',
      'isOnline': false,
    },
    {
      'id': '3',
      'name': 'Michael Chen',
      'type': 'worker',
      'lastMessage': 'Equipment maintenance complete',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
      'jobContext': 'Tractor Operation',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      'isOnline': true,
    },
    {
      'id': '4',
      'name': 'Emily Rodriguez',
      'type': 'farmer',
      'lastMessage': 'Can you start an hour earlier?',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'unreadCount': 1,
      'jobContext': 'Irrigation Setup',
      'avatar':
          'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=100',
      'isOnline': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startConversation(String contactId) {
    setState(() {
      _selectedConversationId = contactId;
    });
  }

  void _backToConversationList() {
    setState(() {
      _selectedConversationId = null;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _selectedConversationId == null
          ? AppBar(
              title: Text(
                'Messages',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppTheme.surfaceLight,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: AppTheme.textPrimaryLight),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isSearchActive ? Icons.close : Icons.search,
                    color: AppTheme.textPrimaryLight,
                  ),
                  onPressed: _toggleSearch,
                ),
              ],
              bottom: _isSearchActive
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(60),
                      child: MessageSearchWidget(),
                    )
                  : TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Workers'),
                        Tab(text: 'Farmers'),
                      ],
                      labelColor: AppTheme.primaryLight,
                      unselectedLabelColor: AppTheme.textSecondaryLight,
                      indicatorColor: AppTheme.primaryLight,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            )
          : null,
      body: _selectedConversationId == null
          ? _isSearchActive
              ? const MessageSearchWidget()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    ConversationListWidget(
                      conversations: _conversations,
                      onConversationTap: _startConversation,
                      filter: 'all',
                    ),
                    ConversationListWidget(
                      conversations: _conversations,
                      onConversationTap: _startConversation,
                      filter: 'worker',
                    ),
                    ConversationListWidget(
                      conversations: _conversations,
                      onConversationTap: _startConversation,
                      filter: 'farmer',
                    ),
                  ],
                )
          : ChatScreenWidget(
              conversationId: _selectedConversationId!,
              conversation: _conversations.firstWhere(
                (conv) => conv['id'] == _selectedConversationId,
              ),
              onBack: _backToConversationList,
            ),
      floatingActionButton: _selectedConversationId == null && !_isSearchActive
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to new message screen
                _showNewMessageDialog();
              },
              backgroundColor: AppTheme.primaryLight,
              child: const Icon(
                Icons.message,
                color: AppTheme.onPrimaryLight,
              ),
            )
          : null,
    );
  }

  void _showNewMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'New Message',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  final contacts = [
                    {'name': 'Alex Thompson', 'type': 'Available Worker'},
                    {'name': 'Lisa Brown', 'type': 'Local Farmer'},
                    {'name': 'David Wilson', 'type': 'Equipment Specialist'},
                  ];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        contacts[index]['name']![0],
                        style: const TextStyle(color: AppTheme.onPrimaryLight),
                      ),
                    ),
                    title: Text(contacts[index]['name']!),
                    subtitle: Text(contacts[index]['type']!),
                    onTap: () {
                      Navigator.pop(context);
                      // Start new conversation
                    },
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
