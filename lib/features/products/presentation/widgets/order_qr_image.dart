import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/network/dio_client.dart';

/// Fetches and displays the QR payment image from the backend.
///
/// Endpoint: POST /api/v1/orders/qr-image
/// Body: { "qr": "<khqr_string>", "md5": "<md5_of_qr>" }
/// Response: PNG image bytes
class OrderQrImage extends StatefulWidget {
  /// The KHQR payment string returned by the backend when the order was created.
  final String qrString;
  final double size;

  const OrderQrImage({
    Key? key,
    required this.qrString,
    this.size = 220,
  }) : super(key: key);

  @override
  State<OrderQrImage> createState() => _OrderQrImageState();
}

class _OrderQrImageState extends State<OrderQrImage> {
  late final Future<Uint8List> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchQrImage();
  }

  /// Computes MD5 of the KHQR string — same as backend expects.
  String _md5Of(String input) {
    final bytes = utf8.encode(input);
    return md5.convert(bytes).toString();
  }

  Future<Uint8List> _fetchQrImage() async {
    final qrStr = widget.qrString;
    final md5Hash = _md5Of(qrStr);

    final response = await DioClient.dio.post<Uint8List>(
      '/api/v1/payments/qr-image',
      data: {'qr': qrStr, 'md5': md5Hash},
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.data == null || response.data!.isEmpty) {
      throw Exception('Empty QR image response from server');
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _future,
      builder: (context, snap) {
        // Loading
        if (snap.connectionState != ConnectionState.done) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
            ),
          );
        }

        // Error
        if (snap.hasError || !snap.hasData) {
          debugPrint('QR image error: ${snap.error}');
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2,
                    size: widget.size * 0.4, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'QR could not load',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        // Success — display PNG
        return Image.memory(
          snap.data!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
        );
      },
    );
  }
}
