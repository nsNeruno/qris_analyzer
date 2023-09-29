part of '../details_screen.dart';

class _TechnicalDetailsScreen extends StatelessWidget {

  const _TechnicalDetailsScreen({required this.qris,});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8,),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ExpansionTile(
              title: const Text('View Raw Data',),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RPadding(
                        padding: const EdgeInsets.all(32.0,),
                        child: Text(qris.toString(),),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: qris.toString(),),
                        );
                      },
                      icon: const Icon(Icons.copy,),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const RSizedBox(height: 48,),
          Table(
            columnWidths: {
              0: FixedColumnWidth(96.w,),
              1: const FlexColumnWidth(),
            },
            border: TableBorder.all(),
            children: [
              const TableRow(
                children: [
                  RPadding(
                    padding: EdgeInsets.all(8.0,),
                    child: Text('Tag',),
                  ),
                  RPadding(
                    padding: EdgeInsets.all(8.0,),
                    child: Text('Content/Value',),
                  ),
                ],
              ),
              ...qris.entries.map(
                (e) => _QRISEntry(
                  tag: e.key,
                  value: e.value,
                  description: _QRISEntryDescription(qris: qris, tag: e.key,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final QRIS qris;
}

class _QRISEntry extends TableRow {

  _QRISEntry({
    required int tag,
    required String value,
    Widget? description,
  }): super(
    children: [
      RPadding(
        padding: const EdgeInsets.all(8.0,),
        child: Text(
          tag.toString().padLeft(2, '0',),
        ),
      ),
      RPadding(
        padding: const EdgeInsets.all(8.0,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold,),
            ),
            if (description != null)
              description,
          ],
        ),
      ),
    ],
  );
}

class _QRISEntryDescription extends StatelessWidget {
  
  const _QRISEntryDescription({
    required this.qris, required this.tag,
  });
  
  @override
  Widget build(BuildContext context) {

    Widget? description;
    switch (tag) {
      case 0:
        description = const Text(
          'Payload Format Indicator. Valid QRIS should have exact value of "01"',
        );
        break;
      case 1:
        description = const Text(
          ' • 11: Static Code (usually physical, found on most merchants as '
            'printed code\n • 12: Dynamic Code, which is usually auto generated '
            'from Merchant Payment System',
        );
        break;
      case 51:
        final merchant51 = qris.merchantAccountDomestic;
        if (merchant51 != null) {
          final data = <String, String?>{
            'Global Identifier': merchant51.globallyUniqueIdentifier,
            'Merchant ID': merchant51[1] ?? merchant51[2],
            'Merchant PAN': merchant51.panCode,
            'Institution Code': merchant51.institutionCode,
            'National Numbering System (NNS) Digits': merchant51.nationalNumberingSystemDigits,
            'Check Digit': merchant51.checkDigit?.toString(),
            'Check Digit Considered Valid (Mod 10 only)': merchant51.isValidCheckDigit(
              useDeduction: false,
            ).toString(),
            'Check Digit Considered Valid (Mod 10 + Deduction)': merchant51.isValidCheckDigit(
              useDeduction: true,
            ).toString(),
            'Merchant Criteria': '${merchant51[3]} (${describeEnum(merchant51.merchantCriteria,)})',
          };
          description = Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Merchant Data:',
                ),
                ...data.entries.map(
                  (e) => [
                    TextSpan(
                      text: '\n • ${e.key}: ',
                    ),
                    TextSpan(
                      text: '${e.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold,),
                    ),
                  ],
                ).expand((spans) => spans,),
              ],
            ),
          );
        }
        break;
      case 52:
        description = Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Merchant Category Code\nSee ',
              ),
              TextSpan(
                text: 'here',
                recognizer: TapGestureRecognizer()..onTap = () {
                  launchUrlString(
                    'https://github.com/greggles/mcc-codes/](https://github.com/greggles/mcc-codes/',
                  );
                },
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        );
        break;
      case 53:
        description = Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Currency Code. Defaults to ',
              ),
              const TextSpan(
                text: '360',
                style: TextStyle(fontWeight: FontWeight.bold,),
              ),
              const TextSpan(
                text: ' for IDR.\nSee more about ISO 4217 Currency Code ',
              ),
              TextSpan(
                text: 'here',
                recognizer: TapGestureRecognizer()..onTap = () {
                  launchUrlString('https://en.wikipedia.org/wiki/ISO_4217',);
                },
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        );
        break;
      case 54:
        description = const Text(
          'Fixed Transaction Amount specified by the merchant, if available, '
            'usually on Dynamic Codes',
        );
        break;
      case 55:
        description = const Text(
          'Tip Indicator. If this field exists, indicates there is a necessity '
            'to show a Tip Input/Value to the Customer.\n'
            ' • 01: The App should show a field to allow Customer to specify a '
            'manual, fixed Tip Amount to the Merchant. This is optional.\n'
            ' • 02: There is a fixed Tip Amount specified by the Merchant and '
            'this amount is required to be paid by the Customer. The value '
            'should be seen on tag 56.\n'
            ' • 03: There is a specific percentage value where the Tip Amount '
            'is equal to the `value` percent of the Transaction Amount. This is '
            'required to be paid by the Customer. Percentage value should be '
            'seen at tag 57',
        );
        break;
      case 56:
        description = const Text(
          'Fixed Tip Amount. Added to the Transaction Amount and must be paid '
            'by the Customer',
        );
        break;
      case 57:
        description = const Text(
          'Percentage Tip Amount. Added to the Transaction Amount where value '
            'is `value` / 100 x (Transaction Amount). Required to be paid.',
        );
        break;
      case 58:
        description = const Text(
          'Country Code where this Code is generated. Should default to ID. '
            'Based on ISO 3166-1 Standard.',
        );
        break;
      case 59:
        description = const Text('Merchant Name',);
        break;
      case 60:
        description = const Text('Merchant City',);
        break;
      case 61:
        description = const Text('Merchant ZIP Postal Code',);
        break;
      case 62:
        final additionalData = qris.additionalDataField;
        final info = <String, String?>{
          if (additionalData?.billNumber != null)
            'Bill Number': additionalData?.billNumber,
          if (additionalData?.mobileNumber != null)
            'Mobile Number': additionalData?.mobileNumber,
          if (additionalData?.storeLabel != null)
            'Store Label': additionalData?.storeLabel,
          if (additionalData?.loyaltyNumber != null)
            'Loyalty Number': additionalData?.loyaltyNumber,
          if (additionalData?.referenceLabel != null)
            'Reference Label': additionalData?.referenceLabel,
          if (additionalData?.customerLabel != null)
            'Customer Label': additionalData?.customerLabel,
          if (additionalData?.terminalLabel != null)
            'Terminal Label': additionalData?.terminalLabel,
          if (additionalData?.purposeOfTransaction != null)
            'Purpose of Transaction': additionalData?.purposeOfTransaction,
        };
        description = Text(
          'Additional Info:\n${info.entries.map((e) => '• ${e.key}: ${e.value}',).join('\n',)}',
        );
        break;
      case 63:
        description = const Text('CRC Checksum of The QRIS in Hexadecimal',);
        break;
      default:
        if (tag >= 26 && tag <= 50) {
          try {
            final merchant = qris.getMerchantOnTag(tag,);
            if (merchant != null) {
              final data = <String, String?>{
                'Global Identifier': merchant.globallyUniqueIdentifier,
                'Merchant ID': merchant[1] ?? merchant[2],
                'Merchant PAN': merchant.panCode,
                'Institution Code': merchant.institutionCode,
                'National Numbering System (NNS) Digits': merchant
                    .nationalNumberingSystemDigits,
                'Check Digit': merchant.checkDigit?.toString(),
                'Check Digit Considered Valid (Mod 10 only)': merchant.isValidCheckDigit(
                  useDeduction: false,
                ).toString(),
                'Check Digit Considered Valid (Mod 10 + Deduction)': merchant.isValidCheckDigit(
                  useDeduction: true,
                ).toString(),
                'Merchant Criteria': '${merchant[3]} (${describeEnum(
                  merchant.merchantCriteria,)})',
              };
              description = Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Merchant Data:',
                    ),
                    ...data.entries.map(
                      (e) => [
                        TextSpan(
                          text: '\n • ${e.key}: ',
                        ),
                        TextSpan(
                          text: '${e.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                      ],
                    ).expand((spans) => spans,),
                  ],
                ),
              );
            }
          } catch (_) {
            debugErrorLog(
              _,
              name: '$runtimeType.merchant.error.tag.$tag',
            );
          }
        }
        break;
    }

    if (description != null) {
      return RPadding(
        padding: const EdgeInsets.only(top: 16,),
        child: description,
      );
    }
    return const SizedBox.shrink();
  }
  
  final QRIS qris;
  final int tag;
}