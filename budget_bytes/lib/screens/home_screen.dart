import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/restaurant.dart';
import 'restaurant_details_screen.dart';
import 'ai_meal_finder_screen.dart';
import '../widgets/restaurant_card.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Restaurant> _nearbyRestaurants = [];
  List<Restaurant> _allRestaurants = [];
  double _weeklySpending = 0;
  double _weeklyBudget = 50.0;
  bool _loading = true;

  late final AnimationController _heroCtrl;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;

  String _selectedCuisine = 'All';
  final List<String> _cuisines = [
    'All',
    'American',
    'Mexican',
    'Asian',
    'Pizza',
    'Healthy',
    'Fast Food',
    'Italian',
    'Breakfast',
  ];

  int _navIndex = 0;

  static const _blue = Color(0xFF057EE6);
  static const _red = Color(0xFFBC1823);
  static const _gold = Color(0xFFEEBA2B);
  static const _dark = Color(0xFF111111);
  static const _grey = Color(0xFF888888);
  static const _cardBg = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));

    _loadData();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final nearby = await db.filterRestaurants(maxDistance: 0.5);
    final all = await db.getAllRestaurants();
    final spending = await db.getWeeklySpending(widget.userId);

    if (mounted) {
      setState(() {
        _nearbyRestaurants = nearby;
        _allRestaurants = all;
        _weeklySpending = spending;
        _loading = false;
      });
      _heroCtrl.forward();
    }
  }

  Future<List<Restaurant>> _getFilteredRestaurants() async {
    final db = DatabaseHelper.instance;
    if (_selectedCuisine == 'All') return _allRestaurants;
    return db.filterRestaurants(cuisine: _selectedCuisine);
  }

  String _priceSymbol(int range) => '\$' * range;

  Color _budgetColor() {
    final pct = _weeklySpending / _weeklyBudget;
    if (pct >= 1.0) return _red;
    if (pct >= 0.75) return _gold;
    return _blue;
  }

  /// Cuisine colors
  Color _cuisineAccent(String cuisine) {
    const map = {
      'American': Color(0xFFBC1823),
      'Mexican': Color(0xFFEEBA2B),
      'Asian': Color(0xFF057EE6),
      'Pizza': Color(0xFFE65C00),
      'Healthy': Color(0xFF2E7D32),
      'Fast Food': Color(0xFFEEBA2B),
      'Italian': Color(0xFF8B0000),
      'Breakfast': Color(0xFFE65C00),
    };
    return map[cuisine] ?? _blue;
  }

  /// Emojis
  String _cuisineEmoji(String cuisine) {
    const map = {
      'American': '🍔',
      'Mexican': '🌮',
      'Asian': '🍜',
      'Pizza': '🍕',
      'Healthy': '🥗',
      'Fast Food': '🍟',
      'Italian': '🍝',
      'Breakfast': '🥞',
    };
    return map[cuisine] ?? '🍽️';
  }

  //
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(),
      body: _loading
          ? _buildLoader()
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(child: _buildBudgetBanner()),
                SliverToBoxAdapter(
                  child: _buildSectionLabel('Near You', tag: '↓ 0.5 mi'),
                ),
                SliverToBoxAdapter(child: _buildNearbyCards()),
                SliverToBoxAdapter(child: _buildSectionLabel('Browse by Vibe')),
                SliverToBoxAdapter(child: _buildCuisineChips()),
                SliverToBoxAdapter(child: _buildFilteredList()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
    );
  }

  // app bar
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: _blue,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: FadeTransition(
          opacity: _heroFade,
          child: SlideTransition(
            position: _heroSlide,
            child: Container(
              color: _blue,
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // eyebrow
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: _gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SATURDAY LUNCH',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // headline
                  const Text(
                    'What are\nyou craving?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: Image.asset(
        'assets/images/minibluelogo.png', // Make sure this path matches your folder structure
        height: 40, // Adjust this height to fit your AppBar perfectly
        fit: BoxFit.contain,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.person_outline_rounded,
            color: Colors.white,
            size: 26,
          ),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  //
  Widget _buildBudgetBanner() {
    final remaining = (_weeklyBudget - _weeklySpending).clamp(0, _weeklyBudget);
    final pct = (_weeklySpending / _weeklyBudget).clamp(0.0, 1.0);
    final color = _budgetColor();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _dark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THIS WEEK',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_weeklySpending.toStringAsFixed(2)} spent',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Text(
                  '\$${remaining.toStringAsFixed(2)} left',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Budget: \$${_weeklyBudget.toStringAsFixed(0)}/week',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── section label ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String title, {String? tag}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _dark,
              letterSpacing: -0.4,
            ),
          ),
          if (tag != null) ...[
            const SizedBox(width: 10),
            Text(
              tag,
              style: const TextStyle(
                fontSize: 12,
                color: _blue,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // cards
  Widget _buildNearbyCards() {
    if (_nearbyRestaurants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'No nearby restaurants found.',
          style: TextStyle(color: _grey),
        ),
      );
    }
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _nearbyRestaurants.length,
        itemBuilder: (_, i) => _buildNearbyCard(_nearbyRestaurants[i]),
      ),
    );
  }

  Widget _buildNearbyCard(Restaurant r) {
    final accent = _cuisineAccent(r.cuisineType);
    final emoji = _cuisineEmoji(r.cuisineType);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/restaurant', arguments: r.id),
      child: Container(
        width: 168,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: _dark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 90,
              child: Container(
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 46)),
                ),
              ),
            ),
            // the content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.name,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          _priceSymbol(r.priceRange),
                          style: TextStyle(
                            color: _gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Colors.white38,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${r.distanceFromCampus.toStringAsFixed(1)} mi',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r.cuisineType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  Widget _buildCuisineChips() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cuisines.length,
        itemBuilder: (_, i) {
          final c = _cuisines[i];
          final selected = c == _selectedCuisine;
          return GestureDetector(
            onTap: () async {
              setState(() => _selectedCuisine = c);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? _blue : _cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected ? _blue : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Text(
                c,
                style: TextStyle(
                  color: selected ? Colors.white : _dark,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // filtered list
  Widget _buildFilteredList() {
    return FutureBuilder<List<Restaurant>>(
      future: _getFilteredRestaurants(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: CircularProgressIndicator(color: _blue, strokeWidth: 2),
            ),
          );
        }
        final list = snap.data!;
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No restaurants found.',
                style: TextStyle(color: _grey, fontSize: 15),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: list.length,
          itemBuilder: (_, i) => _buildRestaurantRow(list[i], i),
        );
      },
    );
  }

  Widget _buildRestaurantRow(Restaurant r, int index) {
    final accent = _cuisineAccent(r.cuisineType);
    final emoji = _cuisineEmoji(r.cuisineType);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/restaurant', arguments: r.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
        ),
        child: Row(
          children: [
            // emoji square
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            // text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _dark,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    r.cuisineType,
                    style: TextStyle(
                      fontSize: 12,
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        _priceSymbol(r.priceRange),
                        style: const TextStyle(
                          color: _grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: _grey,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${r.distanceFromCampus.toStringAsFixed(1)} mi',
                        style: const TextStyle(color: _grey, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: _grey,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          r.openHours,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _grey, size: 22),
          ],
        ),
      ),
    );
  }

  // bottom navigation
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          switch (i) {
            case 1:
              Navigator.pushNamed(context, '/budget');
              break;
            case 2:
              Navigator.pushNamed(context, '/saved');
              break;
            case 3:
              Navigator.pushNamed(context, '/ai');
              break;
          }
        },
        selectedItemColor: _blue,
        unselectedItemColor: _grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline_rounded),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome_rounded),
            label: 'AI Pick',
          ),
        ],
      ),
    );
  }

  //loader
  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(color: _blue, strokeWidth: 2.5),
    );
  }
}
