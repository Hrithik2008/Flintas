import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class WorldAnimations extends StatelessWidget {
  final int worldLevel;

  const WorldAnimations({Key? key, required this.worldLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Base landscape
          _buildBaseLandscape(),
          // Trees (appear at level 1)
          if (worldLevel >= 1) _buildTrees(),
          // River (appears at level 2)
          if (worldLevel >= 2) _buildRiver(),
          // Flowers (appear at level 3)
          if (worldLevel >= 3) _buildFlowers(),
          // Mountains (appear at level 4)
          if (worldLevel >= 4) _buildMountains(),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildBaseLandscape() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor.withOpacity(0.3),
            AppTheme.secondaryColor,
          ],
        ),
      ),
    );
  }

  Widget _buildTrees() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return Container(
            width: 40,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(20),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: 2.seconds,
            curve: Curves.easeInOut,
          );
        }),
      ),
    );
  }

  Widget _buildRiver() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(),
      ).shimmer(
        duration: 2.seconds,
        color: Colors.blue[100]!,
      ),
    );
  }

  Widget _buildFlowers() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              shape: BoxShape.circle,
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 1.seconds,
            curve: Curves.easeInOut,
          );
        }),
      ),
    );
  }

  Widget _buildMountains() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(2, (index) {
          return Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).fade(
            duration: 3.seconds,
            curve: Curves.easeInOut,
          );
        }),
      ),
    );
  }
} 