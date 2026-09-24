import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/book.dart';
import '../reading_list/reading_list_cubit.dart';
import '../reading_list/reading_list_state.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.id});

  final BookId id;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReadingListCubit>().state;
    final book = switch (state) {
      ReadingListLoaded(:final books) =>
        books.where((b) => b.id == id).firstOrNull,
      _ => null,
    };
    return Scaffold(
      appBar: AppBar(title: Text(book?.title ?? 'Book')),
      body: book == null
          ? const Center(child: Text('Book not found'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.author),
                  const SizedBox(height: 16),
                  SegmentedButton<ReadingStatus>(
                    segments: [
                      for (final s in ReadingStatus.values)
                        ButtonSegment(value: s, label: Text(s.name)),
                    ],
                    selected: {book.status},
                    onSelectionChanged: (selection) => context
                        .read<ReadingListCubit>()
                        .setStatus(book.id, selection.first),
                  ),
                ],
              ),
            ),
    );
  }
}
