import 'package:flutter_test/flutter_test.dart';
import 'package:partners/core/utils/validations/dni_validator.dart';

void main() {
  group('DniValidator', () {
    group('isValidDni', () {
      test('debe retornar true cuando el DNI tiene 8 dígitos válidos', () {
        // Arrange
        const numeroDocumento = '12345678';

        // Act
        final result = DniValidator.isValidDni(numeroDocumento);

        // Assert
        expect(result, isTrue);
      });

      test('debe retornar false cuando el DNI es null', () {
        // Arrange
        const String? numeroDocumento = null;

        // Act
        final result = DniValidator.isValidDni(numeroDocumento);

        // Assert
        expect(result, isFalse);
      });

      test('debe retornar false cuando el DNI es vacío', () {
        // Arrange
        const numeroDocumento = '';

        // Act
        final result = DniValidator.isValidDni(numeroDocumento);

        // Assert
        expect(result, isFalse);
      });

      test('debe retornar false cuando el DNI tiene menos de 8 dígitos', () {
        // Arrange
        const numeroDocumento = '1234567';

        // Act
        final result = DniValidator.isValidDni(numeroDocumento);

        // Assert
        expect(result, isFalse);
      });

      test('debe retornar false cuando el DNI tiene más de 8 dígitos', () {
        // Arrange
        const numeroDocumento = '123456789';

        // Act
        final result = DniValidator.isValidDni(numeroDocumento);

        // Assert
        expect(result, isFalse);
      });

      test('debe retornar true cuando el DNI tiene exactamente 8 dígitos con ceros al inicio', () {
        // Arrange
        const numeroDocumento = '01234567';

        // Act
        final result = DniValidator.isValidDni(numeroDocumento);

        // Assert
        expect(result, isTrue);
      });

      test('debe retornar false cuando el DNI contiene caracteres no numéricos', () {
        // Arrange
        const numeroDocumento = '1234567a';

        // Act
        final result = DniValidator.isValidDni(numeroDocumento);

        // Assert
        expect(result, isFalse);
      });
    });

    group('isNotEmpty', () {
      test('debe retornar true cuando el número de documento no es null ni vacío', () {
        // Arrange
        const numeroDocumento = '12345678';

        // Act
        final result = DniValidator.isNotEmpty(numeroDocumento);

        // Assert
        expect(result, isTrue);
      });

      test('debe retornar false cuando el número de documento es null', () {
        // Arrange
        const String? numeroDocumento = null;

        // Act
        final result = DniValidator.isNotEmpty(numeroDocumento);

        // Assert
        expect(result, isFalse);
      });

      test('debe retornar false cuando el número de documento es vacío', () {
        // Arrange
        const numeroDocumento = '';

        // Act
        final result = DniValidator.isNotEmpty(numeroDocumento);

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
