import 'package:flutter/material.dart';
import 'models/pizza_item.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const PizzaApp());
}

class PizzaApp extends StatefulWidget {
  const PizzaApp({super.key});

  @override
  State<PizzaApp> createState() => _PizzaAppState();
}

class _PizzaAppState extends State<PizzaApp> {
  // Lista global simple para el carrito
  final List<CartItem> _cart = [];

  void _addToCart(PizzaItem pizza) {
    setState(() {
      final index = _cart.indexWhere((item) => item.pizza.id == pizza.id);
      if (index >= 0) {
        _cart[index].cantidad++;
      } else {
        _cart.add(CartItem(pizza: pizza, cantidad: 1));
      }
    });
  }

  void _removeFromCart(PizzaItem pizza) {
    setState(() {
      final index = _cart.indexWhere((item) => item.pizza.id == pizza.id);
      if (index >= 0) {
        if (_cart[index].cantidad > 1) {
          _cart[index].cantidad--;
        } else {
          _cart.removeAt(index);
        }
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PizzApp',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBE6B5), // Fondo anaranjado/crema
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
          primary: const Color(0xFFD32F2F),
          secondary: const Color(0xFFFFB300),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/menu': (context) => MenuScreen(
              cart: _cart,
              onAddToCart: _addToCart,
            ),
        '/cart': (context) => CartScreen(
              cart: _cart,
              onAddToCart: _addToCart,
              onRemoveFromCart: _removeFromCart,
              onClearCart: _clearCart,
            ),
      },
    );
  }
}