import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/html_utils.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/info_chip.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../watchlist/bloc/watchlist_bloc.dart';
import '../../../watchlist/bloc/watchlist_event.dart';
import '../../../watchlist/bloc/watchlist_state.dart';
import '../../../watchlist/data/models/watchlist_show.dart';
import '../../bloc/show_details_bloc.dart';
import '../../bloc/show_details_event.dart';
import '../../bloc/show_details_state.dart';
import '../../data/models/cast_member.dart';
import '../../data/models/episode.dart';
import '../../data/repositories/details_repository.dart';

class ShowDetailsScreen extends StatelessWidget {
  final int showId;

  const ShowDetailsScreen({super.key, required this.showId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowDetailsBloc(context.read<DetailsRepository>())
        ..add(FetchShowDetailsEvent(showId)),
      child: _ShowDetailsView(showId: showId),
    );
  }
}

class _ShowDetailsView extends StatefulWidget {
  final int showId;
  const _ShowDetailsView({required this.showId});

  @override
  State<_ShowDetailsView> createState() => _ShowDetailsViewState();
}

class _ShowDetailsViewState extends State<_ShowDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedSeason = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShowDetailsBloc, ShowDetailsState>(
        builder: (context, state) {
          if (state is ShowDetailsLoading || state is ShowDetailsInitial) {
            return _buildLoadingShimmer(context);
          } else if (state is ShowDetailsError) {
            return Scaffold(
              appBar: AppBar(),
              body: ErrorView(
                message: state.message,
                onRetry: () => context
                    .read<ShowDetailsBloc>()
                    .add(FetchShowDetailsEvent(widget.showId)),
              ),
            );
          } else if (state is ShowDetailsLoaded) {
            final show = state.show;
            final seasons = state.episodesBySeason.keys.toList();
            if (!seasons.contains(_selectedSeason) && seasons.isNotEmpty) {
              _selectedSeason = seasons.first;
            }

            return BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, watchlistState) {
                final isInWatchlist = watchlistState is WatchlistLoaded &&
                    watchlistState.contains(show.id);

                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 320,
                        pinned: true,
                        leading: IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        actions: [
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isInWatchlist
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: isInWatchlist
                                    ? AppColors.primaryLight
                                    : Colors.white,
                                size: 20,
                              ),
                            ),
                            onPressed: () {
                              context.read<WatchlistBloc>().add(
                                    ToggleWatchlistEvent(
                                      WatchlistShow.fromShow(show),
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              AppNetworkImage(
                                imageUrl: show.backdropUrl ?? show.posterUrl,
                                width: double.infinity,
                                height: double.infinity,
                                radius: 0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.3),
                                      Colors.transparent,
                                      AppColors.background.withValues(alpha: 0.8),
                                      AppColors.background,
                                    ],
                                    stops: const [0.0, 0.3, 0.75, 1.0],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                show.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  if (show.rating != null)
                                    RatingBadge(rating: show.rating),
                                  if (show.yearsLabel.isNotEmpty)
                                    InfoChip(label: show.yearsLabel),
                                  if (show.status != null)
                                    InfoChip(
                                      label: show.status!,
                                      color: show.status == 'Ended'
                                          ? AppColors.onSurfaceVariant
                                          : AppColors.success,
                                    ),
                                  if (show.network != null)
                                    InfoChip(label: show.network!),
                                ],
                              ),
                              if (show.genres.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: show.genres
                                      .map((g) => InfoChip(
                                            label: g,
                                            color: AppColors.primary,
                                          ))
                                      .toList(),
                                ),
                              ],
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<WatchlistBloc>().add(
                                          ToggleWatchlistEvent(
                                            WatchlistShow.fromShow(show),
                                          ),
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isInWatchlist
                                        ? AppColors.surfaceVariant
                                        : AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: isInWatchlist
                                            ? AppColors.primaryLight
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    isInWatchlist
                                        ? Icons.check_circle_rounded
                                        : Icons.bookmark_add_outlined,
                                    size: 20,
                                    color: isInWatchlist
                                        ? AppColors.primaryLight
                                        : Colors.white,
                                  ),
                                  label: Text(
                                    isInWatchlist
                                        ? 'In Watchlist'
                                        : 'Add to Watchlist',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(
                          TabBar(
                            controller: _tabController,
                            indicatorColor: AppColors.primaryLight,
                            indicatorWeight: 3,
                            labelColor: AppColors.onBackground,
                            unselectedLabelColor: AppColors.onSurfaceVariant,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            tabs: const [
                              Tab(text: 'Overview'),
                              Tab(text: 'Episodes'),
                              Tab(text: 'Cast'),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(show.summary, show),
                      _buildEpisodesTab(state.episodesBySeason, seasons),
                      _buildCastTab(state.cast),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOverviewTab(String? summary, dynamic show) {
    final cleanSummary = stripHtml(summary);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Synopsis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            cleanSummary.isNotEmpty
                ? cleanSummary
                : 'No synopsis available for this show.',
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                _buildInfoRow('Network', show.network ?? 'N/A'),
                const Divider(height: 20),
                _buildInfoRow('Language', show.language ?? 'English'),
                const Divider(height: 20),
                _buildInfoRow('Status', show.status ?? 'Unknown'),
                const Divider(height: 20),
                _buildInfoRow('Runtime', '${show.averageRuntime ?? 60} mins'),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodesTab(
      Map<int, List<Episode>> episodesBySeason, List<int> seasons) {
    if (seasons.isEmpty) {
      return const Center(
        child: Text(
          'No episode information available.',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    final currentEpisodes = episodesBySeason[_selectedSeason] ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Season:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedSeason,
                  dropdownColor: AppColors.surfaceVariant,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primaryLight),
                  items: seasons.map((season) {
                    final count = episodesBySeason[season]?.length ?? 0;
                    return DropdownMenuItem<int>(
                      value: season,
                      child: Text(
                        'Season $season ($count episodes)',
                        style: const TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (season) {
                    if (season != null) {
                      setState(() => _selectedSeason = season);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...currentEpisodes.map((ep) => _buildEpisodeTile(ep)),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildEpisodeTile(Episode ep) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AppNetworkImage(
              imageUrl: ep.imageUrl,
              width: 90,
              height: 55,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'E${ep.number.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ep.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                if (ep.airdate != null && ep.airdate!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Aired: ${ep.airdate}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
                if (ep.summary != null && ep.summary!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    stripHtml(ep.summary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastTab(List<CastMember> cast) {
    if (cast.isEmpty) {
      return const Center(
        child: Text(
          'No cast information available.',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cast.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final member = cast[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              ClipOval(
                child: AppNetworkImage(
                  imageUrl: member.personImageUrl,
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.personName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'as ${member.characterName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: double.infinity, height: 200, radius: 12),
            const SizedBox(height: 16),
            const ShimmerBox(width: 200, height: 26),
            const SizedBox(height: 12),
            Row(
              children: const [
                ShimmerBox(width: 60, height: 24, radius: 12),
                SizedBox(width: 8),
                ShimmerBox(width: 80, height: 24, radius: 12),
                SizedBox(width: 8),
                ShimmerBox(width: 70, height: 24, radius: 12),
              ],
            ),
            const SizedBox(height: 20),
            const ShimmerBox(width: double.infinity, height: 46, radius: 12),
            const SizedBox(height: 24),
            const ShimmerBox(width: 120, height: 20),
            const SizedBox(height: 8),
            const ShimmerBox(width: double.infinity, height: 80),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
