import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:reportes_unimayor/providers/id_location_qr_scanner.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';
import 'package:path/path.dart' as p;

class CreateReportUserScreen extends ConsumerStatefulWidget {
  const CreateReportUserScreen({super.key});

  @override
  ConsumerState createState() => _CreateReportUserScreenState();
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
  String _buttonSelectDescription = 'Audio';

  final AudioRecorder audioRecorder = AudioRecorder();
  bool isRecording = false;
  String? recordingPath;

  @override
  void dispose() {
    audioRecorder.stop();
    audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final idLocationQrScanner = ref.watch(idLocationQrScannerProvider);

    return Scaffold(
      appBar: AppBarUser(),
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
                        selectButton(
                          () {
                            setState(() {
                              _buttonSelectLocation = 'Qr';
                            });
                          },
                          'Escáner Qr',
                          'Qr',
                          _buttonSelectLocation,
                        ),
                        SizedBox(width: 10),
                        selectButton(
                          () {
                            setState(() {
                              _buttonSelectLocation = 'Seleccionar';
                            });
                          },
                          'Seleccionar',
                          'Seleccionar',
                          _buttonSelectLocation,
                        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Descripción',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        selectButton(
                          () {
                            setState(() {
                              _buttonSelectDescription = 'Audio';
                            });
                          },
                          'Audio',
                          'Audio',
                          _buttonSelectDescription,
                        ),
                        SizedBox(width: 10),
                        selectButton(
                          () {
                            setState(() {
                              _buttonSelectDescription = 'Escribir';
                            });
                          },
                          'Escribir',
                          'Escribir',
                          _buttonSelectDescription,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buttonSelectDescription == 'Escribir'
                    ? TextFormField(
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
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 5,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  padding: const EdgeInsets.all(30),
                                  onPressed: () async {
                                    if (isRecording) {
                                      String? filePath = await audioRecorder
                                          .stop();

                                      if (filePath != null) {
                                        setState(() {
                                          isRecording = false;
                                          recordingPath = filePath;
                                        });
                                      }
                                    } else {
                                      if (await audioRecorder.hasPermission()) {
                                        final Directory appDocumentDirectory =
                                            await getApplicationDocumentsDirectory();
                                        final String filePath = p.join(
                                          appDocumentDirectory.path,
                                          'audio.m4a',
                                        );

                                        await audioRecorder.start(
                                          RecordConfig(
                                            encoder: AudioEncoder.aacLc,
                                          ),
                                          path: filePath,
                                        );

                                        setState(() {
                                          isRecording = true;
                                          recordingPath = null;
                                        });
                                      }
                                    }
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: recordingPath != null
                                        ? const Color.fromARGB(
                                            255,
                                            103,
                                            230,
                                            99,
                                          ).withAlpha(50)
                                        : Colors.grey.withAlpha(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  icon: Icon(
                                    isRecording ? Icons.stop : Icons.mic,
                                    size: 80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Presionar una vez',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
              if (isRecording) {
                return;
              }

              if (_formKey.currentState!.validate()) {
                if (idLocationQrScanner.isNotEmpty) {
                  _selectedLocation = idLocationQrScanner;
                }

                bool? response;

                if (_buttonSelectDescription == 'Audio' &&
                    recordingPath != null) {
                  response = await ref.read(
                    createReportRecordProvider(
                      _selectedLocation!,
                      recordingPath!,
                    ).future,
                  );
                } else {
                  response = await ref.read(
                    createReportWriteProvider(
                      _selectedLocation!,
                      _description!,
                    ).future,
                  );
                }

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
                  isRecording ? 'Grabando Audio' : 'Enviar',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                isRecording
                    ? CircularProgressIndicator()
                    : const Icon(Icons.send, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton selectButton(
    Function buttonFunction,
    String text,
    String value,
    buttonSelect,
  ) {
    return TextButton(
      onPressed: () {
        buttonFunction();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey.withAlpha(50)),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 15)),
        side: WidgetStateProperty.all(
          BorderSide(
            color: buttonSelect == value ? Colors.grey : Colors.transparent,
            width: 1, // Grosor del borde
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.black,
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
}
