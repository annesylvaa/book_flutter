import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 69, 79, 191),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String searchQuery = '';
  int itemCount = 0;

  void _buscarLivros() async {
    final url = Uri.https(
      'www.googleapis.com',
      'books/v1/volumes',
      {'q': searchQuery},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        itemCount = jsonResponse['totalItems'];
      });
      print('Number of books about $searchQuery: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 195, 195), // Cor de fundo alterada aqui
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                searchQuery = value;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _buscarLivros,
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar'),
            ),
            const SizedBox(height: 16),
            Text(
              'Foram encontrados $itemCount livros sobre $searchQuery:',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> operacaoAssincrona() async {
  print('Inicio do evento assíncrono');
  await Future.delayed(Duration(seconds: 2));
  print('Fim do evento assíncrono');
}
