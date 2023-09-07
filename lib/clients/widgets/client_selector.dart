import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';

import '../models/client.dart';
import '../services/services.dart';

class ClientSelector extends StatelessWidget {
  const ClientSelector({
    super.key,
    required this.clientsRepository,
    required this.onChanged,
    this.initial,
  });

  final ClientsRepository clientsRepository;
  final Client? initial;
  final void Function(Client client) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () {
        showDialog<Client>(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Selecione o cliente'),
              children: [
                FutureBuilder(
                  future: clientsRepository.loadClients(companyUuid: ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorWidget(snapshot.error!);
                    }

                    if (!snapshot.hasData) {
                      return const LoadingWidget();
                    }

                    final clients = snapshot.data!;

                    return Column(
                      children: clients
                          .map(
                            (client) => ListTile(
                              selected: client == initial,
                              title: Text(client.name),
                              onTap: () => Navigator.of(context).pop(client),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            );
          },
        ).then((client) {
          if (client != null) {
            onChanged(client);
          }
        });
      },
      icon: const Icon(Icons.person),
      label: initial == null
          ? const Text('Selecione o cliente')
          : Text(
              initial!.name,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
