---
name: partners-transactions
description: >
  Transaction system patterns for Partners app - points calculation, transaction history, payment flows.
  Trigger: Creating transaction features, point calculations, transaction history.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [transactions]
  auto_invoke:
    - "Creating new transaction types"
    - "Points system implementation"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Transaction System Overview

Partners app implements a comprehensive points-based transaction system with issuance, redemption, and tracking.

## Core Transaction Types

### Transaction Types
- **Debit**: Points issued to customers (Issue Points)
- **Credit**: Points redeemed by customers (Redeem Points)
- **Transfer**: Points transferred between accounts
- **Adjustment**: Manual adjustments by administrators

### Transaction Statuses
- **Pending**: Transaction initiated but not completed
- **Completed**: Transaction successfully processed
- **Failed**: Transaction failed during processing
- **Reversed**: Transaction reversed/cancelled

## Domain Entities

### Transaction Entity
```dart
class Transaction extends Entity {
  final String customerId;
  final String customerName;
  final int points;
  final String description;
  final TransactionType type;
  final TransactionStatus status;
  final String? branchId;
  final String? employeeId;
  final String? referenceNumber;
  final DateTime? completedAt;
  final Map<String, dynamic>? metadata;
  
  const Transaction({
    required String id,
    required this.customerId,
    required this.customerName,
    required this.points,
    required this.description,
    required this.type,
    required this.status,
    this.branchId,
    this.employeeId,
    this.referenceNumber,
    this.completedAt,
    this.metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isDebit => type == TransactionType.debit;
  bool get isCredit => type == TransactionType.credit;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isPending => status == TransactionStatus.pending;
  
  String get formattedPoints {
    final prefix = isDebit ? '+' : '-';
    return '$prefix${points.abs()} puntos';
  }
  
  String get typeDisplay {
    switch (type) {
      case TransactionType.debit:
        return 'Emisión';
      case TransactionType.credit:
        return 'Canje';
      case TransactionType.transfer:
        return 'Transferencia';
      case TransactionType.adjustment:
        return 'Ajuste';
    }
  }
  
  String get statusDisplay {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pendiente';
      case TransactionStatus.completed:
        return 'Completado';
      case TransactionStatus.failed:
        return 'Fallido';
      case TransactionStatus.reversed:
        return 'Revertido';
    }
  }
}
```

### Points Balance Entity
```dart
class PointsBalance extends Entity {
  final String customerId;
  final String customerName;
  final int availablePoints;
  final int issuedPoints;
  final int redeemedPoints;
  final int adjustedPoints;
  final DateTime lastUpdated;
  
  const PointsBalance({
    required String id,
    required this.customerId,
    required this.customerName,
    required this.availablePoints,
    required this.issuedPoints,
    required this.redeemedPoints,
    required this.adjustedPoints,
    required this.lastUpdated,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: lastUpdated, updatedAt: updatedAt);
  
  // Business logic
  bool get hasBalance => availablePoints > 0;
  int get totalPointsMovement => issuedPoints + redeemedPoints + adjustedPoints;
  String get formattedBalance => '$availablePoints puntos';
}
```

## Use Cases

### Issue Points Use Case
```dart
class IssuePointsUseCase implements UseCase<Transaction, IssuePointsParams> {
  final TransactionRepository _transactionRepository;
  final PointsBalanceRepository _balanceRepository;
  final NotificationRepository _notificationRepository;
  
  IssuePointsUseCase(
    this._transactionRepository,
    this._balanceRepository,
    this._notificationRepository,
  );
  
  @override
  Future<Either<TransactionFailure, Transaction>> call(IssuePointsParams params) async {
    // Business validation
    if (params.points <= 0) {
      return Left(TransactionFailure.invalidAmount);
    }
    
    if (params.points > 10000) {  // Daily limit
      return Left(TransactionFailure.dailyLimitExceeded);
    }
    
    if (params.customerName.trim().isEmpty) {
      return Left(TransactionFailure.invalidCustomer);
    }
    
    if (params.branchId == null || params.branchId!.isEmpty) {
      return Left(TransactionFailure.branchRequired);
    }
    
    // Check employee permissions
    final employeeBalance = await _balanceRepository.getEmployeeBalance(params.employeeId);
    if (employeeBalance == null || !employeeBalance!.canIssuePoints) {
      return Left(TransactionFailure.insufficientPermissions);
    }
    
    try {
      // Create transaction
      final transaction = Transaction(
        id: _generateTransactionId(),
        customerId: params.customerId,
        customerName: params.customerName,
        points: params.points,
        description: params.description ?? 'Emisión de puntos',
        type: TransactionType.debit,
        status: TransactionStatus.pending,
        branchId: params.branchId,
        employeeId: params.employeeId,
        referenceNumber: _generateReferenceNumber(),
        metadata: params.metadata,
        createdAt: DateTime.now(),
      );
      
      final createdTransaction = await _transactionRepository.createTransaction(transaction);
      
      // Update customer balance
      await _balanceRepository.issuePoints(
        customerId: params.customerId,
        points: params.points,
      );
      
      // Update employee issued points
      await _balanceRepository.updateEmployeeIssuedPoints(
        employeeId: params.employeeId,
        points: params.points,
      );
      
      // Send notification
      await _notificationRepository.sendPointsIssuedNotification(
        customerId: params.customerId,
        customerName: params.customerName,
        points: params.points,
        transactionId: createdTransaction.id,
      );
      
      return Right(createdTransaction);
    } catch (e) {
      return Left(TransactionFailure.custom('Failed to issue points: $e'));
    }
  }
  
  String _generateTransactionId() {
    return 'TRX_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }
  
  String _generateReferenceNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    return '$timestamp-$random';
  }
}
```

### Redeem Points Use Case
```dart
class RedeemPointsUseCase implements UseCase<Transaction, RedeemPointsParams> {
  final TransactionRepository _transactionRepository;
  final PointsBalanceRepository _balanceRepository;
  final ProductRepository _productRepository;
  
  RedeemPointsUseCase(
    this._transactionRepository,
    this._balanceRepository,
    this._productRepository,
  );
  
  @override
  Future<Either<TransactionFailure, Transaction>> call(RedeemPointsParams params) async {
    // Validate product exists and has enough points
    final product = await _productRepository.getProductById(params.productId);
    if (product == null) {
      return Left(TransactionFailure.productNotFound);
    }
    
    // Check customer balance
    final customerBalance = await _balanceRepository.getCustomerBalance(params.customerId);
    if (customerBalance == null) {
      return Left(TransactionFailure.customerNotFound);
    }
    
    if (customerBalance.availablePoints < product.pointsRequired) {
      return Left(TransactionFailure.insufficientPoints);
    }
    
    if (product.pointsRequired > customerBalance.availablePoints) {
      return Left(TransactionFailure.insufficientPoints);
    }
    
    try {
      // Create transaction
      final transaction = Transaction(
        id: _generateTransactionId(),
        customerId: params.customerId,
        customerName: customerBalance.customerName,
        points: product.pointsRequired,
        description: 'Canje: ${product.name}',
        type: TransactionType.credit,
        status: TransactionStatus.pending,
        branchId: params.branchId,
        employeeId: params.employeeId,
        referenceNumber: _generateReferenceNumber(),
        metadata: {
          'productId': product.id,
          'productName': product.name,
          'originalPrice': product.price,
          'pointsUsed': product.pointsRequired,
        },
        createdAt: DateTime.now(),
      );
      
      final createdTransaction = await _transactionRepository.createTransaction(transaction);
      
      // Update customer balance
      await _balanceRepository.redeemPoints(
        customerId: params.customerId,
        points: product.pointsRequired,
      );
      
      // Update product inventory
      await _productRepository.redeemProduct(
        productId: product.id,
        quantity: params.quantity ?? 1,
      );
      
      return Right(createdTransaction);
    } catch (e) {
      return Left(TransactionFailure.custom('Failed to redeem points: $e'));
    }
  }
}
```

### Get Transaction History Use Case
```dart
class GetTransactionHistoryUseCase implements UseCase<TransactionHistoryResult, TransactionHistoryParams> {
  final TransactionRepository _transactionRepository;
  
  GetTransactionHistoryUseCase(this._transactionRepository);
  
  @override
  Future<Either<TransactionFailure, TransactionHistoryResult>> call(TransactionHistoryParams params) async {
    try {
      // Get transactions with filters
      final transactions = await _transactionRepository.getTransactions(
        customerId: params.customerId,
        branchId: params.branchId,
        startDate: params.startDate,
        endDate: params.endDate,
        type: params.type,
        status: params.status,
        page: params.page,
        limit: params.limit,
      );
      
      // Calculate summary statistics
      final totalIssued = transactions
          .where((t) => t.type == TransactionType.debit && t.isCompleted)
          .fold(0, (sum, t) => sum + t.points);
      
      final totalRedeemed = transactions
          .where((t) => t.type == TransactionType.credit && t.isCompleted)
          .fold(0, (sum, t) => sum + t.points);
      
      final netPoints = totalIssued - totalRedeemed;
      
      return Right(TransactionHistoryResult(
        transactions: transactions,
        totalCount: transactions.length,
        totalIssued: totalIssued,
        totalRedeemed: totalRedeemed,
        netPoints: netPoints,
        hasMore: transactions.length == params.limit,
      ));
    } catch (e) {
      return Left(TransactionFailure.custom('Failed to get transaction history: $e'));
    }
  }
}
```

## Repository Patterns

### Transaction Repository Interface
```dart
abstract class TransactionRepository {
  Future<Either<TransactionFailure, Transaction>> createTransaction(Transaction transaction);
  Future<Either<TransactionFailure, List<Transaction>>> getTransactions({
    String? customerId,
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    TransactionStatus? status,
    int page = 1,
    int limit = 20,
  });
  
  Future<Either<TransactionFailure, Transaction?>> getTransactionById(String id);
  Future<Either<TransactionFailure, void>> updateTransactionStatus({
    required String transactionId,
    required TransactionStatus status,
    String? reason,
  });
  
  Future<Either<TransactionFailure, List<Transaction>>> getRecentTransactions({
    String? customerId,
    String? branchId,
    int limit = 10,
  });
  
  Future<Either<TransactionFailure, TransactionSummary>> getTransactionSummary({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  });
}
```

### Points Balance Repository Interface
```dart
abstract class PointsBalanceRepository {
  Future<Either<BalanceFailure, PointsBalance>> getCustomerBalance(String customerId);
  Future<Either<BalanceFailure, List<PointsBalance>>> getAllBalances();
  Future<Either<BalanceFailure, void>> issuePoints({
    required String customerId,
    required int points,
  });
  
  Future<Either<BalanceFailure, void>> redeemPoints({
    required String customerId,
    required int points,
  });
  
  Future<Either<BalanceFailure, void>> adjustPoints({
    required String customerId,
    required int points,
    required String reason,
  });
  
  Future<Either<BalanceFailure, EmployeeBalance>> getEmployeeBalance(String employeeId);
  Future<Either<BalanceFailure, void>> updateEmployeeIssuedPoints({
    required String employeeId,
    required int points,
  });
}
```

## UI Patterns

### Transaction List Widget
```dart
class TransactionListWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? error;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  
  const TransactionListWidget({
    Key? key,
    required this.transactions,
    this.isLoading = false,
    this.error,
    this.onLoadMore,
    this.hasMore = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return ErrorStateWidget(
        message: error!,
        onRetry: onLoadMore,
      );
    }
    
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            !isLoading &&
            hasMore &&
            onLoadMore != null) {
          onLoadMore!();
        }
        return false;
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: transactions.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= transactions.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          
          final transaction = transactions[index];
          return TransactionItemWidget(
            transaction: transaction,
            onTap: () => _showTransactionDetails(context, transaction),
          );
        },
      ),
    );
  }
  
  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TransactionDetailsWidget(transaction: transaction),
    );
  }
}
```

### Transaction Item Widget
```dart
class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  
  const TransactionItemWidget({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            transaction.typeDisplay,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: _getTypeColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(context),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              transaction.statusDisplay,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        transaction.customerName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        transaction.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        transaction.createdAtFormatted,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      transaction.formattedPoints,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _getPointsColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Icon(
                      Icons.visibility,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getTypeColor(BuildContext context) {
    switch (transaction.type) {
      case TransactionType.debit:
        return Theme.of(context).colorScheme.primary;
      case TransactionType.credit:
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }
  
  Color _getStatusColor(BuildContext context) {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  Color _getPointsColor(BuildContext context) {
    return transaction.isDebit 
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
  }
}
```

## Business Rules

### Points Calculation Rules
```dart
class PointsCalculator {
  static const int dailyIssuanceLimit = 10000;
  static const int monthlyRedemptionLimit = 50000;
  static const double redemptionRate = 0.01; // 1 punto = S/0.01
  
  static int calculatePointsFromAmount(double amount) {
    return (amount / redemptionRate).round();
  }
  
  static double calculateAmountFromPoints(int points) {
    return points * redemptionRate;
  }
  
  static bool isValidIssuanceAmount(int points, String employeeId) {
    return points > 0 && points <= dailyIssuanceLimit;
  }
  
  static bool isValidRedemptionAmount(int points, int availablePoints) {
    return points > 0 && 
           points <= availablePoints && 
           points <= monthlyRedemptionLimit;
  }
}
```

### Transaction Validation Rules
```dart
class TransactionValidator {
  static String? validateTransactionData({
    required String customerName,
    required int points,
    required String description,
    TransactionType? type,
  }) {
    // Customer name validation
    if (customerName.trim().isEmpty) {
      return 'El nombre del cliente es requerido';
    }
    
    if (customerName.trim().length < 3) {
      return 'El nombre del cliente debe tener al menos 3 caracteres';
    }
    
    // Points validation
    if (points <= 0) {
      return 'Los puntos deben ser mayores a 0';
    }
    
    if (points > 50000) {
      return 'Los puntos no pueden exceder 50,000';
    }
    
    // Description validation
    if (description.trim().isEmpty) {
      return 'La descripción es requerida';
    }
    
    if (description.trim().length > 200) {
      return 'La descripción no puede exceder 200 caracteres';
    }
    
    // Type-specific validation
    if (type != null) {
      switch (type!) {
        case TransactionType.debit:
          return _validateDebitTransaction(points);
        case TransactionType.credit:
          return _validateCreditTransaction(points);
      }
    }
    
    return null;
  }
  
  static String? _validateDebitTransaction(int points) {
    if (points > PointsCalculator.dailyIssuanceLimit) {
      return 'Los puntos emitidos no pueden exceder el límite diario';
    }
    return null;
  }
  
  static String? _validateCreditTransaction(int points) {
    if (points > PointsCalculator.monthlyRedemptionLimit) {
      return 'Los puntos canjeados no pueden exceder el límite mensual';
    }
    return null;
  }
}
```

## Related Skills

- `partners` - Project overview and navigation
- `partners-domain` - Transaction entities and use cases
- `partners-data` - Transaction data sources and models
- `partners-ui` - Transaction UI patterns
- `partners-testing` - Transaction testing
- `partners-rbac` - Transaction permissions
- `state-management` - Transaction BLoC/Cubit patterns