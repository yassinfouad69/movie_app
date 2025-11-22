import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../logic/movies/movies_bloc.dart';
import '../../../logic/movies/movies_event.dart';
import '../../../logic/movies/movies_state.dart';
import '../../../data/models/genre_model.dart';
import '../../widgets/movie/movie_grid_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<Genre> genres = [];
  Genre? selectedGenre;

  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(LoadGenres());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: BlocListener<MoviesBloc, MoviesState>(
          listener: (context, state) {
            if (state is GenresLoaded) {
              setState(() {
                genres = state.genres;
                if (genres.isNotEmpty) {
                  selectedGenre = genres.first;
                  context.read<MoviesBloc>().add(
                        LoadMoviesByGenre(genreId: selectedGenre!.id),
                      );
                }
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Browse',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (genres.isNotEmpty) _buildGenreChips(),
              Expanded(child: _buildMoviesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = selectedGenre?.id == genre.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(genre.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedGenre = genre;
                });
                context.read<MoviesBloc>().add(
                      LoadMoviesByGenre(genreId: genre.id),
                    );
              },
              backgroundColor: AppColors.cardBackground,
              selectedColor: AppColors.primaryYellow,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primaryBackground
                    : AppColors.textWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoviesList() {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is MoviesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryYellow),
          );
        } else if (state is MoviesByGenreLoaded) {
          final movies = state.movies;
          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies found in this category',
                style: TextStyle(color: AppColors.textGrey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.6,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieGridCard(movie: movies[index]);
            },
          );
        } else if (state is MoviesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.textWhite),
            ),
          );
        }

        return const Center(
          child: Text(
            'Select a category to browse movies',
            style: TextStyle(color: AppColors.textGrey),
          ),
        );
      },
    );
  }
}
