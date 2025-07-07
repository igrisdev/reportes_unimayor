import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'id_location_qr_scanner.g.dart';

@Riverpod(keepAlive: true)
class IdLocationQrScanner extends _$IdLocationQrScanner {
  @override
  String build() => '';

  void setIdLocationQrScanner(String newIdLocationQrScanner) {
    state = newIdLocationQrScanner;
  }

  void removeIdLocationQrScanner() {
    state = '';
  }
}
