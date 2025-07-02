import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_reports_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_provider.g.dart';

@Riverpod(keepAlive: true)
class Report extends _$Report {
  @override
  // Future<List<ReportsModel>> build() async {
  void build() async {
    final token = ref.watch(tokenProvider);
    final reports = await ApiReportsService().getReports(token);

    print(reports);
    // return ;
    // return reports;
  }

  // @override
  // Future<void> update(List<Report> reports) async {
  //   final db = await ref.watch(databaseProvider.future);
  //   await db.updateReports(reports);
  // }
}
