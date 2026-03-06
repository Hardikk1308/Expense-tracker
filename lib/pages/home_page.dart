import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../services/token_manager.dart';
import '../services/dashboard_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String?> userData = {};
  DashboardData? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserData();
    await _loadDashboardData();
  }

  Future<void> _loadUserData() async {
    final data = await TokenManager.getUserData();
    setState(() {
      userData = data;
    });
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      isLoading = true;
    });

    final result = await DashboardService.getDashboardData();
    
    if (result['success']) {
      setState(() {
        dashboardData = DashboardData.fromJson(result['data']);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      
      // Check if login is required
      if (result['requiresLogin'] == true) {
        // Clear any stored data and redirect to login
        await TokenManager.clearAll();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to load dashboard data'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting and add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hello, ${userData['username'] ?? 'User'}!',
                              style: AppTextStyles.h3,
                            ),
                            const SizedBox(width: 8),
                            const Text('👋', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Track your expenses wisely',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to add expense (will be handled by bottom nav)
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.textOnPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Loading or Dashboard Content
                if (isLoading)
                  _buildLoadingCard()
                else if (dashboardData != null)
                  ..._buildDashboardContent()
                else
                  _buildErrorCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.all(AppSpacing.sectionPadding),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.sectionPadding),
      decoration: BoxDecoration(
        color: AppColors.errorWithOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load dashboard data',
            style: AppTextStyles.h6.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDashboardContent() {
    return [
      // Total Spent Card with real data
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.sectionPadding),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Spent This Month',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              '\$${dashboardData!.totalExpense.toStringAsFixed(2)}',
              style: AppTextStyles.amountLarge.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 36,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget: \$${dashboardData!.budget.toStringAsFixed(0)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dashboardData!.usedPercentage.toStringAsFixed(1)}% used',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Remaining: \$${dashboardData!.remaining.toStringAsFixed(0)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dashboardData!.daysLeft} days left',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress Bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.textOnPrimary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (dashboardData!.usedPercentage / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      const SizedBox(height: 32),
      
      // Recent Transactions with real data
      if (dashboardData!.recentTransactions.isNotEmpty) ...[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: AppTextStyles.h5,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all transactions
                    },
                    child: Text(
                      'View All',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              ...dashboardData!.recentTransactions.map((transaction) {
                return _buildTransactionItemFromData(transaction);
              }).toList(),
            ],
          ),
        ),
      ],
    ];
  }

  Widget _buildCategoryItem(
    String name,
    String amount,
    String percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: AppTextStyles.bodyMedium)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                percentage,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItemFromData(RecentTransaction transaction) {
    IconData icon;
    Color iconColor;
    
    // Map categories to icons and colors
    switch (transaction.category.toLowerCase()) {
      case 'food':
      case 'food & dining':
        icon = Icons.restaurant;
        iconColor = AppColors.foodColor;
        break;
      case 'transport':
      case 'transportation':
      case 'trip':
        icon = Icons.directions_car;
        iconColor = AppColors.transportColor;
        break;
      case 'bills':
      case 'bills & utilities':
        icon = Icons.receipt;
        iconColor = AppColors.billsColor;
        break;
      case 'shopping':
        icon = Icons.shopping_bag;
        iconColor = AppColors.shoppingColor;
        break;
      case 'healthcare':
        icon = Icons.local_hospital;
        iconColor = AppColors.healthcareColor;
        break;
      case 'entertainment':
        icon = Icons.movie;
        iconColor = AppColors.entertainmentColor;
        break;
      case 'coffee':
      case 'coffee & drinks':
        icon = Icons.local_cafe;
        iconColor = AppColors.coffeeColor;
        break;
      case 'gym':
      case 'fitness':
        icon = Icons.fitness_center;
        iconColor = AppColors.gymColor;
        break;
      case 'pet':
      case 'pets':
        icon = Icons.pets;
        iconColor = AppColors.petColor;
        break;
      default:
        icon = Icons.attach_money;
        iconColor = AppColors.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description?.isNotEmpty == true 
                      ? transaction.description! 
                      : _getCategoryDisplayName(transaction.category),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _getCategoryDisplayName(transaction.category),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      transaction.formattedDate,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            transaction.formattedAmount,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'Food';
      case 'food & dining':
        return 'Food & Dining';
      case 'transport':
        return 'Transport';
      case 'transportation':
        return 'Transportation';
      case 'trip':
        return 'Trip';
      case 'bills':
        return 'Bills';
      case 'bills & utilities':
        return 'Bills & Utilities';
      case 'shopping':
        return 'Shopping';
      case 'healthcare':
        return 'Healthcare';
      case 'entertainment':
        return 'Entertainment';
      case 'coffee':
        return 'Coffee';
      case 'coffee & drinks':
        return 'Coffee & Drinks';
      case 'gym':
        return 'Gym';
      case 'fitness':
        return 'Fitness';
      case 'pet':
        return 'Pet';
      case 'pets':
        return 'Pets';
      default:
        return category.split(' ').map((word) => 
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
        ).join(' ');
    }
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 16.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background circle
    paint.color = AppColors.borderLight;
    canvas.drawCircle(center, radius - strokeWidth / 2, paint);

    // Data segments
    final segments = [
      {'percentage': 0.40, 'color': AppColors.foodColor},
      {'percentage': 0.24, 'color': AppColors.transportColor},
      {'percentage': 0.18, 'color': AppColors.billsColor},
      {'percentage': 0.12, 'color': AppColors.shoppingColor},
      {'percentage': 0.06, 'color': AppColors.textSecondary},
    ];

    double startAngle = -90 * (3.14159 / 180); // Start from top

    for (final segment in segments) {
      final sweepAngle = (segment['percentage'] as double) * 2 * 3.14159;
      paint.color = segment['color'] as Color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
