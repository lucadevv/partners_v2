import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/data/datasource/branches_datasource.dart';
import 'package:partners/features/branches/data/models/branch_model.dart';

/// Mock implementation of Branches datasource
/// Follows mock data pattern for development and testing
class MockBranchesDatasourceImpl implements BranchesDatasource {
  // Mock data for Branches
  // Datos movidos desde branches_screen.dart para seguir Clean Architecture
  final List<BranchModel> _mockBranches = const [
    BranchModel(
      id: '1',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
    BranchModel(
      id: '2',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
    BranchModel(
      id: '3',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
    BranchModel(
      id: '4',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
  ];

  @override
  Future<Either<AppException, List<BranchModel>>> getBranches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(_mockBranches);
  }
}
