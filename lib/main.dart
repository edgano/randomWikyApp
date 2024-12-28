import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'wikipedia_service.dart';

void main() {
  runApp(const RandomWikipediaApp());
}

class RandomWikipediaApp extends StatelessWidget {
  const RandomWikipediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Wikipedia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const RandomArticleScreen(),
    );
  }
}

class RandomArticleScreen extends StatefulWidget {
  const RandomArticleScreen({super.key});

  @override
  RandomArticleScreenState createState() => RandomArticleScreenState();
}

class RandomArticleScreenState extends State<RandomArticleScreen> {
  final WikipediaService _wikipediaService = WikipediaService();
  Map<String, dynamic>? _article;
  bool _isLoading = false;

  Future<void> _loadRandomArticle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final article = await _wikipediaService.fetchRandomArticle();
      if (mounted) {
        setState(() {
          _article = article;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _shareArticle(String title, String url) {
    Share.share('Check out this article: $title\n$url');
  }

  @override
  void initState() {
    super.initState();
    _loadRandomArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Wikipedia Article'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('About'),
                    content: const Text('Random Wikipedia is a simple app that fetches random Wikipedia articles.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Exit App'),
                    content: const Text('Are you sure you want to exit?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Exit'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _article != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_article!['thumbnail'] != null && _article!['thumbnail']['source'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    _article!['thumbnail']['source'],
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                _article!['title'] ?? 'No title',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _article!['extract'] ?? 'No content available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 60), // Add padding to bottom of content
            ],
          ),
        ),
      )
          : const Center(child: Text('No article available')),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              onPressed: _loadRandomArticle,
              icon: const Icon(Icons.refresh),
              label: const Text('Next Article'),
              backgroundColor: Colors.blueAccent,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                final title = _article?['title'] ?? 'Unknown';
                final url = _article?['content_urls']?['desktop']?['page'];
                if (url != null) _shareArticle(title, url);
              },
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
