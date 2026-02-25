import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class Key {
  final Uint8List bytes;
  Key(this.bytes);
  factory Key.fromUtf8(String s) => Key(Uint8List.fromList(utf8.encode(s)));
  factory Key.fromBase64(String s) => Key(base64.decode(s));
}

class IV {
  final Uint8List bytes;
  IV(this.bytes);
  factory IV.fromUtf8(String s) => IV(Uint8List.fromList(utf8.encode(s)));
  factory IV.fromBase64(String s) => IV(base64.decode(s));
}

class Encrypted {
  final Uint8List bytes;
  Encrypted(this.bytes);
  String get base64 => base64Encode(bytes);
}

enum AESMode { cbc, ecb, cfb64, sic, ctr }

class AES {
  final Key key;
  final AESMode mode;
  AES(this.key, {this.mode = AESMode.cbc});
}

class Encrypter {
  final AES algo;
  Encrypter(this.algo);

  Encrypted encrypt(String plainText, {required IV iv}) {
    final keyParam = KeyParameter(algo.key.bytes);
    final params = ParametersWithIV<KeyParameter>(keyParam, iv.bytes);
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );
    cipher.init(true, PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(params, null));
    final inputBytes = Uint8List.fromList(utf8.encode(plainText));
    final encrypted = cipher.process(inputBytes);
    return Encrypted(encrypted);
  }

  String decrypt(Encrypted encrypted, {required IV iv}) {
    final keyParam = KeyParameter(algo.key.bytes);
    final params = ParametersWithIV<KeyParameter>(keyParam, iv.bytes);
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );
    cipher.init(false, PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(params, null));
    final decrypted = cipher.process(encrypted.bytes);
    return utf8.decode(decrypted);
  }

  String decrypt64(String base64Text, {required IV iv}) {
    return decrypt(Encrypted(base64Decode(base64Text)), iv: iv);
  }
}
