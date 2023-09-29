import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qris_analyzer/models/cached_code.dart';
import 'package:qris_analyzer/screens/routes.dart';
import 'package:qris_analyzer/utils/date_ext.dart';

class CodeEntry extends StatelessWidget {

  const CodeEntry({
    super.key,
    required this.code,
    this.favoriteLookup = const {},
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {

    final isFavorite = favoriteLookup[code] ?? false;

    return Card(
      elevation: 8,
      child: RPadding(
        padding: const EdgeInsets.all(16,),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _zoomQrCode(context, code.data,);
              },
              child: QrImageView(
                data: code.data,
                size: 176.w,
              ),
            ),
            const RSizedBox(width: 12,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(code.merchantName ?? 'Unnamed Merchant',),
                  const RSizedBox(height: 8,),
                  Text(
                    'Created at: ${code.createdAt.toDateFormat()}',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context,).pushNamed(
                        AppRoutes.details,
                        arguments: code,
                      );
                    },
                    child: const Text('Details',),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                onFavorite?.call(code,);
              },
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _zoomQrCode(BuildContext context, String data,) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          child: RPadding(
            padding: const EdgeInsets.all(24.0,),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    icon: const Icon(Icons.close,),
                    onPressed: () {
                      Navigator.of(_,).pop();
                    },
                  ),
                ),
                QrImageView(
                  data: data,
                  size: MediaQuery.of(context,).size.width * 0.75,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final CachedCode code;
  final Map<CachedCode, bool> favoriteLookup;
  final ValueChanged<CachedCode>? onFavorite;
}