import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Battle Arena',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFDC0A2D),
          onPrimary: Colors.white,
          secondary: Color(0xFFFFCB05),
        ),
      ),
      home: const BattleScreen(),
    );
  }
}

class PokemonCard {
  final String id;
  final String name;
  final String imageUrl;
  final int hp;

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.hp,
  });
}

class BattleScreen extends StatefulWidget {
  const BattleScreen({Key? key}) : super(key: key);

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with SingleTickerProviderStateMixin {
  PokemonCard? card1;
  PokemonCard? card2;
  bool isLoading = false;
  String? errorMessage;
  int winner = 0;
  final Random random = Random();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _loadBattle();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadBattle() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      card1 = null;
      card2 = null;
      winner = 0;
    });

    try {
      print('Fetching random Pokémon from PokéAPI...');

      // Get 2 random Pokemon IDs (1-898 available in PokeAPI)
      final id1 = random.nextInt(898) + 1;
      final id2 = random.nextInt(898) + 1;

      final List<PokemonCard> fetchedCards = [];

      for (int id in [id1, id2]) {
        final response = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          final pokemonCard = PokemonCard(
            id: data['id'].toString(),
            name: (data['name'] as String).toUpperCase(),
            imageUrl: data['sprites']['other']['official-artwork']
                    ['front_default'] ??
                data['sprites']['front_default'] ??
                '',
            hp: data['stats'][0]
                ['base_stat'], // HP is first stat in stats array
          );

          fetchedCards.add(pokemonCard);
          print('Loaded ${pokemonCard.name} with HP: ${pokemonCard.hp}');
        }
      }

      if (fetchedCards.length == 2) {
        final compWinner = fetchedCards[0].hp > fetchedCards[1].hp
            ? 1
            : (fetchedCards[1].hp > fetchedCards[0].hp ? 2 : 0);

        setState(() {
          card1 = fetchedCards[0];
          card2 = fetchedCards[1];
          winner = compWinner;
          isLoading = false;
          errorMessage = null;
        });

        _animationController.forward(from: 0.0);
      } else {
        throw Exception('Failed to load 2 Pokémon');
      }
    } catch (e) {
      print('Error loading Pokémon: $e');
      setState(() {
        isLoading = false;
        errorMessage =
            'Unable to connect to Pokémon API.\nPlease check your internet connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.catching_pokemon, size: 28),
            SizedBox(width: 8),
            Text('Pokémon Battle Arena'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _buildBattleContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading ? null : _loadBattle,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('NEW BATTLE'),
        backgroundColor:
            isLoading ? Colors.grey : Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBattleContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Pokémon...', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadBattle,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      );
    }

    if (card1 == null || card2 == null) {
      return const Center(
        child: Text('No Pokémon loaded'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (winner != 0)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Colors.white, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          winner == 1
                              ? '${card1!.name} WINS!'
                              : '${card2!.name} WINS!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (winner == 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.handshake, size: 32),
                      SizedBox(width: 12),
                      Text(
                        "IT'S A TIE!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              isWide
                  ? Row(
                      children: [
                        Expanded(child: _buildCardDisplay(card1!, 1)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildCardDisplay(card2!, 2)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildCardDisplay(card1!, 1),
                        const SizedBox(height: 24),
                        _buildCardDisplay(card2!, 2),
                      ],
                    ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardDisplay(PokemonCard card, int cardNumber) {
    final isWinner = winner == cardNumber;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWinner ? Colors.amber : Colors.grey[300]!,
          width: isWinner ? 4 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isWinner
                ? Colors.amber.withOpacity(0.4)
                : Colors.black.withOpacity(0.1),
            blurRadius: isWinner ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (isWinner)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, size: 20, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'WINNER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (isWinner) const SizedBox(height: 12),
              Text(
                card.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (card.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    card.imageUrl,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 64),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isWinner ? Colors.amber[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      'HP: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${card.hp}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isWinner ? Colors.green[700] : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
