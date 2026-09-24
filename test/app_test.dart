import 'package:flutter_test/flutter_test.dart';
import 'package:vsdd_testdrive/app.dart';
import 'package:vsdd_testdrive/domain/book.dart';

import 'reading_list_cubit_test.dart' show FakeBookRepository;

void main() {
  testWidgets('shows the reading list and opens a book', (tester) async {
    final repo = FakeBookRepository(const [
      Book(id: BookId('1'), title: 'Refactoring', author: 'Fowler'),
    ]);
    await tester.pumpWidget(ReadingListApp(repository: repo));
    await tester.pumpAndSettle();

    expect(find.text('Refactoring'), findsOneWidget);

    await tester.tap(find.text('Refactoring'));
    await tester.pumpAndSettle();

    expect(find.text('Fowler'), findsOneWidget);
  });
}
