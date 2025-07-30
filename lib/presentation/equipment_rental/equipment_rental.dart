import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/equipment_booking_widget.dart';
import './widgets/equipment_card_widget.dart';
import './widgets/equipment_filter_widget.dart';
import './widgets/my_rentals_widget.dart';

class EquipmentRental extends StatefulWidget {
  const EquipmentRental({super.key});

  @override
  State<EquipmentRental> createState() => _EquipmentRentalState();
}

class _EquipmentRentalState extends State<EquipmentRental>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isAvailableOnly = false;
  String _sortBy = 'Distance';

  final List<String> _categories = [
    'All',
    'Tractors',
    'Tillers',
    'Sprayers',
    'Harvesters',
    'Plows',
    'Cultivators'
  ];

  final List<Map<String, dynamic>> _equipmentData = [
    {
      'id': '1',
      'name': 'John Deere 5075E Tractor',
      'category': 'Tractors',
      'hourlyRate': 800.0,
      'dailyRate': 6000.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400&h=300&fit=crop',
      'availability': true,
      'ownerName': 'Ramesh Kumar',
      'ownerRating': 4.8,
      'distance': 2.5,
      'specifications': {
        'power': '75 HP',
        'fuel': 'Diesel',
        'transmission': 'Manual',
        'implements': 'Rotary Tiller, Cultivator'
      },
      'rentalTerms': 'Min 4 hours, Max 24 hours',
      'pickupDelivery': 'Pickup only',
      'contact': '+91 9876543210'
    },
    {
      'id': '2',
      'name': 'Mahindra Yuvo 575 DI',
      'category': 'Tractors',
      'hourlyRate': 750.0,
      'dailyRate': 5500.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1544737151-6e4b2d6e5f18?w=400&h=300&fit=crop',
      'availability': true,
      'ownerName': 'Suresh Patel',
      'ownerRating': 4.6,
      'distance': 3.2,
      'specifications': {
        'power': '57 HP',
        'fuel': 'Diesel',
        'transmission': 'Manual',
        'implements': 'Plow, Harrow'
      },
      'rentalTerms': 'Min 8 hours, Max 3 days',
      'pickupDelivery': 'Both available',
      'contact': '+91 9876543211'
    },
    {
      'id': '3',
      'name': 'Power Tiller KMW KX-14',
      'category': 'Tillers',
      'hourlyRate': 200.0,
      'dailyRate': 1200.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop',
      'availability': false,
      'ownerName': 'Anand Singh',
      'ownerRating': 4.7,
      'distance': 1.8,
      'specifications': {
        'power': '14 HP',
        'fuel': 'Diesel',
        'width': '110 cm',
        'depth': '20 cm'
      },
      'rentalTerms': 'Min 2 hours, Max 12 hours',
      'pickupDelivery': 'Pickup only',
      'contact': '+91 9876543212'
    },
    {
      'id': '4',
      'name': 'Aspee Sprayer 2000L',
      'category': 'Sprayers',
      'hourlyRate': 150.0,
      'dailyRate': 900.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1464207687429-7505649dae38?w=400&h=300&fit=crop',
      'availability': true,
      'ownerName': 'Vikram Reddy',
      'ownerRating': 4.9,
      'distance': 4.1,
      'specifications': {
        'capacity': '2000 L',
        'pressure': '20 bar',
        'nozzles': '16',
        'coverage': '10 acres/hour'
      },
      'rentalTerms': 'Min 3 hours, Max 8 hours',
      'pickupDelivery': 'Delivery available',
      'contact': '+91 9876543213'
    },
    {
      'id': '5',
      'name': 'Claas Jaguar 870 Harvester',
      'category': 'Harvesters',
      'hourlyRate': 1200.0,
      'dailyRate': 8000.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1500595046743-cd271d694d30?w=400&h=300&fit=crop',
      'availability': true,
      'ownerName': 'Manoj Sharma',
      'ownerRating': 4.5,
      'distance': 6.2,
      'specifications': {
        'power': '870 HP',
        'capacity': '50 tons/hour',
        'fuel': 'Diesel',
        'header': '7.5m cutting width'
      },
      'rentalTerms': 'Min 8 hours, Max 2 days',
      'pickupDelivery': 'Operator included',
      'contact': '+91 9876543214'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredEquipment {
    return _equipmentData.where((equipment) {
      final matchesSearch = equipment['name']
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          equipment['category'] == _selectedCategory;
      final matchesAvailability =
          !_isAvailableOnly || equipment['availability'];
      return matchesSearch && matchesCategory && matchesAvailability;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EquipmentFilterWidget(
        selectedCategory: _selectedCategory,
        isAvailableOnly: _isAvailableOnly,
        sortBy: _sortBy,
        categories: _categories,
        onCategoryChanged: (category) {
          setState(() {
            _selectedCategory = category;
          });
        },
        onAvailabilityChanged: (availability) {
          setState(() {
            _isAvailableOnly = availability;
          });
        },
        onSortChanged: (sort) {
          setState(() {
            _sortBy = sort;
          });
        },
      ),
    );
  }

  void _showBookingModal(Map<String, dynamic> equipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EquipmentBookingWidget(
        equipment: equipment,
        onBookingConfirmed: (bookingDetails) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking confirmed for ${equipment['name']}'),
              backgroundColor: AppTheme.successLight,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilter(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEquipmentGrid(),
                  const MyRentalsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const SizedBox(width: 8),
          Text(
            'Equipment Rental',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.location_on_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search equipment...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: IconButton(
              onPressed: _showFilterModal,
              icon: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Available Equipment'),
          Tab(text: 'My Rentals'),
        ],
      ),
    );
  }

  Widget _buildEquipmentGrid() {
    final filteredEquipment = _filteredEquipment;

    if (filteredEquipment.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.agriculture_outlined,
              size: 64,
              color:
                  Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No equipment found',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withAlpha(179),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredEquipment.length,
      itemBuilder: (context, index) {
        final equipment = filteredEquipment[index];
        return EquipmentCardWidget(
          equipment: equipment,
          onBookTap: () => _showBookingModal(equipment),
          onDetailsTap: () => _showEquipmentDetails(equipment),
        );
      },
    );
  }

  void _showEquipmentDetails(Map<String, dynamic> equipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(equipment['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(179),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withAlpha(128),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          equipment['name'],
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              equipment['ownerName'],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              equipment['ownerRating'].toString(),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection(
                        'Specifications', equipment['specifications']),
                    const SizedBox(height: 16),
                    _buildDetailInfo('Rental Terms', equipment['rentalTerms']),
                    const SizedBox(height: 16),
                    _buildDetailInfo(
                        'Pickup/Delivery', equipment['pickupDelivery']),
                    const SizedBox(height: 16),
                    _buildDetailInfo('Contact', equipment['contact']),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hourly Rate',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                              Text(
                                '₹${equipment['hourlyRate'].toStringAsFixed(0)}/hr',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Rate',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                              Text(
                                '₹${equipment['dailyRate'].toStringAsFixed(0)}/day',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (equipment['availability'])
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showBookingModal(equipment);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryLight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Book Now',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Currently Unavailable',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
      String title, Map<String, dynamic> specifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            children: specifications.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}
