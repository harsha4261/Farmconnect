class NavItem {
  final String title;
  final String icon; // matches CustomIconWidget names
  final String route;
  final List<String> roles; // e.g., ['farmer']

  NavItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.roles,
  });

  factory NavItem.fromMap(Map<String, dynamic> json) => NavItem(
        title: json['title'] as String,
        icon: json['icon'] as String,
        route: json['route'] as String,
        roles: (json['roles'] as List<dynamic>? ?? []).cast<String>(),
      );
}


