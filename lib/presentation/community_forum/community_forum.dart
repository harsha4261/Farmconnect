import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/forum_filter_widget.dart';
import './widgets/forum_search_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/post_card_widget.dart';
import './widgets/post_composer_widget.dart';
import './widgets/trending_topics_widget.dart';

class CommunityForum extends StatefulWidget {
  const CommunityForum({super.key});

  @override
  State<CommunityForum> createState() => _CommunityForumState();
}

class _CommunityForumState extends State<CommunityForum>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _selectedLanguage = 'english';
  String _selectedFilter = 'all';

  // Mock data for forum posts
  final List<Map<String, dynamic>> _forumPosts = [
    {
      "id": 1,
      "authorName": "Ravi Patel",
      "authorPhoto":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "timestamp": "2 hours ago",
      "location": "Gujarat, India",
      "category": "tips",
      "title": "Best time for cotton planting in Gujarat",
      "content":
          "Based on my 15 years of experience, the ideal time for cotton planting in Gujarat is...",
      "imageUrl":
          "https://images.pexels.com/photos/96715/pexels-photo-96715.jpeg?auto=compress&cs=tinysrgb&w=400",
      "likes": 24,
      "comments": 8,
      "isLiked": false,
      "isBookmarked": true,
      "hashtags": ["#cotton", "#gujarat", "#planting"]
    },
    {
      "id": 2,
      "authorName": "Sunita Devi",
      "authorPhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "timestamp": "5 hours ago",
      "location": "Punjab, India",
      "category": "market",
      "title": "Wheat prices increased in local mandi",
      "content":
          "Today's wheat rate in Amritsar mandi is ₹2,050 per quintal. Good time to sell!",
      "imageUrl": null,
      "likes": 12,
      "comments": 15,
      "isLiked": true,
      "isBookmarked": false,
      "hashtags": ["#wheat", "#price", "#punjab"]
    },
    {
      "id": 3,
      "authorName": "Amit Singh",
      "authorPhoto":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "timestamp": "1 day ago",
      "location": "Haryana, India",
      "category": "scheme",
      "title": "New PM-KISAN scheme benefits",
      "content":
          "Government has announced additional benefits under PM-KISAN scheme. Here's what farmers need to know...",
      "imageUrl":
          "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=400",
      "likes": 45,
      "comments": 22,
      "isLiked": false,
      "isBookmarked": true,
      "hashtags": ["#pmkisan", "#scheme", "#government"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _handlePostLike(int postId) {
    setState(() {
      final postIndex = _forumPosts.indexWhere((post) => post['id'] == postId);
      if (postIndex != -1) {
        _forumPosts[postIndex]['isLiked'] = !_forumPosts[postIndex]['isLiked'];
        _forumPosts[postIndex]['likes'] +=
            _forumPosts[postIndex]['isLiked'] ? 1 : -1;
      }
    });
  }

  void _handlePostBookmark(int postId) {
    setState(() {
      final postIndex = _forumPosts.indexWhere((post) => post['id'] == postId);
      if (postIndex != -1) {
        _forumPosts[postIndex]['isBookmarked'] =
            !_forumPosts[postIndex]['isBookmarked'];
      }
    });
  }

  void _showPostComposer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PostComposerWidget(
        onPost: (Map<String, dynamic> newPost) {
          setState(() {
            _forumPosts.insert(0, newPost);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        title: Text(
          'Community Forum',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          LanguageSelectorWidget(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: (language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ForumSearchWidget(),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'forum',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              text: 'General',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Market Rates',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'lightbulb',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Tips & Tricks',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'policy',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Gov Schemes',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Trending Topics
          TrendingTopicsWidget(),

          // Forum Filter
          ForumFilterWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),

          // Posts List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // General Discussion
                RefreshIndicator(
                  onRefresh: () => Future.delayed(Duration(seconds: 1)),
                  child: ListView.builder(
                    itemCount: _forumPosts.length,
                    itemBuilder: (context, index) {
                      final post = _forumPosts[index];
                      return PostCardWidget(
                        post: post,
                        onLike: () => _handlePostLike(post['id']),
                        onBookmark: () => _handlePostBookmark(post['id']),
                        onComment: () {
                          // Handle comment tap
                        },
                        onShare: () {
                          // Handle share
                        },
                        onReport: () {
                          // Handle report
                        },
                      );
                    },
                  ),
                ),

                // Market Rates
                RefreshIndicator(
                  onRefresh: () => Future.delayed(Duration(seconds: 1)),
                  child: ListView.builder(
                    itemCount: _forumPosts
                        .where((post) => post['category'] == 'market')
                        .length,
                    itemBuilder: (context, index) {
                      final marketPosts = _forumPosts
                          .where((post) => post['category'] == 'market')
                          .toList();
                      final post = marketPosts[index];
                      return PostCardWidget(
                        post: post,
                        onLike: () => _handlePostLike(post['id']),
                        onBookmark: () => _handlePostBookmark(post['id']),
                        onComment: () {
                          // Handle comment tap
                        },
                        onShare: () {
                          // Handle share
                        },
                        onReport: () {
                          // Handle report
                        },
                      );
                    },
                  ),
                ),

                // Tips & Tricks
                RefreshIndicator(
                  onRefresh: () => Future.delayed(Duration(seconds: 1)),
                  child: ListView.builder(
                    itemCount: _forumPosts
                        .where((post) => post['category'] == 'tips')
                        .length,
                    itemBuilder: (context, index) {
                      final tipsPosts = _forumPosts
                          .where((post) => post['category'] == 'tips')
                          .toList();
                      final post = tipsPosts[index];
                      return PostCardWidget(
                        post: post,
                        onLike: () => _handlePostLike(post['id']),
                        onBookmark: () => _handlePostBookmark(post['id']),
                        onComment: () {
                          // Handle comment tap
                        },
                        onShare: () {
                          // Handle share
                        },
                        onReport: () {
                          // Handle report
                        },
                      );
                    },
                  ),
                ),

                // Government Schemes
                RefreshIndicator(
                  onRefresh: () => Future.delayed(Duration(seconds: 1)),
                  child: ListView.builder(
                    itemCount: _forumPosts
                        .where((post) => post['category'] == 'scheme')
                        .length,
                    itemBuilder: (context, index) {
                      final schemePosts = _forumPosts
                          .where((post) => post['category'] == 'scheme')
                          .toList();
                      final post = schemePosts[index];
                      return PostCardWidget(
                        post: post,
                        onLike: () => _handlePostLike(post['id']),
                        onBookmark: () => _handlePostBookmark(post['id']),
                        onComment: () {
                          // Handle comment tap
                        },
                        onShare: () {
                          // Handle share
                        },
                        onReport: () {
                          // Handle report
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPostComposer,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}
