import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
import 'package:quee_app/data/models/antrian.dart';

class AntrianPrint {
  AntrianPrint._init();

  static final AntrianPrint instance = AntrianPrint._init();

  Future<List<int>> printAntrian(Antrian antrian) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final genarator = Generator(PaperSize.mm58, profile);

    bytes += genarator.reset();
    bytes += genarator.text(
      'Anrian Kita Bisa',
      styles: PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );

    bytes += genarator.text(
      'Tanggal : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
      styles: PosStyles(bold: true, align: PosAlign.center),
    );

    bytes += genarator.feed(1);

    // nama Antrian
    bytes += genarator.text(
      antrian.nama,
      styles: PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );

    bytes += genarator.feed(1);

    // no Antrian
    bytes += genarator.text(
      'No Antrian : ${antrian.noAntrian}',
      styles: PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );

    bytes += genarator.feed(3);

    return bytes;
  }
}
