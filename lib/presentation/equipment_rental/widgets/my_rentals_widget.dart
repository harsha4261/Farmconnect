import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MyRentalsWidget extends StatefulWidget {
  const MyRentalsWidget({super.key});

  @override
  State<MyRentalsWidget> createState() => _MyRentalsWidgetState();
}

class _MyRentalsWidgetState extends State<MyRentalsWidget> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Active', 'Completed', 'Cancelled'];

  final List<Map<String, dynamic>> _myRentals = [
    {
      'id': '1',
      'equipmentName': 'John Deere 5075E Tractor',
      'equipmentImage':
          'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400&h=300&fit=crop',
      'ownerName': 'Ramesh Kumar',
      'bookingDate': '2025-01-15',
      'startTime': '08:00',
      'endTime': '16:00',
      'duration': '8 hours',
      'status': 'Active',
      'totalCost': 6400.0,
      'paymentMethod': 'UPI',
      'paymentStatus': 'Paid',
      'location': 'Sector 12, Faridabad',
      'contact': '+91 9876543210',
      'notes': 'Need tractor for plowing 5 acres',
      'trackingEnabled': true,
      'canExtend': true,
      'canCancel': false,
    },
    {
      'id': '2',
      'equipmentName': 'Aspee Sprayer 2000L',
      'equipmentImage':
          'https://images.unsplash.com/photo-1464207687429-7505649dae38?w=400&h=300&fit=crop',
      'ownerName': 'Vikram Reddy',
      'bookingDate': '2025-01-10',
      'startTime': '06:00',
      'endTime': '12:00',
      'duration': '6 hours',
      'status': 'Completed',
      'totalCost': 900.0,
      'paymentMethod': 'Cash',
      'paymentStatus': 'Paid',
      'location': 'Village Khera, Gurgaon',
      'contact': '+91 9876543213',
      'notes': 'Pesticide spraying for cotton crop',
      'trackingEnabled': false,
      'canExtend': false,
      'canCancel': false,
      'rating': 4.5,
    },
    {
      'id': '3',
      'equipmentName': 'Power Tiller KMW KX-14',
      'equipmentImage':
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop',
      'ownerName': 'Anand Singh',
      'bookingDate': '2025-01-20',
      'startTime': '10:00',
      'endTime': '16:00',
      'duration': '6 hours',
      'status': 'Confirmed',
      'totalCost': 1200.0,
      'paymentMethod': 'Bank Transfer',
      'paymentStatus': 'Pending',
      'location': 'Manesar, Gurgaon',
      'contact': '+91 9876543212',
      'notes': 'Soil preparation for wheat sowing',
      'trackingEnabled': false,
      'canExtend': false,
      'canCancel': true,
    },
    {
      'id': '4',
      'equipmentName': 'Mahindra Yuvo 575 DI',
      'equipmentImage':
          'https://images.unsplash.com/photo-1544737151-6e4b2d6e5f18?w=400&h=300&fit=crop',
      'ownerName': 'Suresh Patel',
      'bookingDate': '2025-01-05',
      'startTime': '08:00',
      'endTime': '20:00',
      'duration': '12 hours',
      'status': 'Cancelled',
      'totalCost': 9000.0,
      'paymentMethod': 'UPI',
      'paymentStatus': 'Refunded',
      'location': 'Sohna, Gurgaon',
      'contact': '+91 9876543211',
      'notes': 'Cancelled due to weather conditions',
      'trackingEnabled': false,
      'canExtend': false,
      'canCancel': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredRentals {
    if (_selectedFilter == 'All') {
      return _myRentals;
    }
    return _myRentals
        .where((rental) => rental['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: _buildRentalsList(),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  filter,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: Theme.of(context).cardColor,
                selectedColor: AppTheme.primaryLight,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryLight
                      : Theme.of(context).dividerColor,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRentalsList() {
    final filteredRentals = _filteredRentals;

    if (filteredRentals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color:
                  Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No rentals found',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your rental history will appear here',
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
      itemCount: filteredRentals.length,
      itemBuilder: (context, index) {
        final rental = filteredRentals[index];
        return _buildRentalCard(rental);
      },
    );
  }

  Widget _buildRentalCard(Map<String, dynamic> rental) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showRentalDetails(rental),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: rental['equipmentImage'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.error_outline),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rental['equipmentName'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Owner: ${rental['ownerName']}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${rental['bookingDate']} • ${rental['startTime']} - ${rental['endTime']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(rental['status']),
                ],
              ),
              const SizedBox(height: 12),
              _buildRentalInfo(rental),
              const SizedBox(height: 12),
              _buildActionButtons(rental),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = AppTheme.successLight;
        break;
      case 'Confirmed':
        statusColor = AppTheme.warningLight;
        break;
      case 'Completed':
        statusColor = AppTheme.primaryLight;
        break;
      case 'Cancelled':
        statusColor = AppTheme.errorLight;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRentalInfo(Map<String, dynamic> rental) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha(128),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duration',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              Text(
                rental['duration'],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Cost',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              Text(
                '₹${rental['totalCost'].toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              Text(
                '${rental['paymentMethod']} • ${rental['paymentStatus']}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: rental['paymentStatus'] == 'Paid'
                      ? AppTheme.successLight
                      : AppTheme.warningLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> rental) {
    return Row(
      children: [
        if (rental['trackingEnabled'])
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showTrackingInfo(rental),
              icon: const Icon(Icons.location_on, size: 16),
              label: Text(
                'Track',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: AppTheme.primaryLight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        if (rental['canExtend'])
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: OutlinedButton.icon(
                onPressed: () => _showExtendDialog(rental),
                icon: const Icon(Icons.access_time, size: 16),
                label: Text(
                  'Extend',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  side: BorderSide(color: AppTheme.warningLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        if (rental['canCancel'])
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(rental),
                icon: const Icon(Icons.cancel, size: 16),
                label: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  side: BorderSide(color: AppTheme.errorLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        if (rental['status'] == 'Completed' && rental['rating'] == null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ElevatedButton.icon(
                onPressed: () => _showRatingDialog(rental),
                icon: const Icon(Icons.star, size: 16),
                label: Text(
                  'Rate',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showRentalDetails(Map<String, dynamic> rental) {
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rental Details',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
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
                    _buildDetailRow('Equipment', rental['equipmentName']),
                    _buildDetailRow('Owner', rental['ownerName']),
                    _buildDetailRow('Date', rental['bookingDate']),
                    _buildDetailRow('Time',
                        '${rental['startTime']} - ${rental['endTime']}'),
                    _buildDetailRow('Duration', rental['duration']),
                    _buildDetailRow('Location', rental['location']),
                    _buildDetailRow('Contact', rental['contact']),
                    _buildDetailRow('Payment Method', rental['paymentMethod']),
                    _buildDetailRow('Payment Status', rental['paymentStatus']),
                    _buildDetailRow('Total Cost',
                        '₹${rental['totalCost'].toStringAsFixed(0)}'),
                    if (rental['notes'].isNotEmpty)
                      _buildDetailRow('Notes', rental['notes']),
                    if (rental['rating'] != null)
                      _buildDetailRow('Your Rating', '${rental['rating']} ⭐'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackingInfo(Map<String, dynamic> rental) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Equipment Tracking',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppTheme.primaryLight),
                        const SizedBox(width: 8),
                        Text(
                          'Current Location',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rental['location'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: AppTheme.warningLight),
                        const SizedBox(width: 8),
                        Text(
                          'Status',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'In Use - 4 hours remaining',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // Open maps app or show detailed tracking
                        },
                        icon: const Icon(Icons.map),
                        label: Text(
                          'View on Map',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryLight,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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

  void _showExtendDialog(Map<String, dynamic> rental) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Extend Rental',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Would you like to extend the rental for ${rental['equipmentName']}?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Show extension options
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Extend',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> rental) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Rental',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel the rental for ${rental['equipmentName']}?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Rental',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Process cancellation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Cancel Rental',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(Map<String, dynamic> rental) {
    double rating = 0;
    final TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Rate Your Experience',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How was your experience with ${rental['equipmentName']}?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        rating = (index + 1).toDouble();
                      });
                    },
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your review (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: rating > 0
                  ? () {
                      Navigator.pop(context);
                      // Submit rating
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryLight,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
