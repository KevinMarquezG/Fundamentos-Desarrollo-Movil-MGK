import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Preferencias',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PreferencesScreen(),
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Controladores de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Estados de controles UI
  String _selectedGender = 'Masculino';
  bool _interestDeporte = false;
  bool _interestMusica = false;
  bool _interestCine = false;
  bool _interestLectura = false;
  String _selectedCountry = 'Mexico';

  final List<String> _countries = [
    'Mexico',
    'Colombia',
    'Argentina',
    'España',
    'Chile',
    'Peru',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FC),
      appBar: AppBar(
        title: const Text(
          'Registro de Preferencias',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // Sección 1: Información General
            _buildSectionCard(
              borderColor: Colors.blue.shade100,
              backgroundColor: const Color(0xFFEDF6FD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade800, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Seccion 1: Informacion General',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Completa los siguientes datos personales basicos',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 2: Datos Personales
            _buildSectionCard(
              borderColor: Colors.green.shade200,
              backgroundColor: const Color(0xFFF1F8F1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.green.shade800, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Seccion 2: Datos Personales',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInputBox(
                    controller: _nameController,
                    hintText: 'Nombre completo',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  _buildInputBox(
                    controller: _ageController,
                    hintText: 'Edad',
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 3: Distribución en Filas
            _buildSectionCard(
              borderColor: Colors.orange.shade200,
              backgroundColor: const Color(0xFFFFF7EB),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.view_agenda, color: Colors.orange.shade800, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Seccion 3: Distribucion en Filas',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildColorRow(
                    dotColor: Colors.redAccent,
                    bgColor: const Color(0xFFFFD9DF),
                    text: 'Fila 1 - Color Rojo',
                  ),
                  const SizedBox(height: 8),
                  _buildColorRow(
                    dotColor: Colors.amber,
                    bgColor: const Color(0xFFFFF9D2),
                    text: 'Fila 2 - Color Amarillo',
                  ),
                  const SizedBox(height: 8),
                  _buildColorRow(
                    dotColor: Colors.blue,
                    bgColor: const Color(0xFFCDE8FD),
                    text: 'Fila 3 - Color Azul',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 4: Cuatro Hijos en Colores
            _buildSectionCard(
              borderColor: Colors.purple.shade200,
              backgroundColor: const Color(0xFFF9EEF9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.grid_view_rounded, color: Colors.purple.shade800, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Seccion 4: Cuatro Hijos en Colores',
                        style: TextStyle(
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChildBox(
                          text: 'Hijo 1',
                          bgColor: const Color(0xFFF7B7C6),
                          textColor: const Color(0xFF9E2A4B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildChildBox(
                          text: 'Hijo 2',
                          bgColor: const Color(0xFFFFDF9E),
                          textColor: const Color(0xFF9B6817),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildChildBox(
                          text: 'Hijo 3',
                          bgColor: const Color(0xFFBCE7C7),
                          textColor: const Color(0xFF26733B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildChildBox(
                          text: 'Hijo 4',
                          bgColor: const Color(0xFFC7BFE6),
                          textColor: const Color(0xFF4A3E7B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 5: Controles UI
            _buildSectionCard(
              borderColor: Colors.grey.shade300,
              backgroundColor: const Color(0xFFF7F7F8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_circle_outline, color: Colors.grey.shade800, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Seccion 5: Controles UI',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Radio buttons (Género)
                  const Text(
                    'Genero:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  _buildRadioOption('Masculino'),
                  _buildRadioOption('Femenino'),
                  _buildRadioOption('Otro'),

                  const SizedBox(height: 12),

                  // Checkboxes (Intereses)
                  const Text(
                    'Intereses:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  _buildCheckboxOption(
                    label: 'Deporte',
                    value: _interestDeporte,
                    onChanged: (val) => setState(() => _interestDeporte = val ?? false),
                  ),
                  _buildCheckboxOption(
                    label: 'Musica',
                    value: _interestMusica,
                    onChanged: (val) => setState(() => _interestMusica = val ?? false),
                  ),
                  _buildCheckboxOption(
                    label: 'Cine',
                    value: _interestCine,
                    onChanged: (val) => setState(() => _interestCine = val ?? false),
                  ),
                  _buildCheckboxOption(
                    label: 'Lectura',
                    value: _interestLectura,
                    onChanged: (val) => setState(() => _interestLectura = val ?? false),
                  ),

                  const SizedBox(height: 14),

                  // Dropdown (País)
                  const Text(
                    'Pais:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountry,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: _countries.map((String country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Row(
                              children: [
                                const Icon(Icons.public, size: 20, color: Colors.black87),
                                const SizedBox(width: 8),
                                Text(country),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _selectedCountry = newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Botones de acción inferiores
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showPreferencesDialog,
                          icon: const Icon(Icons.visibility, size: 18, color: Colors.white),
                          label: const Text(
                            'Mostrar Preferencias',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registro guardado correctamente')),
                            );
                          },
                          icon: const Icon(Icons.check_circle, size: 18, color: Colors.white),
                          label: const Text(
                            'Guardar Registro',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
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

  // Tarjeta contenedora de cada sección
  Widget _buildSectionCard({
    required Widget child,
    required Color borderColor,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: child,
    );
  }

  // Campo de texto personalizado
  Widget _buildInputBox({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black87, size: 20),
          hintText: hintText,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // Fila de la Sección 3
  Widget _buildColorRow({
    required Color dotColor,
    required Color bgColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Elemento Hijo de la Sección 4
  Widget _buildChildBox({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // Radio button con espaciado compacto
  Widget _buildRadioOption(String value) {
    return InkWell(
      onTap: () => setState(() => _selectedGender = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedGender,
              activeColor: Colors.deepPurple,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (val) {
                if (val != null) setState(() => _selectedGender = val);
              },
            ),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // Checkbox con espaciado compacto
  Widget _buildCheckboxOption({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Checkbox(
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // Diálogo para el botón "Mostrar Preferencias"
  void _showPreferencesDialog() {
    List<String> selectedInterests = [];
    if (_interestDeporte) selectedInterests.add('Deporte');
    if (_interestMusica) selectedInterests.add('Música');
    if (_interestCine) selectedInterests.add('Cine');
    if (_interestLectura) selectedInterests.add('Lectura');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Preferencias Registradas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${_nameController.text.isEmpty ? "No especificado" : _nameController.text}'),
              Text('Edad: ${_ageController.text.isEmpty ? "No especificada" : _ageController.text}'),
              Text('Género: $_selectedGender'),
              Text('Intereses: ${selectedInterests.isEmpty ? "Ninguno" : selectedInterests.join(', ')}'),
              Text('País: $_selectedCountry'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}