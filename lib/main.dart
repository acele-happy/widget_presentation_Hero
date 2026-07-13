import 'package:flutter/material.dart';

void main() => runApp(const HeroDemoApp());

class HeroDemoApp extends StatelessWidget {
  const HeroDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Widget Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const GalleryScreen(),
    );
  }
}

// Different flight animation styles, one per tile, so the audience can
// see that Hero is not limited to the default rectangle-morph effect.
enum HeroStyle { defaultMorph, rotate, scaleBounce, fadeThrough }

// Simple data model for our demo items
class ArtItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final HeroStyle style;

  const ArtItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.style,
  });
}

final List<ArtItem> items = [
  const ArtItem(
    title: '',
    subtitle: 'Default Hero morph',
    color: Colors.deepOrange,
    icon: Icons.wb_sunny,
    style: HeroStyle.defaultMorph,
  ),
  const ArtItem(
    title: 'Ocean',
    subtitle: 'Rotates while flying',
    color: Colors.blue,
    icon: Icons.water,
    style: HeroStyle.rotate,
  ),
  const ArtItem(
    title: 'Forest',
    subtitle: 'Scale bounce effect',
    color: Colors.green,
    icon: Icons.forest,
    style: HeroStyle.scaleBounce,
  ),
  const ArtItem(
    title: 'Lavender',
    subtitle: 'Fade-through crossfade',
    color: Colors.deepPurple,
    icon: Icons.spa,
    style: HeroStyle.fadeThrough,
  ),
];

Widget _buildFlightShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
  ArtItem item,
) {
  final Widget destinationWidget = toHeroContext.widget;

  switch (item.style) {
    case HeroStyle.rotate:
      return RotationTransition(
        turns: Tween<double>(begin: 0, end: 1).animate(animation),
        child: destinationWidget,
      );

    case HeroStyle.scaleBounce:
      return ScaleTransition(
        scale: Tween<double>(begin: 0.6, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        ),
        child: destinationWidget,
      );

    case HeroStyle.fadeThrough:
      return FadeTransition(
        opacity: animation,
        child: destinationWidget,
      );

    case HeroStyle.defaultMorph:
      return destinationWidget;
  }
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Widget Demo')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailScreen(item: item),
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: 'item-${item.title}', // must match the tag on Screen 2
                    flightShuttleBuilder: (context, animation, direction, fromCtx, toCtx) =>
                        _buildFlightShuttle(context, animation, direction, fromCtx, toCtx, item),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Icon(item.icon, size: 48, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.style.name,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------- SCREEN 2: Detail view ----------
class DetailScreen extends StatelessWidget {
  final ArtItem item;
  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: 'item-${item.title}', // same tag as Screen 1
              flightShuttleBuilder: (context, animation, direction, fromCtx, toCtx) =>
                  _buildFlightShuttle(context, animation, direction, fromCtx, toCtx, item),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(item.icon, size: 100, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(item.subtitle, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}