import 'dart:io' show File;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:path_provider/path_provider.dart';

class GoalImageCropper extends StatefulWidget {
  final Uint8List imageBytes;
  final String imageName;
  final double aspectRatio;

  const GoalImageCropper({
    super.key,
    required this.imageBytes,
    required this.imageName,
    this.aspectRatio = 390 / 224,
  });

  /// Static helper to crop an existing [XFile]
  static Future<XFile?> cropImage({
    BuildContext? context,
    required XFile imageFile,
    double aspectRatio = 390 / 224,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      if (bytes.isEmpty) return null;

      final ctx = context ?? Get.context;
      if (ctx == null || !ctx.mounted) return null;

      final result = await Navigator.of(ctx).push<XFile?>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => GoalImageCropper(
            imageBytes: bytes,
            imageName: imageFile.name,
            aspectRatio: aspectRatio,
          ),
        ),
      );
      return result;
    } catch (e) {
      debugPrint('Error preparing image for crop: $e');
      return null;
    }
  }

  @override
  State<GoalImageCropper> createState() => _GoalImageCropperState();
}

class _GoalImageCropperState extends State<GoalImageCropper> {
  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transformController =
      TransformationController();
  bool _isProcessing = false;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformController.addListener(() {
      final scale = _transformController.value.getMaxScaleOnAxis();
      if ((scale - _currentScale).abs() > 0.05 && mounted) {
        setState(() => _currentScale = scale);
      }
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Future<void> _applyCrop() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final boundary =
          _cropKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Crop boundary not ready');
      }

      // 2.5x pixel ratio produces crisp high-res image without blurring
      final ui.Image image = await boundary.toImage(pixelRatio: 2.5);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        throw Exception('Failed to encode cropped image');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String baseName = widget.imageName.replaceAll(
        RegExp(r'\.[^.]+$'),
        '',
      );

      String? filePath;
      if (!kIsWeb) {
        try {
          final tempDir = await getTemporaryDirectory();
          final file = File(
            '${tempDir.path}/${baseName}_cropped_$timestamp.png',
          );
          await file.writeAsBytes(pngBytes, flush: true);
          filePath = file.path;
        } catch (err) {
          debugPrint('Could not write cropped image to temp file: $err');
        }
      }

      final croppedXFile = (filePath != null && filePath.isNotEmpty)
          ? XFile(
              filePath,
              bytes: pngBytes,
              name: '${baseName}_cropped_$timestamp.png',
              mimeType: 'image/png',
            )
          : XFile.fromData(
              pngBytes,
              name: '${baseName}_cropped_$timestamp.png',
              mimeType: 'image/png',
            );

      if (mounted) {
        Navigator.of(context).pop(croppedXFile);
      }
    } catch (e) {
      debugPrint('Crop failed: $e');
      if (mounted) {
        CustomSnackbar.error(
          title: 'Crop Failed',
          message: 'Could not crop the selected image. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
    setState(() => _currentScale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double maxCropWidth = (screenSize.width - 32).clamp(240.0, 480.0);
    final double cropWidth = maxCropWidth;
    final double cropHeight = cropWidth / widget.aspectRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        title: const Text(
          'Crop Goal Cover',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : _applyCrop,
            child: _isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Done',
                    style: TextStyle(
                      color: Color(0xFFFFBC50),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              'Pinch to zoom and drag to position cover',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Container(
                  width: cropWidth,
                  height: cropHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFBC50),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: RepaintBoundary(
                      key: _cropKey,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ColoredBox(
                              color: const Color(0xFF1E1E24),
                              child: InteractiveViewer(
                                transformationController: _transformController,
                                minScale: 1.0,
                                maxScale: 4.0,
                                boundaryMargin: EdgeInsets.all(cropWidth * 0.5),
                                child: Image.memory(
                                  widget.imageBytes,
                                  width: cropWidth,
                                  height: cropHeight,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Subtle Rule of Thirds grid
                          IgnorePointer(child: _CropGridOverlay()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom control bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFF121216),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'Reset',
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _resetZoom,
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Zoom Out',
                        icon: const Icon(Icons.zoom_out, color: Colors.white),
                        onPressed: () {
                          final newScale = (_currentScale - 0.25).clamp(
                            1.0,
                            4.0,
                          );
                          _transformController.value = Matrix4.diagonal3Values(
                            newScale,
                            newScale,
                            1.0,
                          );
                          setState(() => _currentScale = newScale);
                        },
                      ),
                      Text(
                        '${(_currentScale * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Zoom In',
                        icon: const Icon(Icons.zoom_in, color: Colors.white),
                        onPressed: () {
                          final newScale = (_currentScale + 0.25).clamp(
                            1.0,
                            4.0,
                          );
                          _transformController.value = Matrix4.diagonal3Values(
                            newScale,
                            newScale,
                            1.0,
                          );
                          setState(() => _currentScale = newScale);
                        },
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: _isProcessing ? null : _applyCrop,
                    icon: const Icon(
                      Icons.check,
                      size: 18,
                      color: Color(0xFFFFBC50),
                    ),
                    label: const Text(
                      'Crop',
                      style: TextStyle(
                        color: Color(0xFFFFBC50),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CropGridOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _CropGridPainter());
  }
}

class _CropGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1.0;

    // Vertical lines
    final double x1 = size.width / 3;
    final double x2 = size.width * 2 / 3;
    canvas.drawLine(Offset(x1, 0), Offset(x1, size.height), paint);
    canvas.drawLine(Offset(x2, 0), Offset(x2, size.height), paint);

    // Horizontal lines
    final double y1 = size.height / 3;
    final double y2 = size.height * 2 / 3;
    canvas.drawLine(Offset(0, y1), Offset(size.width, y1), paint);
    canvas.drawLine(Offset(0, y2), Offset(size.width, y2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
