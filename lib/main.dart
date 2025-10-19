import 'package:flutter/material.dart';

import 'data.dart';

/// Задачи
/// 1. Перенос логики из UI в ViewModel (MVVM):
/// - Вынести классы в отдельные файлы
/// - Создать стейт менеджер (ChangeNotifier) для управления списком продуктов и корзиной
/// - Создать глобальный инстанс стейт менеджера (пока что)
/// - Подписаться на стейт менеджер в виджетах (ListenableBuilder)
/// - Пройтись по TODO
///
/// 2. Рафакторинг по clean architecture (базовый)
/// - Создать репозиторий (разделение зон ответственности Presentation - Data)
///   - StateManager отвечает только за state,
///   - Repository отвечает за получение данных
/// - Добавить управление зависимостями через InheritedWidget или Provider
///
/// 3. Опциональные задачи (оверинжиниринг, не всегда нужно)
/// - Создать абстракции (DIP - зависимость от абстракций, не конкретных реализаций)
/// - Разбить один ChangeNotifier на несколько (SRP - единственная ответственность)
/// - Data (реализации), Domain (абстракции, сущности), Presentation (виджеты, стейт менеджеры)
/// - Разделение продуктов на DTO, получаемых из API, и Entity, используемых в UI

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _changeIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Product List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Chart',
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          ProductListScreen(),
          ChartScreen(),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    // TODO: Добавить получение списка продуктов из стейт менеджера
    _products = (products['products'] as List).map((product) {
      return Product(
        id: product['id'] as int,
        name: product['title'] as String,
        price: product['price'] as double,
        imageUrl: product['images'][0] as String,
        isSelected: false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => ProductListItem(
          product: _products[index],
        ),
        itemCount: _products.length,
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  const ProductListItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.network(
                  product.imageUrl,
                  height: double.maxFinite,
                  width: 100,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: product.isSelected,
                  onChanged: (value) {
                    // TODO: Добавить передачу колбека через конструктор
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isSelected = false,
  });

  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final bool isSelected;
}

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  // TODO: Добавить получение корзины из стейт менеджера
  final List<Product> _cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ProductListItem(
          product: _cartItems[index],
        ),
        itemCount: _cartItems.length,
      ),
    );
  }
}
