import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '•',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        sector,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // RIGHT SIDE
            Text(
              '${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // DIVIDER
        Divider(
          color: Colors.grey.shade200,
          height: 1,
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
