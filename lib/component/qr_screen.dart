import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrButton extends StatelessWidget {
  final String data;
  final double size;

  const QrButton({Key? key, required this.data, this.size = 250}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: data,
      version: QrVersions.auto,
      size: size.h,
    );
  }
}
