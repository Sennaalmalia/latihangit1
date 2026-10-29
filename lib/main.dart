import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nekoma Coffee',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 117, 82, 70),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 170, 158, 162),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToNavigateToHome();
  }

  _goToNavigateToHome() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/image/kucing.gif', width: 200, height: 200),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> foodlist = [
    'Espresso',
    'Americano',
    'Matcha Latte',
    'Chocolate Frappe',
    'Strawberry Smoothie',
  ];

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Willkommen bei Nekoma Coffee'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cari Minuman',
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: ListView(
              children: foodlist
                  .where((food) => food.toLowerCase().contains(searchText))
                  .map((food) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.food_bank_rounded),
                        title: Text(food),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DrinkDetailPage(foodname: food),
                                  ),
                                );
                              },
                              child: const Text('Detail'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showConfirmationDialog(context, food, 1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.brown,
                              ),
                              child: const Text('Pesan'),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String foodname,
    int quantity,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Pesanan'),
          content: Text(
            'Apakah anda yakin ingin memesan $foodname sebanyak $quantity cup.',
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessDialog(context, foodname, quantity);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String foodname, int quantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan Berhasil'),
          content: Text('Anda telah memesan $foodname sebanyak $quantity cup.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class DrinkDetailPage extends StatefulWidget {
  final String foodname;

  const DrinkDetailPage({super.key, required this.foodname});

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Minuman'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian atas: logo dan nama minuman
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.brown[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.local_cafe,
                      size: 80,
                      color: Colors.brown,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    widget.foodname,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Jumlah Pesanan',
                    style: TextStyle(fontSize: 16),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Color.fromARGB(255, 255, 240, 217),
                        ),
                      ),

                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Color.fromARGB(255, 117, 78, 53),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showConfirmationDialog,
                child: const Text('Tambah Pesanan'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Pesanan'),
          content: Text(
            'Apakah kamu yakin ingin memesan '
            '${widget.foodname} sebanyak $quantity cup?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showSuccessDialog();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Pesanan Berhasil'),
          content: Text(
            'Kamu telah memesan ${widget.foodname} '
            'sebanyak $quantity cup.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}