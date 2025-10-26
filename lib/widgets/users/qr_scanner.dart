import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:reportes_unimayor/providers/id_location_qr_scanner.dart';

class QrScanner extends ConsumerStatefulWidget {
  const QrScanner({super.key});

  @override
  ConsumerState<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends ConsumerState<QrScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isTorchOn = false;
  bool _isBackCamera = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Escáner QR', style: TextStyle(color: colors.onPrimary)),
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? colors.tertiary : colors.error,
            ),
            iconSize: 32.0,
            onPressed: () async {
              await cameraController.toggleTorch();
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _isBackCamera ? Icons.camera_rear : Icons.camera_front,
              color: colors.onPrimary,
            ),
            iconSize: 32.0,
            onPressed: () async {
              await cameraController.switchCamera();
              setState(() {
                _isBackCamera = !_isBackCamera;
              });
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          cameraController.stop();

          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              ref
                  .read(idLocationQrScannerProvider.notifier)
                  .setIdLocationQrScanner(barcode.rawValue!);

              // Navegar una vez el valor ha sido seteado
              if (mounted) context.pop();
              break;
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
