import 'package:flutter/material.dart';

void main() {
  runApp(const ReservaViajeApp());
}

class ReservaViajeApp extends StatelessWidget {
  const ReservaViajeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Viaje',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PantallaFormulario(),
    );
  }
}

// Modelo de datos para transferir la información a la Pantalla 2
class DatosReserva {
  final String nombre;
  final String correo;
  final String destino;
  final String transporte;
  final bool hotel;
  final bool tour;
  final bool seguro;
  final bool notificaciones;
  final double presupuesto;
  final DateTime? fecha;

  DatosReserva({
    required this.nombre,
    required this.correo,
    required this.destino,
    required this.transporte,
    required this.hotel,
    required this.tour,
    required this.seguro,
    required this.notificaciones,
    required this.presupuesto,
    required this.fecha,
  });
}

class PantallaFormulario extends StatefulWidget {
  const PantallaFormulario({super.key});

  @override
  State<PantallaFormulario> createState() => _PantallaFormularioState();
}

class _PantallaFormularioState extends State<PantallaFormulario> {
  // Sección 2: Controladores
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  // Sección 3: Destino y transporte
  String _destinoSeleccionado = 'Playa';
  String _transporteSeleccionado = 'Avion';
  final List<String> _opcionesTransporte = ['Avion', 'Autobus', 'Tren', 'Barco'];

  // Sección 4: Extras y preferencias
  bool _hotelIncluido = false;
  bool _tourGuiado = false;
  bool _seguroViaje = false;
  bool _notificaciones = false;
  double _presupuesto = 2000.0;
  DateTime? _fechaViaje;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  // Función para mostrar SnackBars
  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Limpiar todos los inputs y widgets
  void _limpiarFormulario() {
    setState(() {
      _nombreController.clear();
      _correoController.clear();
      _destinoSeleccionado = 'Playa';
      _transporteSeleccionado = 'Avion';
      _hotelIncluido = false;
      _tourGuiado = false;
      _seguroViaje = false;
      _notificaciones = false;
      _presupuesto = 2000.0;
      _fechaViaje = null;
    });
    _mostrarSnackBar('Formulario reiniciado correctamente');
  }

  // Selector de fecha
  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaViaje ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fechaViaje) {
      setState(() {
        _fechaViaje = picked;
      });
      _mostrarSnackBar(
        'Fecha elegida: ${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}',
      );
    }
  }

  // Modal para "Ver Resumen"
  void _mostrarResumenModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen Preliminar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Text('Viajero: ${_nombreController.text.isEmpty ? "Sin registrar" : _nombreController.text}'),
              Text('Destino: $_destinoSeleccionado en $_transporteSeleccionado'),
              Text('Presupuesto: \$${_presupuesto.toStringAsFixed(0)} MXN'),
              Text('Fecha: ${_fechaViaje != null ? "${_fechaViaje!.day}/${_fechaViaje!.month}/${_fechaViaje!.year}" : "Pendiente"}'),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Navegación a Pantalla 2 (Confirmar)
  void _navegarABoleto() {
    final reserva = DatosReserva(
      nombre: _nombreController.text.trim().isEmpty ? 'Viajero Anónimo' : _nombreController.text.trim(),
      correo: _correoController.text.trim().isEmpty ? 'No registrado' : _correoController.text.trim(),
      destino: _destinoSeleccionado,
      transporte: _transporteSeleccionado,
      hotel: _hotelIncluido,
      tour: _tourGuiado,
      seguro: _seguroViaje,
      notificaciones: _notificaciones,
      presupuesto: _presupuesto,
      fecha: _fechaViaje,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaBoleto(reserva: reserva),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('Reserva de Viaje', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services, color: Colors.white),
            tooltip: 'Limpiar campos',
            onPressed: _limpiarFormulario,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // Sección 1 - Información general
            _buildContainerTarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Seccion 1 - Informacion general',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Completa tu reserva paso a paso',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Llena tus datos, elige destino y confirma tu viaje.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 2 - Datos del viajero
            _buildContainerTarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sección 2 - Datos del viajero',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      hintText: 'Ej: Ana Garcia',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electronico',
                      hintText: 'Ej: ana@correo.com',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 3 - Destino y transporte
            _buildContainerTarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sección 3 - Destino y transporte',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildDestinoItem('Playa', Icons.beach_access, Colors.blue),
                      const SizedBox(width: 8),
                      _buildDestinoItem('Ciudad', Icons.location_city, Colors.orange),
                      const SizedBox(width: 8),
                      _buildDestinoItem('Montaña', Icons.landscape, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _transporteSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Medio de transporte',
                      prefixIcon: Icon(Icons.commute),
                      border: OutlineInputBorder(),
                    ),
                    items: _opcionesTransporte.map((String opcion) {
                      return DropdownMenuItem<String>(
                        value: opcion,
                        child: Text(opcion),
                      );
                    }).toList(),
                    onChanged: (String? nuevoValor) {
                      if (nuevoValor != null) {
                        setState(() => _transporteSeleccionado = nuevoValor);
                        _mostrarSnackBar('Transporte seleccionado: $nuevoValor');
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 4 - Extras y preferencias
            _buildContainerTarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sección 4 - Extras y preferencias',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  _buildCheckboxExtra(
                    titulo: 'Hotel incluido (+ \$1200)',
                    icono: Icons.hotel,
                    valor: _hotelIncluido,
                    onChanged: (val) {
                      setState(() => _hotelIncluido = val ?? false);
                      _mostrarSnackBar(_hotelIncluido ? 'Hotel añadido' : 'Hotel removido');
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildCheckboxExtra(
                    titulo: 'Tour guiado (+ \$600)',
                    icono: Icons.tour,
                    valor: _tourGuiado,
                    onChanged: (val) {
                      setState(() => _tourGuiado = val ?? false);
                      _mostrarSnackBar(_tourGuiado ? 'Tour guiado añadido' : 'Tour guiado removido');
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildCheckboxExtra(
                    titulo: 'Seguro de viaje (+ \$400)',
                    icono: Icons.health_and_safety,
                    valor: _seguroViaje,
                    onChanged: (val) {
                      setState(() => _seguroViaje = val ?? false);
                      _mostrarSnackBar(_seguroViaje ? 'Seguro añadido' : 'Seguro removido');
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: _notificaciones ? Colors.blue.shade50 : Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SwitchListTile(
                      title: const Text('Recibir notificaciones', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(_notificaciones ? 'Activadas' : 'Desactivadas'),
                      value: _notificaciones,
                      onChanged: (bool val) {
                        setState(() => _notificaciones = val);
                        _mostrarSnackBar(val ? 'Notificaciones activadas' : 'Notificaciones desactivadas');
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Presupuesto:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        '\$${_presupuesto.toStringAsFixed(0)} MXN',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15),
                      ),
                    ],
                  ),
                  Slider(
                    value: _presupuesto,
                    min: 500,
                    max: 10000,
                    divisions: 20,
                    label: _presupuesto.round().toString(),
                    onChanged: (double val) {
                      setState(() => _presupuesto = val);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month, color: Colors.blue, size: 28),
                    title: const Text('Fecha del viaje', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      _fechaViaje == null
                          ? 'Toca para elegir fecha'
                          : '${_fechaViaje!.day.toString().padLeft(2, '0')}/${_fechaViaje!.month.toString().padLeft(2, '0')}/${_fechaViaje!.year}',
                      style: TextStyle(
                        color: _fechaViaje == null ? Colors.grey : Colors.black87,
                        fontWeight: _fechaViaje == null ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                    onTap: _seleccionarFecha,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 5 - Confirmar
            _buildContainerTarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seccion 5 - Confirmar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Revisa tus datos antes de despegar',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _mostrarResumenModal,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Ver Resumen'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _navegarABoleto,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Tarjeta general para unificar el diseño de cada sección
  Widget _buildContainerTarjeta({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Tarjeta de selección individual para la Sección 3
  Widget _buildDestinoItem(String nombre, IconData icono, Color colorBase) {
    final bool seleccionado = _destinoSeleccionado == nombre;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() => _destinoSeleccionado = nombre);
          _mostrarSnackBar('Destino seleccionado: $nombre');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: seleccionado ? colorBase.withOpacity(0.15) : Colors.grey.shade50,
            border: Border.all(
              color: seleccionado ? colorBase : Colors.grey.shade300,
              width: seleccionado ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icono, color: seleccionado ? colorBase : Colors.grey.shade700, size: 28),
              const SizedBox(height: 6),
              Text(
                nombre,
                style: TextStyle(
                  fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
                  color: seleccionado ? colorBase : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Checkbox con cambio dinámico de color para la Sección 4
  Widget _buildCheckboxExtra({
    required String titulo,
    required IconData icono,
    required bool valor,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: valor ? Colors.blue.shade50 : Colors.white,
        border: Border.all(
          color: valor ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        secondary: Icon(icono, color: valor ? Colors.blue : Colors.grey.shade600),
        title: Text(
          titulo,
          style: TextStyle(
            fontSize: 13,
            fontWeight: valor ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        value: valor,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}

// Pantalla 2: Boleto de Confirmación
class PantallaBoleto extends StatelessWidget {
  final DatosReserva reserva;

  const PantallaBoleto({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Mi Boleto', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PASE DE ABORDAJE',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          Icon(Icons.confirmation_number_outlined, color: Colors.blue.shade700),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildDatoBoleto('Pasajero', reserva.nombre),
                      _buildDatoBoleto('Contacto', reserva.correo),
                      _buildDatoBoleto('Destino', reserva.destino),
                      _buildDatoBoleto('Medio de transporte', reserva.transporte),
                      _buildDatoBoleto(
                        'Fecha',
                        reserva.fecha != null
                            ? '${reserva.fecha!.day.toString().padLeft(2, '0')}/${reserva.fecha!.month.toString().padLeft(2, '0')}/${reserva.fecha!.year}'
                            : 'Fecha abierta',
                      ),
                      _buildDatoBoleto('Presupuesto asignado', '\$${reserva.presupuesto.toStringAsFixed(0)} MXN'),
                      const Divider(height: 24),
                      const Text(
                        'Servicios adicionales:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text('• Hotel: ${reserva.hotel ? "Incluido" : "No"}'),
                      Text('• Tour guiado: ${reserva.tour ? "Incluido" : "No"}'),
                      Text('• Seguro de viaje: ${reserva.seguro ? "Incluido" : "No"}'),
                      Text('• Notificaciones: ${reserva.notificaciones ? "Activadas" : "Desactivadas"}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Regresar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatoBoleto(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}