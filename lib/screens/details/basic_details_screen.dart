part of '../details_screen.dart';

class _BasicDetailsScreen extends StatelessWidget {

  const _BasicDetailsScreen({required this.qris,});

  @override
  Widget build(BuildContext context) {

    final amount = qris.originalTransactionAmount;
    final tipIndicator = qris.tipIndicator;

    final domesticMerchants = qris.domesticMerchants;
    final merchant51 = qris.merchantAccountDomestic;
    final merchants = [
      ...domesticMerchants,
      merchant51,
    ].where((merchant) => merchant != null,).toList();

    return Column(
      children: [
        QrImageView(
          size: (AppConstants.designScreenSize.width * 0.75).w,
          data: qris.toString(),
        ),
        Text(
          qris.merchantName ?? 'Unknown Merchant',
          textAlign: TextAlign.center,
        ),
        Text(
          qris.merchantCity ?? 'Unknown Location',
          textAlign: TextAlign.center,
        ),
        if (amount != null)
          Text(
            amount.toCurrencyFormat(),
            textAlign: TextAlign.center,
          ),
        Builder(
          builder: (_) {
            switch (tipIndicator) {
              case null:
                break;
              case TipIndicator.mobileAppRequiresConfirmation:
                return const Text(
                  'Tip Applicable',
                  textAlign: TextAlign.center,
                );
              case TipIndicator.tipValueFixed:
                final value = qris.tipValueOfFixed;
                if (value != null) {
                  return Text(
                    'Fixed Tip Amount: ${value.toCurrencyFormat()}',
                    textAlign: TextAlign.center,
                  );
                }
                break;
              case TipIndicator.tipValuePercentage:
                final pct = qris.tipValueOfPercentage;
                if (pct != null && pct > 0) {
                  return Text(
                    'Tip Percentage based on Transaction Amount: $pct%',
                    textAlign: TextAlign.center,
                  );
                }
                break;
            }
            return const SizedBox.shrink();
          },
        ),
        const Text('Merchants:', textAlign: TextAlign.center,),
        for (final merchant in merchants)
          Text(
            ' >> ${merchant!.globallyUniqueIdentifier}',
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  final QRIS qris;
}