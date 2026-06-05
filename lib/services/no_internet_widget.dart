import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import '../core/utils/constant/text_style.dart';
import 'network_services.dart';

class NoInternetWidget extends StatefulWidget {
  final Widget child;

  const NoInternetWidget({
    super.key,
    required this.child,
  });

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget>
    with SingleTickerProviderStateMixin {
  bool _hasInternet = true;
  bool _isRetrying = false;

  StreamSubscription<bool>? _subscription;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _initNetwork();
  }

  Future<void> _initNetwork() async {
    _hasInternet = await NetworkService.instance.hasInternet();

    if (mounted) {
      setState(() {});
    }

    _subscription =
        NetworkService.instance.onNetworkChanged.listen((isConnected) {
          if (mounted) {
            setState(() {
              _hasInternet = isConnected;
            });
          }
        });
  }

  Future<void> _retryConnection() async {
    setState(() {
      _isRetrying = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final isConnected = await NetworkService.instance.hasInternet();

    if (mounted) {
      setState(() {
        _hasInternet = isConnected;
        _isRetrying = false;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildPulseWifi() {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) {
              return Transform.scale(
                scale: 1 + (_pulseController.value * .5),
                child: Opacity(
                  opacity: 1 - _pulseController.value,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:Ucolors.primary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Ucolors.primary.withAlpha(0x08),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color:Ucolors.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        if (!_hasInternet)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: Container(
                  color: Colors.black.withOpacity(.35),
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutBack,
                      tween: Tween(begin: .8, end: 1),
                      builder: (_, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.12),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildPulseWifi(),

                            const SizedBox(height: 20),

                            const Text(
                              "No Internet Connection",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: FontFamily.medium,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Please check your internet connection and try again.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: FontFamily.medium,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed:
                                _isRetrying ? null : _retryConnection,
                                icon: _isRetrying
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Icon(Icons.refresh),
                                label: Text(
                                  _isRetrying
                                      ? "Checking..."
                                      : "Retry",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontFamily.medium,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Ucolors.primary ,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}