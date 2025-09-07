import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
      onPressed: _isLoading ? null : _login,
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

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();

      // final String? token = await ApiAuthService().login(email);
    } catch (e) {
      if (!mounted) return;
      // showMessage(
      //   context,
      //   'Error de conexión. Intenta nuevamente.',
      //   Theme.of(context).colorScheme.error,
      // );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
