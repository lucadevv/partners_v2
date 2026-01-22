import 'package:flutter_test/flutter_test.dart';
import 'package:partners/core/utils/validations/register_response_validation_error.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';

void main() {
  group('RegisterResponseEntity', () {
    group('validate', () {
      test('debe retornar lista vacía cuando la entidad es válida', () {
        const entity = RegisterResponseEntity(
          nombres: 'Juan',
          apellidos: 'Pérez',
        );

        final errors = entity.validate();

        expect(errors, isEmpty);
      });

      test('debe retornar error cuando nombres está vacío', () {
        const entity = RegisterResponseEntity(
          nombres: '',
          apellidos: 'Pérez',
        );

        final errors = entity.validate();

        expect(errors, contains(RegisterResponseValidationError.namesEmpty));
      });

      test('debe retornar error cuando nombres solo tiene espacios', () {
        const entity = RegisterResponseEntity(
          nombres: '   ',
          apellidos: 'Pérez',
        );

        final errors = entity.validate();

        expect(errors, contains(RegisterResponseValidationError.namesEmpty));
      });

      test('debe retornar error cuando apellidos está vacío', () {
        const entity = RegisterResponseEntity(
          nombres: 'Juan',
          apellidos: '',
        );

        final errors = entity.validate();

        expect(errors, contains(RegisterResponseValidationError.lastNamesEmpty));
      });

      test('debe retornar error cuando apellidos solo tiene espacios', () {
        const entity = RegisterResponseEntity(
          nombres: 'Juan',
          apellidos: '   ',
        );

        final errors = entity.validate();

        expect(errors, contains(RegisterResponseValidationError.lastNamesEmpty));
      });

      test('debe retornar múltiples errores cuando nombres y apellidos están vacíos', () {
        const entity = RegisterResponseEntity(
          nombres: '',
          apellidos: '',
        );

        final errors = entity.validate();

        expect(errors.length, greaterThan(1));
        expect(errors, contains(RegisterResponseValidationError.namesEmpty));
        expect(errors, contains(RegisterResponseValidationError.lastNamesEmpty));
      });

      test('debe validar correctamente con nombres y apellidos con espacios al inicio y final', () {
        const entity = RegisterResponseEntity(
          nombres: '  Juan  ',
          apellidos: '  Pérez  ',
        );

        final errors = entity.validate();

        expect(errors, isEmpty);
      });
    });

    group('isValid', () {
      test('debe retornar true cuando la entidad es válida', () {
        const entity = RegisterResponseEntity(
          nombres: 'Juan',
          apellidos: 'Pérez',
        );

        final result = entity.isValid();

        expect(result, isTrue);
      });

      test('debe retornar false cuando la entidad tiene errores', () {
        const entity = RegisterResponseEntity(
          nombres: '',
          apellidos: 'Pérez',
        );

        final result = entity.isValid();

        expect(result, isFalse);
      });
    });
  });
}
