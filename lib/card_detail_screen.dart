import 'package:flutter/material.dart';

class CardDetailScreen extends StatelessWidget {
  final String cardName;
  final String imageLarge;

  const CardDetailScreen({
    Key? key,
    required this.cardName,
    required this.imageLarge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardName),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Hero(
          tag: imageLarge,
          child: InteractiveViewer(
            child: Image.network(
              imageLarge,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  size: 100,
                  color: Colors.red,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
