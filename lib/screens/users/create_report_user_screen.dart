import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    {'idLocation': '1', 'location': 'Salón 201'},
    {'idLocation': '2', 'location': 'Salón 202'},
  ];

  String? _selectedHeadquarter;
  String? _selectedBuilding;
  String? _selectedLocation;
  String? _description;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: AppBarUser(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
          child: Column(
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
                  if (value == null || value.isEmpty) {
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
                  return DropdownMenuItem(value: build, child: Text(build));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBuilding = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una opción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: _selectedLocation,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar Salón o Lugar Mas Cercano',
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
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una opción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
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
                        final response = await ref.read(
                          createReportProvider(
                            _selectedLocation!,
                            _description!,
                          ).future,
                        );

                        if (response == true) {
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.send),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
