import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/balance_header_widget.dart';
import './widgets/earnings_chart_widget.dart';
import './widgets/payment_method_card_widget.dart';
import './widgets/payout_options_widget.dart';
import './widgets/transaction_card_widget.dart';

class PaymentAndEarnings extends StatefulWidget {
  const PaymentAndEarnings({super.key});

  @override
  State<PaymentAndEarnings> createState() => _PaymentAndEarningsState();
}

class _PaymentAndEarningsState extends State<PaymentAndEarnings>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isBalanceVisible = true;
  String _selectedUserType = 'farmer'; // farmer or worker
  String _selectedPeriod = 'weekly';

  // Mock data for transactions
  final List<Map<String, dynamic>> _transactions = [
    {
      "id": "TXN001",
      "jobTitle": "Wheat Harvesting - Field A",
      "amount": 2500.0,
      "date": DateTime.now().subtract(Duration(days: 1)),
      "status": "completed",
      "type": "payment",
      "workerName": "Rajesh Kumar",
      "farmLocation": "Punjab, India",
      "paymentMethod": "Bank Transfer",
      "receiptUrl": "https://example.com/receipt/001"
    },
    {
      "id": "TXN002",
      "jobTitle": "Rice Planting - Field B",
      "amount": 1800.0,
      "date": DateTime.now().subtract(Duration(days: 3)),
      "status": "pending",
      "type": "payment",
      "workerName": "Suresh Patel",
      "farmLocation": "Gujarat, India",
      "paymentMethod": "Digital Wallet",
      "receiptUrl": null
    },
    {
      "id": "TXN003",
      "jobTitle": "Irrigation System Setup",
      "amount": 3200.0,
      "date": DateTime.now().subtract(Duration(days: 5)),
      "status": "failed",
      "type": "payment",
      "workerName": "Amit Singh",
      "farmLocation": "Haryana, India",
      "paymentMethod": "Credit Card",
      "receiptUrl": null
    },
    {
      "id": "TXN004",
      "jobTitle": "Corn Harvesting",
      "amount": 2100.0,
      "date": DateTime.now().subtract(Duration(days: 7)),
      "status": "completed",
      "type": "earning",
      "farmerName": "Mohan Reddy",
      "farmLocation": "Andhra Pradesh, India",
      "paymentMethod": "Bank Transfer",
      "receiptUrl": "https://example.com/receipt/004"
    }
  ];

  // Mock data for payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "PM001",
      "type": "bank",
      "name": "State Bank of India",
      "accountNumber": "****1234",
      "isDefault": true,
      "icon": "account_balance"
    },
    {
      "id": "PM002",
      "type": "card",
      "name": "HDFC Credit Card",
      "cardNumber": "****5678",
      "isDefault": false,
      "icon": "credit_card"
    },
    {
      "id": "PM003",
      "type": "wallet",
      "name": "Paytm Wallet",
      "accountNumber": "****9012",
      "isDefault": false,
      "icon": "account_balance_wallet"
    }
  ];

  // Mock earnings data
  final Map<String, List<Map<String, dynamic>>> _earningsData = {
    'daily': [
      {"day": "Mon", "amount": 450.0},
      {"day": "Tue", "amount": 320.0},
      {"day": "Wed", "amount": 580.0},
      {"day": "Thu", "amount": 720.0},
      {"day": "Fri", "amount": 640.0},
      {"day": "Sat", "amount": 890.0},
      {"day": "Sun", "amount": 520.0}
    ],
    'weekly': [
      {"week": "Week 1", "amount": 2800.0},
      {"week": "Week 2", "amount": 3200.0},
      {"week": "Week 3", "amount": 2950.0},
      {"week": "Week 4", "amount": 3400.0}
    ],
    'monthly': [
      {"month": "Jan", "amount": 12500.0},
      {"month": "Feb", "amount": 14200.0},
      {"month": "Mar", "amount": 13800.0},
      {"month": "Apr", "amount": 15600.0},
      {"month": "May", "amount": 16200.0},
      {"month": "Jun", "amount": 14900.0}
    ]
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Payment & Earnings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedUserType = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'farmer',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'agriculture',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Farmer View'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'worker',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person_outline',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Worker View'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance Header
          BalanceHeaderWidget(
            balance: _selectedUserType == 'farmer' ? 45600.0 : 28400.0,
            isVisible: _isBalanceVisible,
            onToggleVisibility: () {
              setState(() {
                _isBalanceVisible = !_isBalanceVisible;
              });
            },
            userType: _selectedUserType,
          ),

          // Tab Bar
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.lightTheme.tabBarTheme.labelColor,
              unselectedLabelColor:
                  AppTheme.lightTheme.tabBarTheme.unselectedLabelColor,
              indicatorColor: AppTheme.lightTheme.tabBarTheme.indicatorColor,
              tabs: [
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'receipt_long',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  text: 'Transactions',
                ),
                Tab(
                  icon: CustomIconWidget(
                    iconName: _selectedUserType == 'farmer'
                        ? 'payment'
                        : 'trending_up',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  text: _selectedUserType == 'farmer' ? 'Payments' : 'Earnings',
                ),
                Tab(
                  icon: CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  text: _selectedUserType == 'farmer' ? 'Methods' : 'Payouts',
                ),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionsTab(),
                _buildPaymentsEarningsTab(),
                _buildMethodsPayoutsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    final filteredTransactions = _transactions.where((transaction) {
      if (_selectedUserType == 'farmer') {
        return (transaction["type"] as String) == 'payment';
      } else {
        return (transaction["type"] as String) == 'earning';
      }
    }).toList();

    return Column(
      children: [
        // Filter Options
        Container(
          padding: EdgeInsets.all(4.w),
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'filter_list',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'All Transactions',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'date_range',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'This Month',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Transactions List
        Expanded(
          child: filteredTransactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'receipt_long',
                        color: AppTheme.lightTheme.colorScheme.outline,
                        size: 64,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No transactions found',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    return TransactionCardWidget(
                      transaction: transaction,
                      userType: _selectedUserType,
                      onTap: () => _showTransactionDetails(transaction),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPaymentsEarningsTab() {
    if (_selectedUserType == 'farmer') {
      return _buildPaymentsView();
    } else {
      return _buildEarningsView();
    }
  }

  Widget _buildPaymentsView() {
    final pendingPayments = _transactions
        .where((t) =>
            (t["type"] as String) == 'payment' &&
            (t["status"] as String) == 'pending')
        .toList();

    final totalPending = pendingPayments.fold<double>(
        0.0, (sum, payment) => sum + (payment["amount"] as double));

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pending Payments Summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Pending Payments',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '₹${totalPending.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${pendingPayments.length} payments awaiting processing',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Quick Actions
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: 'add_card',
                  title: 'Add Payment Method',
                  subtitle: 'Add new card or bank',
                  onTap: () => _showAddPaymentMethodDialog(),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionCard(
                  icon: 'schedule_send',
                  title: 'Schedule Payment',
                  subtitle: 'Set up auto-pay',
                  onTap: () => _showSchedulePaymentDialog(),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Payment History Summary
          Text(
            'Payment Summary',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppTheme.lightTheme.colorScheme.outline),
            ),
            child: Column(
              children: [
                _buildSummaryRow('This Month', '₹12,450'),
                Divider(color: AppTheme.lightTheme.colorScheme.outline),
                _buildSummaryRow('Last Month', '₹18,200'),
                Divider(color: AppTheme.lightTheme.colorScheme.outline),
                _buildSummaryRow('Total Paid', '₹156,800'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          Row(
            children: [
              Text(
                'Earnings Overview',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Earnings Chart
          EarningsChartWidget(
            data: _earningsData[_selectedPeriod] ?? [],
            period: _selectedPeriod,
          ),

          SizedBox(height: 3.h),

          // Earnings Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Earnings',
                  value: '₹28,400',
                  icon: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  title: 'This Month',
                  value: '₹8,200',
                  icon: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Jobs Completed',
                  value: '24',
                  icon: 'task_alt',
                  color: AppTheme.getStatusColor('confirmed'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  title: 'Avg per Job',
                  value: '₹1,183',
                  icon: 'calculate',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodsPayoutsTab() {
    if (_selectedUserType == 'farmer') {
      return _buildPaymentMethodsView();
    } else {
      return _buildPayoutsView();
    }
  }

  Widget _buildPaymentMethodsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Methods',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: () => _showAddPaymentMethodDialog(),
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Add New'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _paymentMethods.length,
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              return PaymentMethodCardWidget(
                method: method,
                onTap: () => _showPaymentMethodDetails(method),
                onDelete: () => _deletePaymentMethod(method["id"] as String),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payout Options',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),

          PayoutOptionsWidget(
            availableBalance: 5600.0,
            onInstantPayout: () => _processInstantPayout(),
            onScheduledPayout: () => _scheduleRegularPayout(),
          ),

          SizedBox(height: 3.h),

          Text(
            'Payout History',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),

          // Mock payout history
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final payouts = [
                {
                  "date": DateTime.now().subtract(Duration(days: 7)),
                  "amount": 2400.0,
                  "status": "completed",
                  "method": "Bank Transfer"
                },
                {
                  "date": DateTime.now().subtract(Duration(days: 14)),
                  "amount": 1800.0,
                  "status": "completed",
                  "method": "Instant Transfer"
                },
                {
                  "date": DateTime.now().subtract(Duration(days: 21)),
                  "amount": 3200.0,
                  "status": "completed",
                  "method": "Bank Transfer"
                },
              ];

              final payout = payouts[index];
              return Card(
                margin: EdgeInsets.only(bottom: 2.h),
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.getStatusColor(payout["status"] as String)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'account_balance',
                      color:
                          AppTheme.getStatusColor(payout["status"] as String),
                      size: 24,
                    ),
                  ),
                  title: Text(
                    '₹${(payout["amount"] as double).toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    '${payout["method"]} • ${_formatDate(payout["date"] as DateTime)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  trailing: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.getStatusColor(payout["status"] as String)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (payout["status"] as String).toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color:
                            AppTheme.getStatusColor(payout["status"] as String),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 32,
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Transaction Details',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Transaction ID', transaction["id"] as String),
                      _buildDetailRow(
                          'Job Title', transaction["jobTitle"] as String),
                      _buildDetailRow('Amount',
                          '₹${(transaction["amount"] as double).toStringAsFixed(2)}'),
                      _buildDetailRow(
                          'Date', _formatDate(transaction["date"] as DateTime)),
                      _buildDetailRow('Status',
                          (transaction["status"] as String).toUpperCase()),
                      _buildDetailRow('Payment Method',
                          transaction["paymentMethod"] as String),
                      if (_selectedUserType == 'farmer')
                        _buildDetailRow(
                            'Worker', transaction["workerName"] as String)
                      else
                        _buildDetailRow(
                            'Farmer', transaction["farmerName"] as String),
                      _buildDetailRow(
                          'Location', transaction["farmLocation"] as String),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _downloadReceipt(transaction["id"] as String);
                              },
                              icon: CustomIconWidget(
                                iconName: 'download',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              label: Text('Download Receipt'),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _disputeTransaction(
                                    transaction["id"] as String);
                              },
                              icon: CustomIconWidget(
                                iconName: 'report_problem',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 20,
                              ),
                              label: Text('Dispute'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'credit_card',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Credit/Debit Card'),
              onTap: () {
                Navigator.pop(context);
                _showAddCardDialog();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'account_balance',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Bank Account'),
              onTap: () {
                Navigator.pop(context);
                _showAddBankDialog();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Digital Wallet'),
              onTap: () {
                Navigator.pop(context);
                _showAddWalletDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Credit/Debit Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      hintText: '12/25',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Card added successfully');
            },
            child: Text('Add Card'),
          ),
        ],
      ),
    );
  }

  void _showAddBankDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Bank Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Account Number',
                hintText: '1234567890',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'IFSC Code',
                hintText: 'SBIN0001234',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Account Holder Name',
                hintText: 'John Doe',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bank Name',
                hintText: 'State Bank of India',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Bank account added successfully');
            },
            child: Text('Add Account'),
          ),
        ],
      ),
    );
  }

  void _showAddWalletDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Digital Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Wallet Provider',
              ),
              items: [
                DropdownMenuItem(value: 'paytm', child: Text('Paytm')),
                DropdownMenuItem(value: 'phonepe', child: Text('PhonePe')),
                DropdownMenuItem(value: 'googlepay', child: Text('Google Pay')),
                DropdownMenuItem(value: 'amazonpay', child: Text('Amazon Pay')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: '+91 9876543210',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Wallet added successfully');
            },
            child: Text('Add Wallet'),
          ),
        ],
      ),
    );
  }

  void _showSchedulePaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Auto-Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set up automatic payments for completed jobs',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Payment Schedule',
              ),
              items: [
                DropdownMenuItem(
                    value: 'immediate',
                    child: Text('Immediate (within 1 hour)')),
                DropdownMenuItem(value: 'daily', child: Text('Daily at 6 PM')),
                DropdownMenuItem(
                    value: 'weekly', child: Text('Weekly on Friday')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Default Payment Method',
              ),
              items: _paymentMethods
                  .map((method) => DropdownMenuItem(
                        value: method["id"] as String,
                        child: Text(method["name"] as String),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Auto-payment scheduled successfully');
            },
            child: Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDetails(Map<String, dynamic> method) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              method["name"] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Edit Details'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessMessage('Edit functionality coming soon');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: method["isDefault"] as bool ? 'star' : 'star_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(method["isDefault"] as bool
                  ? 'Default Method'
                  : 'Set as Default'),
              onTap: () {
                Navigator.pop(context);
                if (!(method["isDefault"] as bool)) {
                  _setDefaultPaymentMethod(method["id"] as String);
                }
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Remove Method'),
              onTap: () {
                Navigator.pop(context);
                _deletePaymentMethod(method["id"] as String);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deletePaymentMethod(String methodId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Payment Method'),
        content: Text('Are you sure you want to remove this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _paymentMethods
                    .removeWhere((method) => method["id"] == methodId);
              });
              _showSuccessMessage('Payment method removed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _setDefaultPaymentMethod(String methodId) {
    setState(() {
      for (var method in _paymentMethods) {
        method["isDefault"] = method["id"] == methodId;
      }
    });
    _showSuccessMessage('Default payment method updated');
  }

  void _processInstantPayout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Instant Payout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Process instant payout of ₹5,600?'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Instant transfer fee: ₹25',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage(
                  'Instant payout initiated. You will receive ₹5,575');
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _scheduleRegularPayout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Regular Payout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Schedule automatic payouts to your bank account'),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Payout Frequency',
              ),
              items: [
                DropdownMenuItem(
                    value: 'weekly', child: Text('Weekly (Every Friday)')),
                DropdownMenuItem(
                    value: 'biweekly', child: Text('Bi-weekly (1st & 15th)')),
                DropdownMenuItem(
                    value: 'monthly',
                    child: Text('Monthly (Last working day)')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Minimum Amount',
                hintText: '₹1000',
                helperText: 'Payout only when balance exceeds this amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Regular payout scheduled successfully');
            },
            child: Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _downloadReceipt(String transactionId) {
    _showSuccessMessage('Receipt download started');
  }

  void _disputeTransaction(String transactionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dispute Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Why are you disputing this transaction?'),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Reason',
              ),
              items: [
                DropdownMenuItem(
                    value: 'unauthorized',
                    child: Text('Unauthorized transaction')),
                DropdownMenuItem(
                    value: 'incorrect_amount', child: Text('Incorrect amount')),
                DropdownMenuItem(
                    value: 'service_not_provided',
                    child: Text('Service not provided')),
                DropdownMenuItem(
                    value: 'quality_issues', child: Text('Quality issues')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Additional Details',
                hintText: 'Describe the issue...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage(
                  'Dispute submitted. We will review within 24 hours.');
            },
            child: Text('Submit Dispute'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.getStatusColor('confirmed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
