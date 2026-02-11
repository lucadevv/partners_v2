import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/home/data/datasource/home_datasource.dart';
import 'package:partners/features/home/data/models/smart_card_model.dart';
import 'package:partners/features/home/data/models/smart_tool_model.dart';
import 'package:partners/features/home/data/models/transaction_model.dart';

/// Mock implementation of Home datasource
/// Follows mock data pattern for development and testing
class MockHomeDatasourceImpl implements HomeDatasource {
  // Mock data for Smart Tools
  // Textos en español según el diseño
  final List<SmartToolModel> _mockSmartTools = const [
    SmartToolModel(
      id: '1',
      title: 'Ver mis\nsucursales',
      iconName: 'store',
      route: '/branches',
    ),
    SmartToolModel(
      id: '2',
      title: 'Comprar\nPuntos',
      iconName: 'money',
      route: '/buy-points',
    ),
    SmartToolModel(
      id: '3',
      title: 'Emitir\nPuntos',
      iconName: 'arrow-up',
      route: '/issue-points',
    ),
    SmartToolModel(
      id: '4',
      title: 'Canjear\nPuntos',
      iconName: 'coin',
      route: '/redeem-points',
    ),
    SmartToolModel(
      id: '5',
      title: 'Premios y\nCupones',
      iconName: 'gift',
      route: '/prizes',
    ),
    SmartToolModel(
      id: '6',
      title: 'Mis\nAnalíticas',
      iconName: 'analytics',
      route: '/analytics',
    ),
    SmartToolModel(
      id: '7',
      title: 'Ver mi\nSmart Card',
      iconName: 'credit-card',
      route: '/smart-card',
      backgroundColor: 0xFFFFFFFF, // Fondo blanco según diseño
    ),
    SmartToolModel(
      id: '8',
      title: 'Ver\nMás',
      iconName: 'more',
      route: '/more',
      backgroundColor: 0xFFFFFFFF, // Fondo blanco según diseño
    ),
  ];

  // Mock data for Smart Card
  static const SmartCardModel _mockSmartCard = SmartCardModel(
    cardNumber: '5106',
    pointsBalance: 5106,
    pointsLabel: 'PS',
  );

  // Mock data for Transactions
  final List<TransactionModel> _mockTransactions = [
    TransactionModel(
      id: '1',
      merchantName: 'Tonyjaxxmusic',
      date: DateTime(2025, 7, 25, 16, 54),
      points: 5,
    ),
    TransactionModel(
      id: '2',
      merchantName: 'Tonyjaxxmusic',
      date: DateTime(2025, 7, 25, 16, 54),
      points: 5,
    ),
    TransactionModel(
      id: '3',
      merchantName: 'Tonyjaxxmusic',
      date: DateTime(2025, 7, 25, 16, 54),
      points: 5,
    ),
  ];

  @override
  Future<Either<AppException, List<SmartToolModel>>> getSmartTools() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(_mockSmartTools);
  }

  @override
  Future<Either<AppException, SmartCardModel>> getSmartCard() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_mockSmartCard);
  }

  @override
  Future<Either<AppException, List<TransactionModel>>>
  getRecentTransactions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Right(_mockTransactions);
  }
}
