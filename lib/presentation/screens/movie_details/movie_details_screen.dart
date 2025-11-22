import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../logic/movies/movies_bloc.dart';
import '../../../logic/movies/movies_event.dart';
import '../../../logic/movies/movies_state.dart';
import '../../../logic/watchlist/watchlist_bloc.dart';
import '../../../logic/watchlist/watchlist_event.dart';
import '../../../logic/watchlist/watchlist_state.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/models/cast_model.dart';
import '../../widgets/movie/movie_card.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(LoadMovieDetails(widget.movieId));
    context.read<WatchlistBloc>().add(CheckWatchlistStatus(widget.movieId));
  }

  Future<void> _launchURL(String query) async {
    final url = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent(query)} watch online');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch browser'),
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }
    }
  }

  void _toggleWatchlist() {
    context.read<WatchlistBloc>().add(ToggleWatchlist(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: BlocListener<WatchlistBloc, WatchlistState>(
        listener: (context, state) {
          if (state is WatchlistUpdated) {
            setState(() {
              isInWatchlist = state.isInWatchlist;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.isInWatchlist
                      ? 'Added to watchlist'
                      : 'Removed from watchlist',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        child: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
            if (state is MoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryYellow,
                ),
              );
            } else if (state is MovieDetailsLoaded) {
              return _buildMovieDetails(
                state.movie,
                state.cast,
                state.images,
                state.similarMovies,
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
      ),
    );
  }

  Widget _buildMovieDetails(
    Movie movie,
    List<Cast> cast,
    List<String> images,
    List<Movie> similarMovies,
  ) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(movie),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieInfo(movie),
              _buildActionButtons(movie),
              _buildStats(movie),
              if (movie.overview != null && movie.overview!.isNotEmpty)
                _buildSection('Description', _buildDescription(movie)),
              if (cast.isNotEmpty) _buildSection('Cast', _buildCast(cast)),
              if (movie.genres != null && movie.genres!.isNotEmpty)
                _buildSection('Genres', _buildGenres(movie)),
              if (images.isNotEmpty)
                _buildSection('Screenshots', _buildScreenshots(images)),
              if (similarMovies.isNotEmpty)
                _buildSection('Similar Movies', _buildSimilarMovies(similarMovies)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(Movie movie) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      actions: [
        BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistUpdated) {
              isInWatchlist = state.isInWatchlist;
            }
            return IconButton(
              icon: Icon(
                isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                color: AppColors.primaryYellow,
              ),
              onPressed: _toggleWatchlist,
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: AppConstants.getBackdropUrl(movie.backdropPath),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.cardBackground,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.cardBackground,
                child: const Icon(
                  Icons.movie_outlined,
                  size: 60,
                  color: AppColors.iconGrey,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primaryBackground.withValues(alpha: 0.8),
                    AppColors.primaryBackground,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (movie.releaseDate != null) ...[
            const SizedBox(height: 8),
            Text(
              'Released: ${movie.releaseDate}',
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () => _launchURL(movie.title),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Watch'),
      ),
    );
  }

  Widget _buildStats(Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildStatItem(
            Icons.favorite,
            movie.favoritesCount?.toString() ?? movie.voteCount.toString(),
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            Icons.access_time,
            movie.runtime != null ? '${movie.runtime} min' : 'N/A',
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            Icons.star,
            movie.voteAverage.toStringAsFixed(1),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryYellow, size: 20),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildDescription(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        movie.overview!,
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildCast(List<Cast> cast) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.cardBackground,
                  backgroundImage: member.profilePath != null
                      ? CachedNetworkImageProvider(
                          AppConstants.getProfileUrl(member.profilePath),
                        )
                      : null,
                  child: member.profilePath == null
                      ? const Icon(
                          Icons.person,
                          color: AppColors.iconGrey,
                        )
                      : null,
                ),
                const SizedBox(height: 8),
                Text(
                  member.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenres(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: movie.genres!.map((genre) {
          return Chip(
            label: Text(genre.name),
            backgroundColor: AppColors.cardBackground,
            labelStyle: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 12,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScreenshots(List<String> images) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: AppConstants.getBackdropUrl(images[index]),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.cardBackground,
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.cardBackground,
                  child: const Icon(Icons.image, color: AppColors.iconGrey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSimilarMovies(List<Movie> movies) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}
