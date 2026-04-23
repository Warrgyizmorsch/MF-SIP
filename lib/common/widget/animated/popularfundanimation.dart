import 'package:flutter/material.dart';

class ModernStaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;

  const ModernStaggeredItem({
    super.key, 
    required this.child, 
    required this.index,
  });

  @override
  State<ModernStaggeredItem> createState() => _ModernStaggeredItemState();
}

class _ModernStaggeredItemState extends State<ModernStaggeredItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 500), // Smooth half-second duration
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart), // Premium "slow-down" curve
    );

    // This is the magic! It delays the start based on the item's index in the list
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}