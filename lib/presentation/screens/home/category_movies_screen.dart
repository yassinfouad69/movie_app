import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../logic/movies/movies_bloc.dart';
import '../../../logic/movies/movies_event.dart';
import '../../../logic/movies/movies_state.dart';
import '../../../data/models/genre_model.dart';
import '../../widgets/movie/movie_grid_card.dart';

class CategoryMoviesScreen extends StatefulWidget {
  final Genre genre;

  const CategoryMoviesScreen({super.key, required this.genre});

  @override
  State<CategoryMoviesScreen> createState() => _CategoryMoviesScreenState();
}

class _CategoryMoviesScreenState extends State<CategoryMoviesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(LoadMoviesByGenre(genreId: widget.genre.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text('${widget.genre.name} Movies'),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryYellow),
            );
          } else if (state is MoviesByGenreLoaded) {
            final movies = state.movies;
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
          return const SizedBox();
        },
      ),
    );
  }
}
