import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isTorchOn = false;
  bool _isProcessing = false;

  void _showInvalidQrError() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('QR inválido para una ubicación de Unimayor'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final scanWindowSize = mediaQuery.size.width * 0.7;
    final scanWindow = Rect.fromCenter(
      center: mediaQuery.size.center(const Offset(0, -80)),
      width: scanWindowSize,
      height: scanWindowSize,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Escáner QR', style: TextStyle(color: colors.onPrimary)),
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: colors.onPrimary,
            ),
            iconSize: 32.0,
            onPressed: () async {
              await cameraController.toggleTorch();
              setState(() => _isTorchOn = !_isTorchOn);
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            color: colors.onPrimary,
            iconSize: 32.0,
            onPressed: () async {
              await cameraController.switchCamera();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            scanWindow: scanWindow,
            onDetect: (capture) async {
              if (_isProcessing) return;

              setState(() {
                _isProcessing = true;
              });

              ScaffoldMessenger.of(context).removeCurrentSnackBar();

              final String? rawValue = capture.barcodes.firstOrNull?.rawValue;

              if (rawValue != null) {
                const String validPrefix =
                    'reportes_unimayor_ubicación_oficial:';

                if (rawValue.startsWith(validPrefix)) {
                  cameraController.stop();
                  final String id = rawValue.substring(validPrefix.length);

                  if (int.tryParse(id) != null && mounted) {
                    context.pop(id);
                  } else {
                    _showInvalidQrError();
                  }
                } else {
                  // FALLO
                  _showInvalidQrError();
                }
              } else {
                setState(() {
                  _isProcessing = false;
                });
              }
            },
          ),
          CustomPaint(painter: QRScannerOverlay(scanWindow: scanWindow)),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: scanWindow.top - 60),
              child: Text(
                'Apunta al código QR',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlay extends CustomPainter {
  final Rect scanWindow;
  final double borderRadius;

  QRScannerOverlay({required this.scanWindow, this.borderRadius = 12.0});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanWindow, Radius.circular(borderRadius)),
      );

    final background = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawPath(background, backgroundPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
