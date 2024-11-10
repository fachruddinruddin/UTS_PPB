import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Komputer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ComputerStorePage(),
    );
  }
}

class ComputerStorePage extends StatefulWidget {
  const ComputerStorePage({super.key});

  @override
  State<ComputerStorePage> createState() => _ComputerStorePageState();
}

class _ComputerStorePageState extends State<ComputerStorePage> {
  final List<Product> products = [
    Product(name: 'Laptop', price: 15000000),
    Product(name: 'Mouse', price: 100000),
    Product(name: 'Keyboard', price: 500000),
    Product(name: 'Monitor', price: 5000000),
    Product(name: 'Printer', price: 2200000),
  ];

  List<Transaction> transactions = [];
  int totalAmount = 0;

  final List<TextEditingController> quantityControllers = List.generate(
    5,
    (index) => TextEditingController(text: '0'),
  );

  void resetAll() {
    setState(() {
      for (var controller in quantityControllers) {
        controller.text = '0';
      }
      transactions.clear();
      totalAmount = 0;
    });
  }

  void printReceipt() {
    setState(() {
      transactions.clear();
      totalAmount = 0;

      for (int i = 0; i < products.length; i++) {
        int quantity = int.tryParse(quantityControllers[i].text) ?? 0;
        if (quantity > 0) {
          int subtotal = products[i].price * quantity;
          transactions.add(
            Transaction(
              product: products[i],
              quantity: quantity,
              subtotal: subtotal,
            ),
          );
          totalAmount += subtotal;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Komputer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Product List
            ...List.generate(
              products.length,
              (index) => Card(
                //1
                child: ListTile(
                  title: Text(products[index].name),
                  subtitle: Text(
                    'Rp ${products[index].price.toString()}',
                  ),
                  trailing: SizedBox(
                    width: 60,
                    child: TextField(
                      controller: quantityControllers[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Buttons
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    //2
                    onPressed: resetAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: printReceipt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Cetak Struk'),
                  ),
                ),
              ],
            ),
            // Receipt
            const SizedBox(height: 16),
            if (transactions.isNotEmpty) ...[
              const Divider(),
              ...transactions.map(
                (transaction) => ListTile(
                  //3
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(
                    transaction.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Rp ${transaction.product.price} x ${transaction.quantity}',
                  ),
                  trailing: Text(
                    'Rp ${transaction.subtotal}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                tileColor: Colors.blue[300],
                title: const Text(
                  //4
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                trailing: Text(
                  'Rp $totalAmount',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class Product {
  final String name;
  final int price;

  Product({required this.name, required this.price});
}

class Transaction {
  final Product product;
  final int quantity;
  final int subtotal;

  Transaction({
    required this.product,
    required this.quantity,
    required this.subtotal,
  });
}
