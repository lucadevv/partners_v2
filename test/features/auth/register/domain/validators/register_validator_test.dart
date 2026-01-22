import 'package:flutter_test/flutter_test.dart';
import 'package:partners/core/utils/validations/register_validation_error.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

void main() {
  group('RegisterEntity', () {
    group('validate', () {
      test('debe retornar lista vacía cuando la entidad es válida', () {
        const entity = RegisterEntity(
          tipoComercio: TipoComercio.ruc10,
          tipoDocumento: TipoDocumento.dni,
          numeroDocumento: '12345678',
        );

        final errors = entity.validate();

        expect(errors, isEmpty);
      });

      test('debe retornar error cuando tipoComercio es null', () {
        const entity = RegisterEntity(
          tipoComercio: null,
          tipoDocumento: TipoDocumento.dni,
          numeroDocumento: '12345678',
        );

        final errors = entity.validate();

        expect(errors, contains(RegisterValidationError.tipoComercioRequired));
      });

      test('debe retornar error cuando tipoDocumento es null', () {
        const entity = RegisterEntity(
          tipoComercio: TipoComercio.ruc10,
          tipoDocumento: null,
          numeroDocumento: '12345678',
        );

        final errors = entity.validate();

        expect(errors, contains(RegisterValidationError.tipoDocumentoRequired));
      });

      test('debe retornar error cuando numeroDocumento es null', () {
        const entity = RegisterEntity(
          tipoComercio: TipoComercio.ruc10,
          tipoDocumento: TipoDocumento.dni,
          numeroDocumento: null,
        );

        final errors = entity.validate();

        expect(
          errors,
          contains(RegisterValidationError.numeroDocumentoRequired),
        );
      });

      test(
        'debe retornar error cuando numeroDocumento tiene formato inválido (menos de 8 dígitos)',
        () {
          const entity = RegisterEntity(
            tipoComercio: TipoComercio.ruc10,
            tipoDocumento: TipoDocumento.dni,
            numeroDocumento: '1234567',
          );

          final errors = entity.validate();

          expect(
            errors,
            contains(RegisterValidationError.numeroDocumentoInvalid),
          );
        },
      );

      test(
        'debe retornar error cuando numeroDocumento tiene formato inválido (más de 8 dígitos)',
        () {
          const entity = RegisterEntity(
            tipoComercio: TipoComercio.ruc10,
            tipoDocumento: TipoDocumento.dni,
            numeroDocumento: '123456789',
          );

          final errors = entity.validate();

          expect(
            errors,
            contains(RegisterValidationError.numeroDocumentoInvalid),
          );
        },
      );

      test('debe retornar múltiples errores cuando faltan varios campos', () {
        const entity = RegisterEntity(
          tipoComercio: null,
          tipoDocumento: null,
          numeroDocumento: null,
        );

        final errors = entity.validate();

        expect(errors.length, greaterThan(1));
        expect(errors, contains(RegisterValidationError.tipoComercioRequired));
        expect(errors, contains(RegisterValidationError.tipoDocumentoRequired));
        expect(
          errors,
          contains(RegisterValidationError.numeroDocumentoRequired),
        );
      });

      test('debe validar correctamente con RUC 20 y CE', () {
        const entity = RegisterEntity(
          tipoComercio: TipoComercio.ruc20,
          tipoDocumento: TipoDocumento.ce,
          numeroDocumento: '12345678',
        );

        final errors = entity.validate();

        expect(errors, isEmpty);
      });
    });

    group('isValid', () {
      test('debe retornar true cuando la entidad es válida', () {
        const entity = RegisterEntity(
          tipoComercio: TipoComercio.ruc10,
          tipoDocumento: TipoDocumento.dni,
          numeroDocumento: '12345678',
        );

        final result = entity.isValid();

        expect(result, isTrue);
      });

      test('debe retornar false cuando la entidad tiene errores', () {
        const entity = RegisterEntity(
          tipoComercio: null,
          tipoDocumento: TipoDocumento.dni,
          numeroDocumento: '12345678',
        );

        final result = entity.isValid();

        expect(result, isFalse);
      });
    });
  });
}
