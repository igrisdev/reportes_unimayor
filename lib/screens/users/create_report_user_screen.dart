import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/id_location_qr_scanner.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';

class CreateReportUserScreen extends ConsumerStatefulWidget {
  const CreateReportUserScreen({super.key});

  @override
  createState() => _CreateReportUserScreenState();
}

class _CreateReportUserScreenState
    extends ConsumerState<CreateReportUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _headquarters = ['Bicentenario', 'Encarnación'];
  final List<String> _buildings = ['Edificio 1'];
  // final List<String> _rooms = ['Salón 201', 'Salon 202'];
  final List<Map<String, String>> _locations = [
    {'idLocation': '1', 'location': 'Salón 101'},
    {'idLocation': '2', 'location': 'Salón 202'},
    {'idLocation': '3', 'location': 'Salón 302'},
  ];

  String? _selectedHeadquarter;
  String? _selectedBuilding;
  String? _selectedLocation;
  String? _description;

  String _buttonSelectLocation = 'Qr';

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    final idLocationQrScanner = ref.watch(idLocationQrScannerProvider);

    return Scaffold(
      appBar: AppBarUser(),
      // La configuración por defecto de resizeToAvoidBottomInset está en true.
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ubicación',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        buttonSelect('Escáner Qr', 'Qr'),
                        SizedBox(width: 10),
                        buttonSelect('Seleccionar', 'Seleccionar'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buttonSelectLocation == 'Seleccionar'
                    ? Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedHeadquarter,
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar Sede',
                            ),
                            items: _headquarters.map((headquarter) {
                              return DropdownMenuItem<String>(
                                value: headquarter,
                                child: Text(headquarter),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedHeadquarter = value;
                              });
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty &&
                                      _buttonSelectLocation == 'Seleccionar') {
                                return 'Por favor seleccione una opción';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedBuilding,
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar Edificio',
                            ),
                            items: _buildings.map((build) {
                              return DropdownMenuItem(
                                value: build,
                                child: Text(build),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBuilding = value;
                              });
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty &&
                                      _buttonSelectLocation == 'Seleccionar') {
                                return 'Por favor seleccione una opción';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField(
                            value: _selectedLocation,
                            decoration: const InputDecoration(
                              labelText:
                                  'Seleccionar Salón o Lugar Mas Cercano',
                            ),
                            items: _locations.map((location) {
                              return DropdownMenuItem(
                                value: location['idLocation'],
                                child: Text(location['location']!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLocation = value;
                              });
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty &&
                                      _buttonSelectLocation == 'Seleccionar') {
                                return 'Por favor seleccione una opción';
                              }
                              return null;
                            },
                          ),
                        ],
                      )
                    : buttonScannerQr(router, idLocationQrScanner),
                SizedBox(height: 20),
                Text(
                  'Descripción',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'Descripción del reporte',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _description = value;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor escriba una descripción';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 70,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: lightMode.colorScheme.secondary,
              foregroundColor: lightMode.colorScheme.secondaryFixed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (idLocationQrScanner.isNotEmpty) {
                  _selectedLocation = idLocationQrScanner;
                }

                final response = await ref.read(
                  createReportProvider(
                    _selectedLocation!,
                    _description!,
                  ).future,
                );

                if (response == true) {
                  ref
                      .read(idLocationQrScannerProvider.notifier)
                      .removeIdLocationQrScanner();

                  router.push('/user');
                  return;
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enviar',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                const Icon(Icons.send, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buttonScannerQr(GoRouter router, String idLocationQrScanner) {
    return GestureDetector(
      onTap: () {
        router.push('/user/create-report/qr-scanner');
      },
      child: Container(
        decoration: BoxDecoration(
          color: idLocationQrScanner.isNotEmpty
              ? Colors.green.withValues(alpha: 0.1)
              : null,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        width: double.infinity,
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  idLocationQrScanner.isNotEmpty
                      ? Text(
                          'Id de ubicación escaneada: $idLocationQrScanner',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          'Escanear QR',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  Text('Presionar para escanear', style: GoogleFonts.poppins()),
                ],
              ),
              SizedBox(height: 10),
              Icon(Icons.qr_code_scanner, size: 50),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buttonSelect(String text, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_buttonSelectLocation != value) {
            _buttonSelectLocation = value;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: _buttonSelectLocation == value
              ? Border.all(color: Colors.grey)
              : null,
          borderRadius: BorderRadius.circular(5),
        ),
        foregroundDecoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
