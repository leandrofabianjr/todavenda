import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';

import '../models/client.dart';
import '../services/services.dart';

class ClientSelector extends StatefulWidget {
  const ClientSelector({
    super.key,
    required this.clientsRepository,
    required this.onChanged,
    this.initial,
  });

  final ClientsRepository clientsRepository;
  final Client? initial;
  final void Function(Client? client) onChanged;

  @override
  State<ClientSelector> createState() => _ClientSelectorState();
}

class _ClientSelectorState extends State<ClientSelector> {
  Client? client;

  @override
  void initState() {
    client = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () => showDialog<Client>(
        context: context,
        builder: (context) {
          return ClientSelectorDialog(
            clientsRepository: widget.clientsRepository,
            selectedClient: client,
            onChanged: (value) {
              widget.onChanged(value);
              setState(() => client = value);
            },
          );
        },
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.person),
          const SizedBox(width: 8),
          client == null
              ? const Text('Selecione o cliente')
              : Text(
                  client!.name,
                  overflow: TextOverflow.ellipsis,
                )
        ],
      ),
    );
  }
}

class ClientSelectorDialog extends StatefulWidget {
  const ClientSelectorDialog({
    super.key,
    required this.clientsRepository,
    this.selectedClient,
    required this.onChanged,
  });

  final ClientsRepository clientsRepository;
  final Client? selectedClient;
  final void Function(Client? client) onChanged;

  @override
  State<ClientSelectorDialog> createState() => _ClientSelectorDialogState();
}

class _ClientSelectorDialogState extends State<ClientSelectorDialog> {
  final searchTextController = TextEditingController();
  Client? selectedClient;
  bool searching = false;
  Timer? _debounce;

  @override
  void initState() {
    selectedClient = widget.selectedClient;
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged(String term) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => setState(() {}),
    );
  }

  Future<List<Client>> getClients() {
    final term = searchTextController.text;
    if (searching && term.isNotEmpty) {
      return widget.clientsRepository.searchClients(term: term);
    }
    return widget.clientsRepository.loadClients();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: searching
          ? TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                label: const Text('Pesquise pelo cliente'),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => searching = false),
                  icon: const Icon(Icons.close),
                ),
              ),
              keyboardType: TextInputType.name,
              onChanged: _onSearchChanged,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selecione o cliente'),
                IconButton(
                  onPressed: () => setState(() => searching = true),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
      content: FutureBuilder(
        future: getClients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if (!snapshot.hasData) {
            return const LoadingWidget();
          }

          final clients = snapshot.data!;

          if (clients.isEmpty) {
            return const Text(
              'Não há clientes cadastrados',
              textAlign: TextAlign.center,
            );
          }

          return Column(
            children: clients
                .map(
                  (client) => ListTile(
                    selected: client == selectedClient,
                    title: Text(client.name),
                    onTap: () {
                      widget.onChanged(client);
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            widget.onChanged(null);
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.delete),
          label: const Text('Remover'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
