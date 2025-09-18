import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/models/person_model.dart';
import 'package:reportes_unimayor/services/api_reports_service.dart';
import 'package:reportes_unimayor/utils/show_message.dart';
import 'package:reportes_unimayor/widgets/app_bar_brigadier.dart';

class SearchPerson extends ConsumerStatefulWidget {
  const SearchPerson({super.key});

  @override
  ConsumerState<SearchPerson> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<SearchPerson> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  PersonModel? _person;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBarBrigadier(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Consultar Al Paciente',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Escribe el correo de la persona que desea consultar para ver su información.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 18),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: decorationTextForm(
                        'ejemplo@unimayor.edu.co',
                        Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, introduce un email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buttonSearchPerson(colorScheme),
                  ],
                ),
              ),
              if (_person != null) ...[
                const Divider(height: 30),
                Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Información del usuario",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("Nombre: ${_person!.infoUsuario.nombre}"),
                      Text("Correo: ${_person!.infoUsuario.correo}"),

                      const Divider(height: 30),

                      Row(
                        children: [
                          Icon(
                            Icons.contact_phone,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Contactos de emergencia",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (_person!.contactos.isNotEmpty &&
                          _person!.contactos.first.mensaje != null)
                        ListTile(
                          leading: const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                          title: Text(
                            _person!.contactos.first.mensaje!,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        )
                      else
                        ..._person!.contactos.map(
                          (c) => ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(c.nombre ?? "Sin nombre"),
                            subtitle: Text(
                              "${c.relacion ?? "Sin relación"} - ${c.telefono ?? "N/A"}",
                            ),
                          ),
                        ),

                      const Divider(height: 30),

                      // Condiciones médicas
                      Row(
                        children: [
                          Icon(
                            Icons.local_hospital,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Condiciones médicas",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (_person!.condicionesMedicas.isNotEmpty &&
                          _person!.condicionesMedicas.first.mensaje != null)
                        ListTile(
                          leading: const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                          title: Text(
                            _person!.condicionesMedicas.first.mensaje!,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        )
                      else
                        ..._person!.condicionesMedicas.map(
                          (cm) => ListTile(
                            leading: const Icon(Icons.health_and_safety),
                            title: Text(cm.nombre ?? ""),
                            subtitle: Text(cm.descripcion ?? ""),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Center circularProgress(ColorScheme colorScheme) {
    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
        strokeWidth: 3,
      ),
    );
  }

  ElevatedButton buttonSearchPerson(ColorScheme colorScheme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      onPressed: _isLoading ? null : _search,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Buscar', style: GoogleFonts.poppins(fontSize: 16)),
          if (_isLoading) const SizedBox(width: 20),
          if (_isLoading)
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: colorScheme.onPrimary,
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration decorationTextForm(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _search() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _person = null;
    });

    try {
      final email = _emailController.text.trim();

      final person = await ApiReportsService().searchPerson(email);

      if (!mounted) return;

      setState(() {
        _person = person;
      });
    } catch (e) {
      if (!mounted) return;
      print(e);
      showMessage(
        context,
        'Error al consultar al usuario. Intenta nuevamente.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
