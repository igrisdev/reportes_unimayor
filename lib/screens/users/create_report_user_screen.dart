import 'package:flutter/material.dart';
import 'package:reportes_unimayor/components/app_bar_user.dart';

class CreateReportUserScreen extends StatefulWidget {
  const CreateReportUserScreen({super.key});

  @override
  State<CreateReportUserScreen> createState() => _CreateReportUserScreenState();
}

class _CreateReportUserScreenState extends State<CreateReportUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _headquarters = ['Bicentenario', 'Encarnación'];

  final List<String> _buildings = ['Edificio 1'];

  String? _selectedHeadquarter;
  String? _selectedBuilding;
  String? _description;

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción del reporte',
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
