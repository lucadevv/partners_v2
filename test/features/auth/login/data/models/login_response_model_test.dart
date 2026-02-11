import 'package:flutter_test/flutter_test.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/features/auth/login/data/models/login_response_model.dart';

void main() {
  group('LoginResponseModel.fromJson', () {
    test('parsea formato nuevo del backend (snake_case, role array)', () {
      final json = {
        'access_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        'refresh_token':
            '019c4e2c-cf32-726b-bff3-f8f65b0a0a8f|eN7i9q9j5M1bz54HeyoaZdDQQ8m00wHMdNyKRE2H0973d352',
        'role': ['superadmin'],
      };

      final model = LoginResponseModel.fromJson(json);

      expect(model.accessToken, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
      expect(model.refreshToken, contains('019c4e2c-cf32-726b'));
      expect(model.user.role, UserRole.superadmin);
      expect(model.user.id, '');
      expect(model.user.email, '');
      expect(model.user.name, '');
    });

    test('parsea role con primer elemento y mapea a UserRole', () {
      final json = {
        'access_token': 'token',
        'refresh_token': 'refresh',
        'role': ['administrator'],
      };

      final model = LoginResponseModel.fromJson(json);

      expect(model.user.role, UserRole.administrator);
    });

    test('parsea formato legacy (camelCase, user object)', () {
      final json = {
        'accessToken': 'legacy_token',
        'refreshToken': 'legacy_refresh',
        'user': {
          'id': '1',
          'email': 'test@test.com',
          'name': 'Test User',
          'role': 'waiter_cashier',
        },
      };

      final model = LoginResponseModel.fromJson(json);

      expect(model.accessToken, 'legacy_token');
      expect(model.refreshToken, 'legacy_refresh');
      expect(model.user.id, '1');
      expect(model.user.email, 'test@test.com');
      expect(model.user.name, 'Test User');
      expect(model.user.role, UserRole.waiterCashier);
    });
  });
}
