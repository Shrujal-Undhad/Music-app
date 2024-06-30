import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/genre_chip_controller.dart';

class GenreChip extends StatelessWidget {
  final String genre;

  GenreChip({
    super.key,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GenreChipProvider>(
      builder: (context, genreChipProvider, child) {
        final isSelected = genreChipProvider.isGenreSelected(genre);

        return GestureDetector(
          onTap: () {
            genreChipProvider.selectGenre(genre);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              genre,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
