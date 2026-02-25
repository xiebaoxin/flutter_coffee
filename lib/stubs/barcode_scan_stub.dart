// Stub for barcode_scan
class ScanOptions {}

class ScanResult {
  final String rawContent;
  ScanResult({this.rawContent = ''});
}

class BarcodeScanner {
  static Future<ScanResult> scan({ScanOptions? options}) async {
    return ScanResult(rawContent: '');
  }
}
