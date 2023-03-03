/*
 * *
 *  * * GNU General Public License v3.0
 *  * *******************************************************************************************
 *  *  * Created By Debojyoti Singha
 *  *  * Copyright (c) 2023.
 *  *  * This program is free software: you can redistribute it and/or modify
 *  *  * it under the terms of the GNU General Public License as published by
 *  *  * the Free Software Foundation, either version 3 of the License, or
 *  *  * (at your option) any later version.
 *  *  *
 *  *  * This program is distributed in the hope that it will be useful,
 *  *  *
 *  *  * but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  *  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  *  * GNU General Public License for more details.
 *  *  *
 *  *  * You should have received a copy of the GNU General Public License
 *  *  * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *  *  * Contact Email: support@swingtechnologies.in
 *  * ******************************************************************************************
 *
 */

import 'package:basic_utils/basic_utils.dart';

/// Holds all necessary data for deploying a self signed HTTPS server
class SecurityContextResult {
  /// Private key - equivalent to privkey.pem
  final String privateKey; // privkey.pem

  /// Public key - equivalent to cert.pem
  final String publicKey;

  /// Certificate - equivalent to chain.pem (but only containing the leaf certificate)
  final String certificate;

  SecurityContextResult({
    required this.privateKey,
    required this.publicKey,
    required this.certificate,
  });
}

/// Generates a random [SecurityContextResult].
SecurityContextResult generateSecurityContext() {
  final keyPair = CryptoUtils.generateRSAKeyPair();
  final privateKey = keyPair.privateKey as RSAPrivateKey;
  final publicKey = keyPair.publicKey as RSAPublicKey;
  final dn = {
    'CN': 'MoveIt User',
    'O': '',
    'OU': '',
    'L': '',
    'S': '',
    'C': '',
  };
  final csr = X509Utils.generateRsaCsrPem(dn, privateKey, publicKey);
  return SecurityContextResult(
    privateKey: CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(privateKey),
    publicKey: CryptoUtils.encodeRSAPublicKeyToPemPkcs1(publicKey),
    certificate:
        X509Utils.generateSelfSignedCertificate(keyPair.privateKey, csr, 1),
  );
}
