import 'package:flutter/material.dart';
import '../models/pizza_item.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cart;
  final Function(PizzaItem) onAddToCart;
  final Function(PizzaItem) onRemoveFromCart;
  final VoidCallback onClearCart;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    final double total = cart.fold(
      0.0,
      (sum, item) => sum + (item.pizza.precio * item.cantidad),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE50914),
        title: const Text('Carrito', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.local_pizza, color: Colors.white),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Atrás', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Card(
                        color: const Color(0xFFFFE082),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          leading: const Icon(Icons.local_pizza, color: Color(0xFFD32F2F)),
                          title: Text(item.pizza.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('\$${(item.pizza.precio * item.cantidad).toStringAsFixed(0)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => onRemoveFromCart(item.pizza),
                              ),
                              Text('${item.cantidad}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => onAddToCart(item.pizza),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Resumen del total y acciones
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white24,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD54F),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('\$${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC107),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('¡Pedido Confirmado!'),
                                    content: Text('Total pagado: \$${total.toStringAsFixed(0)}'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          onClearCart();
                                          Navigator.pop(ctx);
                                          Navigator.pushReplacementNamed(context, '/menu');
                                        },
                                        child: const Text('Aceptar'),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Pagar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD32F2F),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                onClearCart();
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('@Todos los derechos reservados', style: TextStyle(color: Colors.brown, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}