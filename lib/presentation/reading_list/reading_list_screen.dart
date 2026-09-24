import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'reading_list_cubit.dart';
import 'reading_list_state.dart';

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reading list')),
      body: BlocBuilder<ReadingListCubit, ReadingListState>(
        builder: (context, state) => switch (state) {
          ReadingListInitial() || ReadingListLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ReadingListError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                TextButton(
                  onPressed: context.read<ReadingListCubit>().load,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          ReadingListLoaded(:final books) => ListView(
            children: [
              for (final book in books)
                ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.author} · ${book.status.name}'),
                  onTap: () => context.go('/books/${book.id.value}'),
                ),
            ],
          ),
        },
      ),
    );
  }
}
