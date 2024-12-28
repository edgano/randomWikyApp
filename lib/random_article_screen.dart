import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'language_provider.dart';
import 'wikipedia_service.dart';

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
      final language = Provider.of<LanguageProvider>(context, listen: false).language;
      final article = await _wikipediaService.fetchRandomArticle(language);
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
    final translations = Provider.of<LanguageProvider>(context).translations;

    return Scaffold(
      appBar: AppBar(
        title: Text(translations['title']!),
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
              leading: const Icon(Icons.language),
              title: Text(translations['change_language']!),
              onTap: () async {
                String selectedLanguage = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Select Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('English'),
                          onTap: () => Navigator.pop(context, 'en'),
                        ),
                        ListTile(
                          title: const Text('Español'),
                          onTap: () => Navigator.pop(context, 'es'),
                        ),
                      ],
                    ),
                  ),
                ) ?? 'en'; // Default to 'en' if no selection
                Provider.of<LanguageProvider>(context, listen: false).changeLanguage(selectedLanguage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(translations['about']!),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(translations['about']!),
                    content : Text(translations['about_info']!),
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
              title: Text(translations['exit']!),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(translations['exit']!),
                    content: Text(translations['exit_text']!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(translations['cancel']!),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          SystemNavigator.pop(); // Exit the app
                        },
                        child: Text(translations['exit']!),
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
              if (_article!['thumbnail'] != null &&
                  _article!['thumbnail']['source'] != null)
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      )
          : const Center(child: Text('No article available')),
      floatingActionButton: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton.extended(
                onPressed: _loadRandomArticle,
                icon: const Icon(Icons.refresh),
                label: Text(translations['next_article']!),
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
                label: Text(translations['share']!),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
