import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/queue_conrtoller.dart';

class QueueList extends StatelessWidget {
  const QueueList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QueueProvider>(
      builder: (context, queueProvider, child) {
        final queue = queueProvider.queue;
        return ListView.builder(
          itemCount: queue.length,
          itemBuilder: (context, index) {
            final song = queue[index];
            return ListTile(
              title: Text(song.name),
              subtitle: Text(song.artist),
              trailing: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  queueProvider.removeFromQueue(song);
                },
              ),
            );
          },
        );
      },
    );
  }
}
