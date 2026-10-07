class PizzaItem {
  final int id;
  final String nombre;
  final double precio;
  final String descripcion;

  PizzaItem({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
  });
}

class CartItem {
  final PizzaItem pizza;
  int cantidad;

  CartItem({required this.pizza, this.cantidad = 1});
}