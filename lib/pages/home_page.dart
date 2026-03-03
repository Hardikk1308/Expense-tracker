import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../services/token_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String?> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await TokenManager.getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                            'Hello, ${userData['username'] ?? 'Sarah'}!',
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
                  Container(
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
                ],
              ),

              const SizedBox(height: 32),

              // Total Spent Card
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
                            color: AppColors.textOnPrimary.withValues(
                              alpha: 0.9,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.textOnPrimary.withValues(
                              alpha: 0.2,
                            ),
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

                    const SizedBox(height: 10),

                    Text(
                      '\$2,847',
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
                              'Budget: \$3,500',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textOnPrimary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '81.3% used',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textOnPrimary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Remaining: \$653',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textOnPrimary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '9 days left',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textOnPrimary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Progress Bar
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.813,
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

              // Spending by Category
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
                        Text('Spending by Category', style: AppTextStyles.h5),
                        Text(
                          'January 2025',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        // Donut Chart
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CustomPaint(painter: DonutChartPainter()),
                        ),

                        const SizedBox(width: 24),

                        // Category List
                        Expanded(
                          child: Column(
                            children: [
                              _buildCategoryItem(
                                'Food',
                                '\$1150',
                                '40%',
                                AppColors.foodColor,
                              ),
                              _buildCategoryItem(
                                'Transport',
                                '\$680',
                                '24%',
                                AppColors.transportColor,
                              ),
                              _buildCategoryItem(
                                'Bills',
                                '\$520',
                                '18%',
                                AppColors.billsColor,
                              ),
                              _buildCategoryItem(
                                'Shopping',
                                '\$350',
                                '12%',
                                AppColors.shoppingColor,
                              ),
                              _buildCategoryItem(
                                'Others',
                                '\$147',
                                '6%',
                                AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Recent Transactions
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
                        Text('Recent Transactions', style: AppTextStyles.h5),
                        TextButton(
                          onPressed: () {},
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

                    _buildTransactionItem(
                      icon: Icons.local_cafe,
                      iconColor: AppColors.coffeeColor,
                      title: 'Starbucks Coffee',
                      category: 'Food',
                      date: 'Today',
                      amount: '-\$8.75',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required String date,
    required String amount,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
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
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      category,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
