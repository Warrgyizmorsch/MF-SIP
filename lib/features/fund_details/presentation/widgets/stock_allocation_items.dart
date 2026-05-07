import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class StockAllocationItem extends StatelessWidget {
  final String name;
  final String category;
  final String sector;
  final double percentage;

  const StockAllocationItem({
    super.key,
    required this.name,
    required this.category,
    required this.sector,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 16 : 12,
            horizontal: isDesktop ? 8 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT SIDE - Stock Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: isDesktop ? 15 : 14,
                        fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 6 : 4),
                    Row(
                      children: [
                        // Category Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 10 : 8,
                            vertical: isDesktop ? 4 : 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: isDesktop ? 12 : 11,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: isDesktop ? 10 : 8),
                        // Separator
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: isDesktop ? 10 : 8),
                        // Sector
                        Expanded(
                          child: Text(
                            sector,
                            style: TextStyle(
                              fontSize: isDesktop ? 13 : 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: isDesktop ? 20 : 12),

              // RIGHT SIDE - Percentage
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 12 : 10,
                  vertical: isDesktop ? 8 : 6,
                ),
                decoration: BoxDecoration(
                  color: percentage >= 5
                      ? Colors.green.shade50
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: percentage >= 5
                        ? Colors.green.shade200
                        : Colors.grey.shade200,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: isDesktop ? 15 : 14,
                    fontWeight: FontWeight.w700,
                    color: percentage >= 5
                        ? Colors.green.shade700
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // DIVIDER
        Divider(
          color: isDesktop ? Colors.grey.shade100 : Colors.grey.shade200,
          height: 1,
          thickness: isDesktop ? 1 : 0.5,
          indent: isDesktop ? 8 : 0,
          endIndent: isDesktop ? 8 : 0,
        ),
      ],
    );
  }
}