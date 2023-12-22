class FlowFilter {
  const FlowFilter({this.searchTerm});

  final String? searchTerm;

  FlowFilter copyWith({
    String? searchTerm,
  }) {
    return FlowFilter(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
