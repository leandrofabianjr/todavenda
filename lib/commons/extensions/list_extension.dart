import 'package:todavenda/commons/commons.dart';

extension ListExtension<T> on List<T> {
  List<T> filterKeyByTerm({
    required String Function(T obj) key,
    required String term,
  }) {
    final filteredTerm = term.withoutDiacriticalMarks;
    final containsTerm = where(
      (obj) => key(obj).withoutDiacriticalMarks.contains(
            RegExp(filteredTerm, caseSensitive: false),
          ),
    ).toList();
    final startsWith = containsTerm
        .where(
          (obj) => key(obj).withoutDiacriticalMarks.startsWith(
                RegExp('^$filteredTerm', caseSensitive: false),
              ),
        )
        .toList();
    containsTerm.removeWhere((e) => startsWith.contains(e));
    return [...startsWith, ...containsTerm];
  }
}
