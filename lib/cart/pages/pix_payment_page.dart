import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/companies/companies.dart';

class PixPaymentPage extends StatefulWidget {
  const PixPaymentPage({
    super.key,
    required this.amount,
    required this.saleUuid,
  });

  final double amount;
  final String saleUuid;

  @override
  State<PixPaymentPage> createState() => _PixPaymentPageState();
}

class _PixPaymentPageState extends State<PixPaymentPage> {
  Future<String> generatePixQrCode() async {
    final company = await context.read<CompaniesRepository>().load();

    if (company.pixKey == null || company.pixKey!.isEmpty) {
      return '';
    }

    PixFlutter pixFlutter = PixFlutter(
      payload: Payload(
        pixKey: company.pixKey,
        txid: widget.saleUuid.replaceAll('-', '').substring(0, 24),
        description: '',
        merchantName: '',
        merchantCity: '',
        amount: widget.amount.toStringAsFixed(2),
      ),
    );

    return pixFlutter.getQRCode();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento PIX')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: generatePixQrCode(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ExceptionWidget(exception: snapshot.error);
              }

              if (!snapshot.hasData) {
                return const LoadingWidget();
              }
              final pixCode = snapshot.data!;

              if (pixCode.isEmpty) {
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) => Navigator.of(context).pop(true),
                );
                return const LoadingWidget();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      CurrencyFormatter().formatPtBr(widget.amount),
                      style: textTheme.titleLarge!
                          .copyWith(color: colorScheme.primary),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Center(
                          child: QrImageView(
                            data: pixCode,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Clipboard.setData(ClipboardData(text: pixCode))
                                  .then(
                            (_) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Text('Código PIX copiado'),
                                    Icon(
                                      Icons.check,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          child: const Text('Copiar código PIX'),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Confirmar pagamento'),
                      ),
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
