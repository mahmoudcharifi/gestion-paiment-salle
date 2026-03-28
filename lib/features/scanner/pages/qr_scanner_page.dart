import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/member_repository.dart';
import '../../members/pages/member_details_page.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  final MemberRepository _memberRepository = MemberRepository();

  bool _isProcessing = false;
  bool _torchEnabled = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final rawValue = barcode?.rawValue;

    if (rawValue == null || rawValue.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    await _scannerController.stop();

    final member = await _memberRepository.getMemberByQrCode(rawValue.trim());

    if (!mounted) return;

    if (member == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun adhérent trouvé pour ce QR code'),
        ),
      );

      setState(() {
        _isProcessing = false;
      });

      await _scannerController.start();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemberDetailsPage(item: member),
      ),
    );

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    await _scannerController.start();
  }

  Future<void> _toggleTorch() async {
    await _scannerController.toggleTorch();
    if (!mounted) return;

    setState(() {
      _torchEnabled = !_torchEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR'),
        actions: [
          IconButton(
            onPressed: _toggleTorch,
            icon: Icon(
              _torchEnabled ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleDetection,
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.20),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Scanne le QR code de l’adhérent',
                        style: AppTextStyles.cardTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _isProcessing
                            ? 'Recherche du profil en cours...'
                            : 'Place le QR code à l’intérieur du cadre.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}