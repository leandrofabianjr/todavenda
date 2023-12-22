import 'dart:async';

import 'package:flutter/material.dart';

class AppBarWithSearchView extends StatefulWidget {
  const AppBarWithSearchView({
    super.key,
    required this.onSearchChanged,
    this.initialSearchTerm,
    required this.title,
    this.actions,
    this.bottom,
  });

  final void Function(String? term) onSearchChanged;
  final String? initialSearchTerm;
  final Widget title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  State<AppBarWithSearchView> createState() => _AppBarWithSearchViewState();
}

class _AppBarWithSearchViewState extends State<AppBarWithSearchView> {
  late TextEditingController searchTextController;
  final searchFieldFocusNode = FocusNode();
  Timer? _debounce;
  bool showSearchField = false;

  @override
  void initState() {
    showSearchField = widget.initialSearchTerm?.isNotEmpty == true;
    searchTextController =
        TextEditingController(text: widget.initialSearchTerm);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  _onSearchChanged(String term) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => widget.onSearchChanged(term),
    );
  }

  _clearSearch() {
    searchTextController.clear();
    _onSearchChanged('');
  }

  bool get searchIsEmpty => searchTextController.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    if (showSearchField) {
      return AppBar(
        leading: IconButton(
          onPressed: () => setState(() => showSearchField = false),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          controller: searchTextController,
          focusNode: searchFieldFocusNode,
          decoration: InputDecoration(
            label: const Text('Pesquisar'),
            suffixIcon: searchIsEmpty
                ? null
                : IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.backspace),
                  ),
          ),
          keyboardType: TextInputType.name,
          onChanged: _onSearchChanged,
        ),
      );
    }
    return AppBar(
      title: widget.title,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() => showSearchField = true);
            searchFieldFocusNode.requestFocus();
          },
        ),
        ...(widget.actions ?? []),
      ],
      bottom: widget.bottom,
    );
  }
}
