import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/transactions/data/datasource/transactions_datasource.dart';
import 'package:partners/features/transactions/data/models/transaction_model.dart';

/// Mock implementation of Transactions datasource
class MockTransactionsDatasourceImpl implements TransactionsDatasource {
  static const List<TransactionModel> _mockTransactions = [
    TransactionModel(
      id: '1',
      name: 'Karylin Moscol',
      date: '25 Jul 2025 - 16:54',
      points: 5,
    ),
    TransactionModel(
      id: '2',
      name: 'Alan Paerson',
      date: '25 Jul 2025 - 16:54',
      points: 5,
    ),
    TransactionModel(
      id: '3',
      name: 'Mariano Suquillan..',
      date: '26 Jul 2025 - 09:30',
      points: 3,
    ),
    TransactionModel(
      id: '4',
      name: 'Grace Lee',
      date: '26 Jul 2025 - 09:30',
      points: 3,
    ),
    TransactionModel(
      id: '5',
      name: 'Jasper Fenn',
      date: '26 Jul 2025 - 09:12',
      points: 4,
    ),
    TransactionModel(
      id: '6',
      name: 'Isolde Tran',
      date: '27 Jul 2025 - 11:30',
      points: -3,
    ),
    TransactionModel(
      id: '7',
      name: 'Ravi Mehta',
      date: '28 Jul 2025 - 14:45',
      points: 5,
    ),
    TransactionModel(
      id: '8',
      name: 'Elena Rodriguez',
      date: '29 Jul 2025 - 08:20',
      points: -4,
    ),
    TransactionModel(
      id: '9',
      name: 'Marcus Lang',
      date: '30 Jul 2025 - 10:05',
      points: -2,
    ),
    TransactionModel(
      id: '10',
      name: 'Aisha Patel',
      date: '31 Jul 2025 - 15:00',
      points: -5,
    ),
    TransactionModel(
      id: '11',
      name: 'Theo Chen',
      date: '01 Mar 2025 - 17:30',
      points: -3,
    ),
    TransactionModel(
      id: '12',
      name: 'Nia Johnson',
      date: '02 Ene 2025 - 12:15',
      points: 4,
    ),
    TransactionModel(
      id: '13',
      name: "Liam O'Reilly",
      date: '03 Abri 2025 - 19:45',
      points: -10,
    ),
    TransactionModel(
      id: '14',
      name: 'Sofia Kim',
      date: '04 Ago 2025 - 13:10',
      points: 5,
    ),
    TransactionModel(
      id: '15',
      name: 'Victor Hu',
      date: '05 Jun 2025 - 16:00',
      points: 4,
    ),
  ];

  @override
  Future<Either<AppException, List<TransactionModel>>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Right(_mockTransactions);
  }
}
