import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swaplio_frontend/core/paginated_response.dart';
import 'package:swaplio_frontend/features/listings/services/listing_service.dart';
import '../../listings/models/listing_model.dart';
import '../../listings/widgets/listing_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Future<PaginatedResponse<ListingModel>> _listingFuture;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _selectedIndex = 0; // bottom nav index

  final List<String> _categories = [
    'All', 'Books', 'Electronics', 'Clothes', 'Sports', 'Other',
  ];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _listingFuture = ListingService().getListings();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      extendBody: true,
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A0F),
                  Color(0xFF0D1117),
                  Color(0xFF0A0E1A),
                ],
              ),
            ),
          ),

          // ── Decorative orbs ──────────────────────────────────
          Positioned(
            top: -100,
            right: -80,
            child: _Orb(size: 320, color: const Color(0xFF6C63FF).withOpacity(0.13)),
          ),
          Positioned(
            top: 280,
            left: -100,
            child: _Orb(size: 240, color: const Color(0xFF00D9F5).withOpacity(0.08)),
          ),

          // ── Main body ────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                slivers: [
                  // ── Header ──────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row: greeting + avatar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Discover',
                                    style: TextStyle(
                                      fontFamily: 'Georgia',
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.8,
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    'Find something to swap today',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                              // Avatar / profile button
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6C63FF), Color(0xFF00D9F5)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C63FF).withOpacity(0.35),
                                      blurRadius: 14,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── Search bar ───────────────────────
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Icon(Icons.search_rounded,
                                        color: Colors.white.withOpacity(0.35),
                                        size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Search listings...',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.3),
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF6C63FF).withOpacity(0.25),
                                      ),
                                      child: const Icon(
                                        Icons.tune_rounded,
                                        color: Color(0xFF9B97FF),
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Category chips ───────────────────
                          SizedBox(
                            height: 36,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _categories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, i) {
                                final selected = _selectedCategory == i;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedCategory = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: selected
                                          ? const LinearGradient(
                                        colors: [
                                          Color(0xFF6C63FF),
                                          Color(0xFF48C6EF),
                                        ],
                                      )
                                          : null,
                                      color: selected
                                          ? null
                                          : Colors.white.withOpacity(0.07),
                                      border: Border.all(
                                        color: selected
                                            ? Colors.transparent
                                            : Colors.white.withOpacity(0.10),
                                      ),
                                      boxShadow: selected
                                          ? [
                                        BoxShadow(
                                          color: const Color(0xFF6C63FF)
                                              .withOpacity(0.3),
                                          blurRadius: 10,
                                        )
                                      ]
                                          : null,
                                    ),
                                    child: Text(
                                      _categories[i],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: selected
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Section title ────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Latest Listings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xFF6C63FF).withOpacity(0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // ── Listings ─────────────────────────────────
                  SliverToBoxAdapter(
                    child: FutureBuilder<PaginatedResponse<ListingModel>>(
                      future: _listingFuture,
                      builder: (context, snapshot) {
                        // Loading
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _LoadingShimmer();
                        }

                        // Error
                        if (snapshot.hasError) {
                          return _ErrorState(error: snapshot.error.toString());
                        }

                        // Empty
                        final listings = snapshot.data!.content;
                        if (listings.isEmpty) {
                          return _EmptyState();
                        }

                        // List
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                          itemCount: listings.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _AnimatedListItem(
                              index: index,
                              child: ListingCard(listing: listings[index]),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Navigation Bar ─────────────────────────────
      bottomNavigationBar: _GlassNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),

      // ── FAB ──────────────────────────────────────────────
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

// ── Glass Bottom Nav ─────────────────────────────────────────────────────────

class _GlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _GlassNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (Icons.favorite_rounded, Icons.favorite_border_rounded, 'Saved'),
      (Icons.swap_horiz_rounded, Icons.swap_horiz_outlined, 'Swaps'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final selected = selectedIndex == i;
                final item = items[i];
                return GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: selected
                          ? const Color(0xFF6C63FF).withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selected ? item.$1 : item.$2,
                          color: selected
                              ? const Color(0xFF9B97FF)
                              : Colors.white.withOpacity(0.35),
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.$3,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected
                                ? const Color(0xFF9B97FF)
                                : Colors.white.withOpacity(0.35),
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated list item wrapper ────────────────────────────────────────────────

class _AnimatedListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedListItem({required this.index, required this.child});

  @override
  State<_AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<_AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(milliseconds: 400 + widget.index * 60),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Stagger each card slightly
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}

// ── Loading shimmer ───────────────────────────────────────────────────────────

class _LoadingShimmer extends StatefulWidget {
  @override
  State<_LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<_LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(
          4,
              (i) => AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.lerp(
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.10),
                  _anim.value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFFF4D6D).withOpacity(0.15),
            ),
            child: const Icon(Icons.wifi_off_rounded,
                color: Color(0xFFFF4D6D), size: 28),
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.25),
                  const Color(0xFF00D9F5).withOpacity(0.15),
                ],
              ),
            ),
            child: Icon(Icons.inbox_rounded,
                color: Colors.white.withOpacity(0.5), size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'No listings yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Be the first to post a listing!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Orb ──────────────────────────────────────────────────────────────────────

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}