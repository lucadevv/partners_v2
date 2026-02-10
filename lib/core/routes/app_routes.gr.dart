// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i25;
import 'package:flutter/material.dart' as _i26;
import 'package:partners/core/routes/shell/app_shell_route.dart' as _i1;
import 'package:partners/core/routes/shell/cuenta_shell.dart' as _i4;
import 'package:partners/core/routes/shell/main_tabs_route.dart' as _i10;
import 'package:partners/core/routes/shell/pagar_shell.dart' as _i13;
import 'package:partners/core/routes/shell/para_ti_shell.dart' as _i15;
import 'package:partners/core/routes/shell/productos_shell.dart' as _i17;
import 'package:partners/core/utils/enums/enums.dart' as _i27;
import 'package:partners/features/auth/business_validation/presentation/screens/business_validation_screen.dart'
    as _i2;
import 'package:partners/features/auth/document_scan/presentation/screens/document_scan_screen.dart'
    as _i6;
import 'package:partners/features/auth/forgot_password/presentation/screens/forgot_password_screen.dart'
    as _i7;
import 'package:partners/features/auth/login/presentation/login_screen.dart'
    as _i9;
import 'package:partners/features/auth/register/presentation/register_screen.dart'
    as _i20;
import 'package:partners/features/auth/registration_success/presentation/screens/registration_success_screen.dart'
    as _i21;
import 'package:partners/features/auth/validation/presentation/screens/validation_screen.dart'
    as _i24;
import 'package:partners/features/cuenta/presentation/screens/cuenta_screen.dart'
    as _i3;
import 'package:partners/features/dashboard/presentation/screens/dashboard_screen.dart'
    as _i5;
import 'package:partners/features/home/presentation/screens/home_screen.dart'
    as _i8;
import 'package:partners/features/menu/presentation/screens/menu_screen.dart'
    as _i11;
import 'package:partners/features/pagar/presentation/screens/pagar_screen.dart'
    as _i12;
import 'package:partners/features/para_ti/presentation/screens/para_ti_screen.dart'
    as _i14;
import 'package:partners/features/productos/presentation/screens/productos_screen.dart'
    as _i16;
import 'package:partners/features/promos/presentation/screens/promos_screen.dart'
    as _i18;
import 'package:partners/features/qr/presentation/screens/qr_screen.dart'
    as _i19;
import 'package:partners/features/splash/presentation/splash_screen.dart'
    as _i22;
import 'package:partners/features/users/presentation/screens/users_screen.dart'
    as _i23;

/// generated route for
/// [_i1.AppShellRoute]
class AppShellRoute extends _i25.PageRouteInfo<void> {
  const AppShellRoute({List<_i25.PageRouteInfo>? children})
    : super(AppShellRoute.name, initialChildren: children);

  static const String name = 'AppShellRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppShellRoute();
    },
  );
}

/// generated route for
/// [_i2.BusinessValidationScreen]
class BusinessValidationRoute extends _i25.PageRouteInfo<void> {
  const BusinessValidationRoute({List<_i25.PageRouteInfo>? children})
    : super(BusinessValidationRoute.name, initialChildren: children);

  static const String name = 'BusinessValidationRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i2.BusinessValidationScreen();
    },
  );
}

/// generated route for
/// [_i3.CuentaScreen]
class CuentaRoute extends _i25.PageRouteInfo<void> {
  const CuentaRoute({List<_i25.PageRouteInfo>? children})
    : super(CuentaRoute.name, initialChildren: children);

  static const String name = 'CuentaRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i3.CuentaScreen();
    },
  );
}

/// generated route for
/// [_i4.CuentaShell]
class CuentaShell extends _i25.PageRouteInfo<void> {
  const CuentaShell({List<_i25.PageRouteInfo>? children})
    : super(CuentaShell.name, initialChildren: children);

  static const String name = 'CuentaShell';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i4.CuentaShell();
    },
  );
}

/// generated route for
/// [_i5.DashboardScreen]
class DashboardRoute extends _i25.PageRouteInfo<void> {
  const DashboardRoute({List<_i25.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return _i25.WrappedRoute(child: const _i5.DashboardScreen());
    },
  );
}

/// generated route for
/// [_i6.DocumentScanScreen]
class DocumentScanRoute extends _i25.PageRouteInfo<DocumentScanRouteArgs> {
  DocumentScanRoute({
    _i26.Key? key,
    required _i27.RucType rucType,
    List<_i25.PageRouteInfo>? children,
  }) : super(
         DocumentScanRoute.name,
         args: DocumentScanRouteArgs(key: key, rucType: rucType),
         initialChildren: children,
       );

  static const String name = 'DocumentScanRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DocumentScanRouteArgs>();
      return _i6.DocumentScanScreen(key: args.key, rucType: args.rucType);
    },
  );
}

class DocumentScanRouteArgs {
  const DocumentScanRouteArgs({this.key, required this.rucType});

  final _i26.Key? key;

  final _i27.RucType rucType;

  @override
  String toString() {
    return 'DocumentScanRouteArgs{key: $key, rucType: $rucType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DocumentScanRouteArgs) return false;
    return key == other.key && rucType == other.rucType;
  }

  @override
  int get hashCode => key.hashCode ^ rucType.hashCode;
}

/// generated route for
/// [_i7.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i25.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i25.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i7.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i8.HomeScreen]
class HomeRoute extends _i25.PageRouteInfo<void> {
  const HomeRoute({List<_i25.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i8.HomeScreen();
    },
  );
}

/// generated route for
/// [_i9.LoginScreen]
class LoginRoute extends _i25.PageRouteInfo<void> {
  const LoginRoute({List<_i25.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i9.LoginScreen();
    },
  );
}

/// generated route for
/// [_i10.MainTabsRoute]
class MainTabsRoute extends _i25.PageRouteInfo<void> {
  const MainTabsRoute({List<_i25.PageRouteInfo>? children})
    : super(MainTabsRoute.name, initialChildren: children);

  static const String name = 'MainTabsRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i10.MainTabsRoute();
    },
  );
}

/// generated route for
/// [_i11.MenuScreen]
class MenuRoute extends _i25.PageRouteInfo<void> {
  const MenuRoute({List<_i25.PageRouteInfo>? children})
    : super(MenuRoute.name, initialChildren: children);

  static const String name = 'MenuRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i11.MenuScreen();
    },
  );
}

/// generated route for
/// [_i12.PagarScreen]
class PagarRoute extends _i25.PageRouteInfo<void> {
  const PagarRoute({List<_i25.PageRouteInfo>? children})
    : super(PagarRoute.name, initialChildren: children);

  static const String name = 'PagarRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i12.PagarScreen();
    },
  );
}

/// generated route for
/// [_i13.PagarShell]
class PagarShell extends _i25.PageRouteInfo<void> {
  const PagarShell({List<_i25.PageRouteInfo>? children})
    : super(PagarShell.name, initialChildren: children);

  static const String name = 'PagarShell';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i13.PagarShell();
    },
  );
}

/// generated route for
/// [_i14.ParaTiScreen]
class ParaTiRoute extends _i25.PageRouteInfo<void> {
  const ParaTiRoute({List<_i25.PageRouteInfo>? children})
    : super(ParaTiRoute.name, initialChildren: children);

  static const String name = 'ParaTiRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i14.ParaTiScreen();
    },
  );
}

/// generated route for
/// [_i15.ParaTiShell]
class ParaTiShell extends _i25.PageRouteInfo<void> {
  const ParaTiShell({List<_i25.PageRouteInfo>? children})
    : super(ParaTiShell.name, initialChildren: children);

  static const String name = 'ParaTiShell';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i15.ParaTiShell();
    },
  );
}

/// generated route for
/// [_i16.ProductosScreen]
class ProductosRoute extends _i25.PageRouteInfo<void> {
  const ProductosRoute({List<_i25.PageRouteInfo>? children})
    : super(ProductosRoute.name, initialChildren: children);

  static const String name = 'ProductosRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i16.ProductosScreen();
    },
  );
}

/// generated route for
/// [_i17.ProductosShell]
class ProductosShell extends _i25.PageRouteInfo<void> {
  const ProductosShell({List<_i25.PageRouteInfo>? children})
    : super(ProductosShell.name, initialChildren: children);

  static const String name = 'ProductosShell';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i17.ProductosShell();
    },
  );
}

/// generated route for
/// [_i18.PromosScreen]
class PromosRoute extends _i25.PageRouteInfo<void> {
  const PromosRoute({List<_i25.PageRouteInfo>? children})
    : super(PromosRoute.name, initialChildren: children);

  static const String name = 'PromosRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i18.PromosScreen();
    },
  );
}

/// generated route for
/// [_i19.QrScreen]
class QrRoute extends _i25.PageRouteInfo<void> {
  const QrRoute({List<_i25.PageRouteInfo>? children})
    : super(QrRoute.name, initialChildren: children);

  static const String name = 'QrRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i19.QrScreen();
    },
  );
}

/// generated route for
/// [_i20.RegisterScreen]
class RegisterRoute extends _i25.PageRouteInfo<void> {
  const RegisterRoute({List<_i25.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i20.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i21.RegistrationSuccessScreen]
class RegistrationSuccessRoute extends _i25.PageRouteInfo<void> {
  const RegistrationSuccessRoute({List<_i25.PageRouteInfo>? children})
    : super(RegistrationSuccessRoute.name, initialChildren: children);

  static const String name = 'RegistrationSuccessRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i21.RegistrationSuccessScreen();
    },
  );
}

/// generated route for
/// [_i22.SplashScreen]
class SplashRoute extends _i25.PageRouteInfo<void> {
  const SplashRoute({List<_i25.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i22.SplashScreen();
    },
  );
}

/// generated route for
/// [_i23.UsersScreen]
class UsersRoute extends _i25.PageRouteInfo<void> {
  const UsersRoute({List<_i25.PageRouteInfo>? children})
    : super(UsersRoute.name, initialChildren: children);

  static const String name = 'UsersRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      return const _i23.UsersScreen();
    },
  );
}

/// generated route for
/// [_i24.ValidationScreen]
class ValidationRoute extends _i25.PageRouteInfo<ValidationRouteArgs> {
  ValidationRoute({
    _i26.Key? key,
    required _i27.RucType rucType,
    List<_i25.PageRouteInfo>? children,
  }) : super(
         ValidationRoute.name,
         args: ValidationRouteArgs(key: key, rucType: rucType),
         initialChildren: children,
       );

  static const String name = 'ValidationRoute';

  static _i25.PageInfo page = _i25.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ValidationRouteArgs>();
      return _i24.ValidationScreen(key: args.key, rucType: args.rucType);
    },
  );
}

class ValidationRouteArgs {
  const ValidationRouteArgs({this.key, required this.rucType});

  final _i26.Key? key;

  final _i27.RucType rucType;

  @override
  String toString() {
    return 'ValidationRouteArgs{key: $key, rucType: $rucType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ValidationRouteArgs) return false;
    return key == other.key && rucType == other.rucType;
  }

  @override
  int get hashCode => key.hashCode ^ rucType.hashCode;
}
