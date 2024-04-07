import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sql_helper.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _refreshJournals() async {
    final data = await SqlHelper.getCars();
    logger.i("Number of journals: ${data.length}");
    setState(() {
      _journals = data;
    });
  }

  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _mileageController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _makeController.text = existingJournal['make'];
      _modelController.text = existingJournal['model'];
      _yearController.text = existingJournal['year'].toString();
      _colorController.text = existingJournal['color'];
      _mileageController.text = existingJournal['mileage'].toString();
      _priceController.text = existingJournal['price'].toString();
      _descriptionController.text = existingJournal['description'];
      _imageController.text = existingJournal['image'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _makeController,
                  decoration: const InputDecoration(labelText: 'Make'),
                ),
                TextField(
                  controller: _modelController,
                  decoration: const InputDecoration(labelText: 'Model'),
                ),
                TextField(
                  controller: _yearController,
                  decoration: const InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
                TextField(
                  controller: _mileageController,
                  decoration: const InputDecoration(labelText: 'Mileage'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Image'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _refreshJournals();
                  },
                  child: const Text('Save'),
                ),
              ],
            )));
  } // _showForm  method    end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL Lite'),
      ),
      body: ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_journals[index]['make']),
            subtitle: Text(_journals[index]['model']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showForm(_journals[index]['id']),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    SqlHelper.deleteCar(_journals[index]['id']);
                    _refreshJournals();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
