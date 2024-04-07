import 'package:flutter/material.dart';
import 'sql_helper.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Add a key parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQL Lite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _refreshJournals() async {
    final data = await SqlHelper.getCars();
    logger
        .i("Number of journals: ${data.length}"); // Logging the number of items
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL Lite'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) {
                final journal = _journals[index];
                return ListTile(
                  title: Text(journal['make'] + ' ' + journal['model']),
                  subtitle: Text(journal['description']),
                );
              },
            ),
    );
  }
}
