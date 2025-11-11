import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'db_helper.dart';
import 'web_db_helper.dart';
import 'services/api_service.dart';
import 'card_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon TCG Collection',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFDC0A2D), // Pokémon Red
          onPrimary: Colors.white,
          secondary: Color(0xFFFFCB05), // Pokémon Yellow
          background: Color(0xFFF0F8FF), // Alice Blue
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F8FF),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFFDC0A2D),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFDC0A2D), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      home: const CardListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CardListScreen extends StatefulWidget {
  const CardListScreen({Key? key}) : super(key: key);

  @override
  State<CardListScreen> createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  late final dynamic _dbHelper;
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _cards = [];
  List<Map<String, dynamic>> _filteredCards = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use web-compatible database helper for web, SQLite for mobile
    _dbHelper = kIsWeb ? WebDatabaseHelper() : DatabaseHelper();
    _loadCards();
    _searchController.addListener(_filterCards);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCards() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredCards = List.from(_cards);
      } else {
        _filteredCards = _cards.where((card) {
          final name = (card['name'] ?? '').toString().toLowerCase();
          final query = _searchController.text.toLowerCase();
          return name.contains(query);
        }).toList();
      }
      // Sort alphabetically by name
      _filteredCards.sort((a, b) {
        final nameA = (a['name'] ?? '').toString().toLowerCase();
        final nameB = (b['name'] ?? '').toString().toLowerCase();
        return nameA.compareTo(nameB);
      });
    });
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Starting to load cards...');

      // Check if database has cards
      int count = await _dbHelper.getCardCount();
      print('Current card count in DB: $count');

      if (count == 0) {
        print('No cards found, fetching from API...');
        // Fetch from API and store in DB
        await _apiService.fetchAndStoreCards();
        print('Cards fetched and stored successfully');
      }

      // Load cards from database
      List<Map<String, dynamic>> cards = await _dbHelper.getCards();
      print('Loaded ${cards.length} cards from database');

      setState(() {
        _cards = cards;
        _filteredCards = List.from(cards);
        _isLoading = false;
      });

      // Sort alphabetically after loading
      _filterCards();
    } catch (e, stackTrace) {
      print('Error loading cards: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Error loading cards: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCards() async {
    try {
      await _dbHelper.deleteAllCards();
      await _loadCards();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error refreshing cards: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F4FD), Color(0xFFB3D9F2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // App Bar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pokémon Collection',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.white),
                        onPressed: _isLoading ? null : _refreshCards,
                        tooltip: 'Refresh Cards',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            Container(
              color: const Color(0xFFF0F8FF),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '🔍 Search Pokémon by name...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFDC0A2D)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFDC0A2D),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            // Body Content
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pokéball-like loading spinner
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFDC0A2D)),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFDC0A2D), width: 3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Loading Pokémon cards...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadCards,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC0A2D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_cards.isEmpty) {
      return const Center(
        child: Text(
          'No cards found',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Results count with modern styling
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredCards.length} Pokémon',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC0A2D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _filteredCards.length == _cards.length ? 'All' : 'Filtered',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card List
          _filteredCards.isEmpty
              ? Container(
                  height: 200,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No cards match your search',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _filteredCards.length,
                  itemBuilder: (context, index) {
                    final card = _filteredCards[index];
                    return _buildModernCardTile(card);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildModernCardTile(Map<String, dynamic> card) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(16),
              shadowColor: Colors.black26,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardDetailScreen(
                        cardName: card['name'] ?? 'Unknown Card',
                        imageLarge:
                            card['imageLarge'] ?? card['imageSmall'] ?? '',
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: isMobile
                      ? _buildMobileLayout(card)
                      : _buildDesktopLayout(card),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(Map<String, dynamic> card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image on top for mobile
        if (card['imageSmall'] != null && card['imageSmall'].isNotEmpty)
          Hero(
            tag: card['imageLarge'] ?? card['imageSmall'],
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                card['imageSmall'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card['name'] ?? 'Unknown Card',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCB05).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFCB05),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'ID: ${card['id']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Color(0xFFDC0A2D),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(Map<String, dynamic> card) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Image on left for desktop
          if (card['imageSmall'] != null && card['imageSmall'].isNotEmpty)
            Hero(
              tag: card['imageLarge'] ?? card['imageSmall'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  card['imageSmall'],
                  width: 80,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            )
          else
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image_not_supported,
                size: 40,
                color: Colors.grey,
              ),
            ),
          const SizedBox(width: 20),
          // Card info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card['name'] ?? 'Unknown Card',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCB05).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFCB05),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'ID: ${card['id']}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
            color: Color(0xFFDC0A2D),
          ),
        ],
      ),
    );
  }
}
