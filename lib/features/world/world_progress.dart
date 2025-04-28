import 'package:flutter/material.dart';
import '../../core/theme.dart';

class WorldProgress extends StatelessWidget {
  final int worldLevel;

  const WorldProgress({Key? key, required this.worldLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'World Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressBar(),
            const SizedBox(height: 8),
            _buildLevelIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: worldLevel / 10,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(10, (index) {
        final level = index + 1;
        return Column(
          children: [
            Icon(
              Icons.circle,
              size: 12,
              color: level <= worldLevel ? AppTheme.primaryColor : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              '$level',
              style: TextStyle(
                fontSize: 10,
                color: level <= worldLevel ? AppTheme.primaryColor : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }
} 