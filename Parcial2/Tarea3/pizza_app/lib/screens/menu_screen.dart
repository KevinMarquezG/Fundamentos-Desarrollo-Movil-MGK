import 'package:flutter/material.dart';
import '../models/pizza_item.dart';

class MenuScreen extends StatelessWidget {
  final List<CartItem> cart;
  final Function(PizzaItem) onAddToCart;

  const MenuScreen({
    super.key,
    required this.cart,
    required this.onAddToCart,
  });

  static final List<PizzaItem> _menuItems = [
    PizzaItem(id: 1, nombre: 'Pizza Peperoni', precio: 100, descripcion: 'Queso y peperoni clásico'),
    PizzaItem(id: 2, nombre: 'Pizza Hawayana', precio: 150, descripcion: 'Jamón, queso y piña'),
    PizzaItem(id: 3, nombre: 'Pizza Queso', precio: 80, descripcion: 'Mozzarella fundido'),
    PizzaItem(id: 4, nombre: 'Pizza Duo', precio: 130, descripcion: 'Mitad peperoni, mitad queso'),
  ];

  @override
  Widget build(BuildContext context) {
    final totalItems = cart.fold<int>(0, (sum, item) => sum + item.cantidad);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE50914),
        title: const Text('Menú', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.local_pizza, color: Colors.white),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.amber,
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: _menuItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pizza = _menuItems[index];
          return Card(
            color: const Color(0xFFFFE082),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFD32F2F),
                child: Icon(Icons.local_pizza, color: Colors.white),
              ),
              title: Text(pizza.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('\$${pizza.precio.toStringAsFixed(0)}'),
              trailing: IconButton(
                icon: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add, size: 18, color: Colors.black),
                ),
                onPressed: () {
                  onAddToCart(pizza);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${pizza.nombre} agregada al carrito'),
                      duration: const Duration(milliseconds: 600),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}