import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../core/services/inventory/inventory_repository.dart';
import '../../core/services/suppliers/supplier_repository.dart';
import '../../core/models/inventory_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final _inventoryRepo = InventoryRepository();
  final _supplierRepo = SupplierRepository();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: 'My Stock'),
            Tab(text: 'Suppliers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          // Inventory list
          StreamBuilder<List<InventoryItem>>(
            stream: _inventoryRepo.itemsForOwner(userId),
            builder: (context, snapshot) {
              final items = snapshot.data ?? [];
              if (items.isEmpty) {
                return Center(
                  child: Text('No items yet', style: theme.textTheme.bodyMedium),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(4.w),
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isLow = item.quantity <= item.threshold;
                  return ListTile(
                    tileColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: theme.colorScheme.outline),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.category} • ${item.quantity} ${item.unit}'),
                    trailing: isLow
                        ? Chip(
                            label: const Text('Low Stock'),
                            backgroundColor: AppTheme.warningLight.withValues(alpha: 0.2),
                          )
                        : null,
                  );
                },
              );
            },
          ),
          // Suppliers list
          StreamBuilder(
            stream: _supplierRepo.listAll(),
            builder: (context, snapshot) {
              final suppliers = (snapshot.data as List?) ?? [];
              if (suppliers.isEmpty) {
                return Center(
                  child: Text('No suppliers available', style: theme.textTheme.bodyMedium),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(4.w),
                itemCount: suppliers.length,
                separatorBuilder: (_, __) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final s = suppliers[index];
                  return ListTile(
                    leading: const Icon(Icons.store_mall_directory),
                    title: Text(s.name),
                    subtitle: Text('${s.category} • ${s.address}\n${s.phone}'),
                    isThreeLine: true,
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, userId),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, String ownerId) {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'kg');
    final thrCtrl = TextEditingController(text: '0');
    String category = 'seeds';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Inventory Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  items: const [
                    DropdownMenuItem(value: 'seeds', child: Text('Seeds')),
                    DropdownMenuItem(value: 'fertilizers', child: Text('Fertilizers')),
                    DropdownMenuItem(value: 'pesticides', child: Text('Pesticides')),
                    DropdownMenuItem(value: 'tools', child: Text('Tools')),
                  ],
                  onChanged: (v) => category = v ?? 'seeds',
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity')),
                TextField(controller: unitCtrl, decoration: const InputDecoration(labelText: 'Unit (kg/L/bags)')),
                TextField(controller: thrCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Low stock threshold')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final item = InventoryItem(
                  id: '',
                  ownerId: ownerId,
                  name: nameCtrl.text.trim(),
                  category: category,
                  quantity: double.tryParse(qtyCtrl.text.trim()) ?? 0,
                  unit: unitCtrl.text.trim(),
                  threshold: double.tryParse(thrCtrl.text.trim()) ?? 0,
                  updatedAt: DateTime.now().toUtc(),
                );
                await _inventoryRepo.upsertItem(item);
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}


