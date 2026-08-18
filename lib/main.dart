import 'package:flutter/material.dart';

void main() {
  runApp(const FlamesApp());
}

class FlamesApp extends StatelessWidget {
  const FlamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F L A M E S',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const FlamesHomePage(),
    );
  }
}

class FlamesHomePage extends StatefulWidget {
  const FlamesHomePage({super.key});

  @override
  State<FlamesHomePage> createState() => _FlamesHomePageState();
}

class _FlamesHomePageState extends State<FlamesHomePage> {
  final TextEditingController _yourNameController = TextEditingController();
  final TextEditingController _crushNameController = TextEditingController();

  String _resultText = '';
  String _resultDescription = '';
  IconData _resultIcon = Icons.favorite_border;

  // FLAMES Categories Mapping
  final Map<String, Map<String, dynamic>> _flamesMap = {
    'F': {
      'title': 'Friends',
      'description': 'Best friends forever! A strong connection built on trust.',
      'icon': Icons.people,
    },
    'L': {
      'title': 'Lovers',
      'description': 'Love is in the air! Sparks are flying between you two.',
      'icon': Icons.favorite,
    },
    'A': {
      'title': 'Affection',
      'description': 'There is deep affection and care between both of you.',
      'icon': Icons.sentiment_satisfied_alt,
    },
    'M': {
      'title': 'Marriage',
      'description': 'Wedding bells! You are destined to spend your lives together.',
      'icon': Icons.diamond,
    },
    'E': {
      'title': 'Enemies',
      'description': 'Uh oh! Watch out, there might be some rivalry here.',
      'icon': Icons.bolt,
    },
    'S': {
      'title': 'Siblings',
      'description': 'A pure family-like bond! Brotherly/Sisterly love.',
      'icon': Icons.family_restroom,
    },
  };

  void _calculateFlames() {
    FocusScope.of(context).unfocus(); // Close keyboard

    String name1 = _yourNameController.text.toLowerCase().replaceAll(' ', '');
    String name2 = _crushNameController.text.toLowerCase().replaceAll(' ', '');

    if (name1.isEmpty || name2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both names!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Convert string to list of characters for manipulation
    List<String> list1 = name1.split('');
    List<String> list2 = name2.split('');

    // Remove matching letters
    for (int i = 0; i < list1.length; i++) {
      for (int j = 0; j < list2.length; j++) {
        if (list1[i] == list2[j] && list1[i] != '') {
          list1[i] = '';
          list2[j] = '';
          break;
        }
      }
    }

    // Count remaining non-empty letters
    int count = list1.where((c) => c.isNotEmpty).length +
        list2.where((c) => c.isNotEmpty).length;

    if (count == 0) {
      setState(() {
        _resultText = 'Perfect Match!';
        _resultDescription = 'Your names cancel out completely! Deep connection!';
        _resultIcon = Icons.stars;
      });
      return;
    }

    // FLAMES Elimination Logic
    List<String> flames = ['F', 'L', 'A', 'M', 'E', 'S'];
    int index = 0;

    while (flames.length > 1) {
      index = (index + count - 1) % flames.length;
      flames.removeAt(index);
    }

    String finalLetter = flames.first;
    var outcome = _flamesMap[finalLetter]!;

    setState(() {
      _resultText = outcome['title'];
      _resultDescription = outcome['description'];
      _resultIcon = outcome['icon'];
    });
  }

  void _reset() {
    _yourNameController.clear();
    _crushNameController.clear();
    setState(() {
      _resultText = '';
      _resultDescription = '';
      _resultIcon = Icons.favorite_border;
    });
  }

  @override
  void dispose() {
    _yourNameController.dispose();
    _crushNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('F L A M E S'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    size: 80,
                    color: Colors.pinkAccent,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Test Your Compatibility!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Name 1 Input
                  TextField(
                    controller: _yourNameController,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name 2 Input
                  TextField(
                    controller: _crushNameController,
                    decoration: InputDecoration(
                      labelText: "Crush's Name",
                      prefixIcon: const Icon(Icons.favorite),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _calculateFlames,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Calculate', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.outlined(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Reset',
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Result Display Card
                  if (_resultText.isNotEmpty)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.pink.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Icon(
                              _resultIcon,
                              size: 60,
                              color: Colors.pinkAccent,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _resultText,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _resultDescription,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            color: Colors.grey.shade100,
            width: double.infinity,
            child: Text(
              'Developed by SynTech @ 2026',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}