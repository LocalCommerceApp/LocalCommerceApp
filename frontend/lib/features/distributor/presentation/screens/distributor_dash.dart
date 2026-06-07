import 'package:flutter/material.dart';
import '../../../../core/design_system.dart';
import 'orders_page.dart';
import 'inventory_page.dart';
import 'sales_report_page.dart';

class DistributorDash extends StatelessWidget {
  const DistributorDash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAgencyHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Business Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 15),
                  
                  Row(
                    children: [
                      _buildSummaryCard(context, "Total Items", "150+", Icons.inventory, AppColors.skyBlue),
                      const SizedBox(width: 12),
                      _buildSummaryCard(context, "Order Value", "₹45k", Icons.currency_rupee, AppColors.freshGreen),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(context, "Monthly Sales", "₹1.2L", Icons.bar_chart, AppColors.accent, isFullWidth: true),
                  
                  const SizedBox(height: 30),
                  const Text("Core Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 15),
                  
                  _buildActionTile(context, "Incoming Orders", Icons.assignment_late_outlined, "Manage shopkeeper requests"),
                  _buildActionTile(context, "Update Inventory", Icons.edit_calendar_outlined, "Add/Remove/Update stock rates"),
                  _buildActionTile(context, "Delivery Tracking", Icons.local_shipping_outlined, "Notify shopkeepers on dispatch"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgencyHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xxl),
          bottomRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.only(top: 80, left: 25, right: 25),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.xxl),
              bottomRight: Radius.circular(AppRadius.xxl),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Distributor Dashboard", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Managed Agency View", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color, {bool isFullWidth = false}) {
    Widget card = Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Column(children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]),
    );

    return isFullWidth 
      ? GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DistributorSalesReport())),
          child: card) 
      : Expanded(child: card);
  }

  Widget _buildActionTile(BuildContext context, String title, IconData icon, String sub) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
        onTap: () {
          if (title == "Incoming Orders") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DistributorOrdersPage()));
          } else if (title == "Update Inventory") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DistributorInventoryPage()));
          }
        },
      ),
    );
  }
}
