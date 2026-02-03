# ☕ Clean Architecture + SOLID: Coffee Shop App

## 📋 Tabla de Contenidos
1. [Introducción](#introducción)
2. [Diagrama de Clean Architecture](#diagrama-de-clean-architecture)
3. [Estructura de Carpetas](#estructura-de-carpetas)
4. [Aplicación de SOLID por Capa](#aplicación-de-solid-por-capa)
5. [Flujo de Datos Completo](#flujo-de-datos-completo)
6. [Ejemplos de Código por Capa](#ejemplos-de-código-por-capa)
7. [Ventajas de esta Arquitectura](#ventajas-de-esta-arquitectura)

---

## 🎯 Introducción

Este documento muestra cómo estructurar el ejemplo de la **Coffee Shop App** del artículo SOLID usando **Clean Architecture** en Flutter. La combinación de Clean Architecture + SOLID crea código mantenible, testeable y escalable.

### ¿Por qué Clean Architecture + SOLID?

- **Clean Architecture**: Separa el código en capas independientes (Domain, Data, Presentation)
- **SOLID**: Asegura que cada componente tenga una responsabilidad clara y sea extensible
- **Juntos**: Crean una base sólida para aplicaciones que crecen sin volverse un caos

---

## 🏗️ Diagrama de Clean Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│                    (UI, Widgets, State Management)               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐  ┌──────────────────┐                  │
│  │ CoffeeOrderScreen │  │ PaymentScreen     │                  │
│  │ (Widget)          │  │ (Widget)          │                  │
│  └────────┬─────────┘  └────────┬─────────┘                  │
│           │                      │                              │
│           ▼                      ▼                              │
│  ┌──────────────────┐  ┌──────────────────┐                  │
│  │ OrderCubit       │  │ PaymentCubit     │                  │
│  │ (BLoC)           │  │ (BLoC)           │                  │
│  └────────┬─────────┘  └────────┬─────────┘                  │
│           │                      │                              │
│           └──────────┬────────────┘                              │
│                      ▼                                           │
│              ┌──────────────────┐                              │
│              │ Use Cases         │                              │
│              │ (Domain Layer)    │                              │
│              └──────────────────┘                              │
│                                                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                            │
│              (Business Logic, Entities, Use Cases)              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    USE CASES                              │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  • PlaceOrderUsecase                                      │ │
│  │  • CalculatePriceUsecase                                 │ │
│  │  • ProcessPaymentUsecase                                  │ │
│  │  • SendConfirmationUsecase                               │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    ENTITIES                               │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  • Order                                                  │ │
│  │  • MenuItem                                               │ │
│  │  • Payment                                                │ │
│  │  • Customer                                               │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    REPOSITORIES (Interfaces)             │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  • MenuRepository                                         │ │
│  │  • OrderRepository                                        │ │
│  │  • PaymentRepository                                      │ │
│  │  • EmailRepository                                        │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    VALIDATORS                            │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  • EmailValidator                                         │ │
│  │  • PaymentValidator                                       │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                             │
│        (Repositories, DataSources, Models, Mappers)            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              REPOSITORY IMPLEMENTATIONS                    │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  • MenuRepositoryImpl                                     │ │
│  │  • OrderRepositoryImpl                                    │ │
│  │  • PaymentRepositoryImpl                                  │ │
│  │  • EmailRepositoryImpl                                    │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    DATA SOURCES                           │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  • MenuDatasource (API)                                   │ │
│  │  • OrderDatasource (Local DB)                             │ │
│  │  • PaymentDatasource (Payment Gateway)                    │ │
│  │  • EmailDatasource (Email Service)                        │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                    MODELS & MAPPERS                       │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  • MenuModel, OrderModel, PaymentModel                   │ │
│  │  • MenuMapper, OrderMapper, PaymentMapper                │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Estructura de Carpetas

```
lib/
├── core/                           # Código compartido
│   ├── config/
│   │   └── app_config.dart
│   ├── injection/
│   │   └── app_injection.dart
│   ├── services/
│   │   ├── network/
│   │   │   ├── api_services.dart          # Interfaz
│   │   │   └── dio_services_impl.dart     # Implementación
│   │   └── database/
│   │       └── local_database.dart
│   ├── utils/
│   │   ├── exceptions/
│   │   │   ├── app_exceptions.dart
│   │   │   └── exception_handler.dart
│   │   └── validators/
│   │       └── email_validator.dart
│   └── theme/
│       └── app_theme.dart
│
└── features/
    └── coffee_order/               # Feature: Ordenar Café
        ├── data/
        │   ├── datasource/
        │   │   ├── menu_datasource.dart           # Interfaz
        │   │   ├── order_datasource.dart          # Interfaz
        │   │   ├── payment_datasource.dart        # Interfaz
        │   │   ├── email_datasource.dart          # Interfaz
        │   │   ├── ntw_menu_datasource_impl.dart  # API
        │   │   ├── local_order_datasource_impl.dart # DB
        │   │   ├── ntw_payment_datasource_impl.dart # Gateway
        │   │   └── ntw_email_datasource_impl.dart # Email
        │   ├── models/
        │   │   ├── menu_model.dart
        │   │   ├── order_model.dart
        │   │   └── payment_model.dart
        │   ├── mappers/
        │   │   ├── menu_mapper.dart
        │   │   ├── order_mapper.dart
        │   │   └── payment_mapper.dart
        │   └── repository/
        │       ├── menu_repository_impl.dart
        │       ├── order_repository_impl.dart
        │       ├── payment_repository_impl.dart
        │       └── email_repository_impl.dart
        │
        ├── domain/
        │   ├── entities/
        │   │   ├── order.dart
        │   │   ├── menu_item.dart
        │   │   ├── payment.dart
        │   │   └── customer.dart
        │   ├── repository/
        │   │   ├── menu_repository.dart           # Interfaz
        │   │   ├── order_repository.dart          # Interfaz
        │   │   ├── payment_repository.dart        # Interfaz
        │   │   └── email_repository.dart         # Interfaz
        │   ├── use_case/
        │   │   ├── place_order_usecase.dart
        │   │   ├── calculate_price_usecase.dart
        │   │   ├── process_payment_usecase.dart
        │   │   └── send_confirmation_usecase.dart
        │   └── validators/
        │       └── email_validator.dart
        │
        └── presentation/
            ├── cubit/
            │   ├── order_cubit.dart
            │   └── order_state.dart
            ├── screens/
            │   └── coffee_order_screen.dart
            └── widgets/
                ├── drink_selector_widget.dart
                ├── price_display_widget.dart
                └── order_button_widget.dart
    │
    └── payment/                    # Feature: Pagos
        ├── data/
        │   ├── datasource/
        │   │   ├── payment_datasource.dart
        │   │   └── ntw_payment_datasource_impl.dart
        │   ├── models/
        │   │   └── payment_model.dart
        │   ├── mappers/
        │   │   └── payment_mapper.dart
        │   └── repository/
        │       └── payment_repository_impl.dart
        │
        ├── domain/
        │   ├── entities/
        │   │   └── payment.dart
        │   ├── repository/
        │   │   └── payment_repository.dart
        │   ├── use_case/
        │   │   └── process_payment_usecase.dart
        │   └── strategies/                    # Strategy Pattern (OCP)
        │       ├── payment_strategy.dart       # Interfaz
        │       ├── cash_payment_strategy.dart
        │       ├── credit_card_payment_strategy.dart
        │       ├── mobile_wallet_payment_strategy.dart
        │       ├── gift_card_payment_strategy.dart
        │       └── loyalty_points_payment_strategy.dart
        │
        └── presentation/
            ├── cubit/
            │   ├── payment_cubit.dart
            │   └── payment_state.dart
            └── screens/
                └── payment_screen.dart
```

---

## 🎯 Aplicación de SOLID por Capa

### 1️⃣ Single Responsibility Principle (SRP)

#### ✅ Domain Layer
```dart
// Cada Use Case tiene UNA responsabilidad
class PlaceOrderUsecase {
  // Solo: Colocar una orden
}

class CalculatePriceUsecase {
  // Solo: Calcular precio
}

class ProcessPaymentUsecase {
  // Solo: Procesar pago
}
```

#### ✅ Data Layer
```dart
// Cada Repository tiene UNA responsabilidad
class MenuRepositoryImpl {
  // Solo: Obtener menú
}

class OrderRepositoryImpl {
  // Solo: Guardar/obtener órdenes
}

class PaymentRepositoryImpl {
  // Solo: Procesar pagos
}
```

#### ✅ Presentation Layer
```dart
// Widget solo maneja UI
class CoffeeOrderScreen extends StatelessWidget {
  // Solo: Renderizar UI
}

// Cubit solo maneja estado
class OrderCubit extends Cubit<OrderState> {
  // Solo: Gestionar estado de orden
}
```

---

### 2️⃣ Open/Closed Principle (OCP)

#### ✅ Strategy Pattern para Métodos de Pago
```dart
// Domain Layer - Abstracción
abstract class PaymentStrategy {
  Future<PaymentResult> process(double amount);
}

// Implementaciones (extensión sin modificar código existente)
class CashPaymentStrategy implements PaymentStrategy { ... }
class CreditCardPaymentStrategy implements PaymentStrategy { ... }
class MobileWalletPaymentStrategy implements PaymentStrategy { ... }
class GiftCardPaymentStrategy implements PaymentStrategy { ... }  // NUEVO - sin tocar código existente
class LoyaltyPointsPaymentStrategy implements PaymentStrategy { ... }  // NUEVO
```

#### ✅ Use Case cerrado para modificación, abierto para extensión
```dart
class ProcessPaymentUsecase {
  final PaymentRepository _repository;
  
  // No cambia cuando agregas nuevos métodos de pago
  Future<Either<AppException, PaymentResult>> call({
    required PaymentStrategy strategy,  // Depende de abstracción
    required double amount,
  }) {
    return await _repository.processPayment(strategy, amount);
  }
}
```

---

### 3️⃣ Liskov Substitution Principle (LSP)

#### ✅ Jerarquía de Café
```dart
// Domain Layer - Entities
abstract class Coffee {
  String name;
  void brew();
  void serve();
}

abstract class CaffeinatedCoffee extends Coffee {
  void addCaffeine();
}

class Espresso extends CaffeinatedCoffee { ... }
class Americano extends CaffeinatedCoffee { ... }
class DecafCoffee extends Coffee { ... }  // No es CaffeinatedCoffee

// Se puede sustituir Coffee por cualquier subclase
void serveCoffee(Coffee coffee) {
  coffee.brew();
  coffee.serve();
  // Funciona con Espresso, Americano, DecafCoffee
}
```

---

### 4️⃣ Interface Segregation Principle (ISP)

#### ✅ Interfaces Pequeñas y Específicas
```dart
// Domain Layer - Interfaces segregadas
abstract class MenuRepository {
  Future<Either<AppException, List<MenuItem>>> getMenu();
  Future<Either<AppException, double>> getPrice(String drink);
}

abstract class OrderRepository {
  Future<Either<AppException, void>> saveOrder(Order order);
  Future<Either<AppException, List<Order>>> getOrders();
}

abstract class PaymentRepository {
  Future<Either<AppException, PaymentResult>> processPayment(
    PaymentStrategy strategy,
    double amount,
  );
}

abstract class EmailRepository {
  Future<Either<AppException, void>> sendConfirmation(
    String email,
    Order order,
  );
}
```

#### ❌ Evitar Interfaces Gordas
```dart
// ❌ MAL: Una interfaz que hace todo
abstract class CoffeeShopRepository {
  Future<Menu> getMenu();
  Future<void> saveOrder(Order order);
  Future<PaymentResult> processPayment(Payment payment);
  Future<void> sendEmail(String email);
  Future<void> calculatePrice(double price);
  // ... 20 métodos más
}
```

---

### 5️⃣ Dependency Inversion Principle (DIP)

#### ✅ Dependencias de Abstracciones
```dart
// Domain Layer - Use Cases dependen de interfaces
class PlaceOrderUsecase {
  final MenuRepository _menuRepository;        // Interfaz, no implementación
  final OrderRepository _orderRepository;     // Interfaz, no implementación
  final EmailRepository _emailRepository;      // Interfaz, no implementación
  
  PlaceOrderUsecase({
    required MenuRepository menuRepository,
    required OrderRepository orderRepository,
    required EmailRepository emailRepository,
  }) : _menuRepository = menuRepository,
       _orderRepository = orderRepository,
       _emailRepository = emailRepository;
}

// Presentation Layer - Cubit depende de Use Cases (abstracciones)
class OrderCubit extends Cubit<OrderState> {
  final PlaceOrderUsecase _placeOrderUsecase;  // Abstracción
  final CalculatePriceUsecase _calculatePriceUsecase;  // Abstracción
  
  OrderCubit({
    required PlaceOrderUsecase placeOrderUsecase,
    required CalculatePriceUsecase calculatePriceUsecase,
  }) : _placeOrderUsecase = placeOrderUsecase,
       _calculatePriceUsecase = calculatePriceUsecase;
}
```

---

## 🔄 Flujo de Datos Completo

### Ejemplo: Colocar una Orden

```
1. USER ACTION
   └─> CoffeeOrderScreen (Widget)
       └─> Usuario presiona "Place Order"

2. PRESENTATION LAYER
   └─> OrderCubit.placeOrder()
       └─> Llama a PlaceOrderUsecase

3. DOMAIN LAYER
   └─> PlaceOrderUsecase.call()
       ├─> Valida email (EmailValidator)
       ├─> Obtiene menú (MenuRepository)
       ├─> Calcula precio (CalculatePriceUsecase)
       ├─> Guarda orden (OrderRepository)
       └─> Envía confirmación (EmailRepository)

4. DATA LAYER
   ├─> MenuRepositoryImpl
   │   └─> MenuDatasource (API)
   │       └─> MenuModel → MenuMapper → MenuItem (Entity)
   │
   ├─> OrderRepositoryImpl
   │   └─> OrderDatasource (Local DB)
   │       └─> Order (Entity) → OrderMapper → OrderModel
   │
   └─> EmailRepositoryImpl
       └─> EmailDatasource (Email Service)
           └─> Envía email

5. RESPONSE FLOW
   └─> Either<AppException, OrderResult>
       └─> OrderCubit emite estado
           └─> CoffeeOrderScreen actualiza UI
```

---

## 💻 Ejemplos de Código por Capa

### 📦 Domain Layer

#### Entities
```dart
// features/coffee_order/domain/entities/order.dart
class Order {
  final String id;
  final String customerEmail;
  final String drink;
  final double price;
  final DateTime createdAt;
  
  const Order({
    required this.id,
    required this.customerEmail,
    required this.drink,
    required this.price,
    required this.createdAt,
  });
}

// features/coffee_order/domain/entities/menu_item.dart
class MenuItem {
  final String name;
  final double price;
  final String category;
  
  const MenuItem({
    required this.name,
    required this.price,
    required this.category,
  });
}
```

#### Repository Interfaces
```dart
// features/coffee_order/domain/repository/menu_repository.dart
abstract class MenuRepository {
  Future<Either<AppException, List<MenuItem>>> getMenu();
  Future<Either<AppException, double>> getPrice(String drink);
}

// features/coffee_order/domain/repository/order_repository.dart
abstract class OrderRepository {
  Future<Either<AppException, void>> saveOrder(Order order);
  Future<Either<AppException, List<Order>>> getOrders();
}
```

#### Use Cases
```dart
// features/coffee_order/domain/use_case/place_order_usecase.dart
class PlaceOrderUsecase {
  final MenuRepository _menuRepository;
  final OrderRepository _orderRepository;
  final EmailRepository _emailRepository;
  final EmailValidator _emailValidator;
  final CalculatePriceUsecase _calculatePriceUsecase;
  
  PlaceOrderUsecase({
    required MenuRepository menuRepository,
    required OrderRepository orderRepository,
    required EmailRepository emailRepository,
    required EmailValidator emailValidator,
    required CalculatePriceUsecase calculatePriceUsecase,
  }) : _menuRepository = menuRepository,
       _orderRepository = orderRepository,
       _emailRepository = emailRepository,
       _emailValidator = emailValidator,
       _calculatePriceUsecase = calculatePriceUsecase;
  
  Future<Either<AppException, Order>> call({
    required String customerEmail,
    required String drink,
  }) async {
    // 1. Validar email (SRP: Validator tiene su responsabilidad)
    if (!_emailValidator.isValid(customerEmail)) {
      return Left(ValidationException('Invalid email'));
    }
    
    // 2. Obtener precio (SRP: CalculatePriceUsecase tiene su responsabilidad)
    final priceResult = await _calculatePriceUsecase.call(drink: drink);
    
    return priceResult.fold(
      (failure) => Left(failure),
      (price) async {
        // 3. Crear orden
        final order = Order(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerEmail: customerEmail,
          drink: drink,
          price: price,
          createdAt: DateTime.now(),
        );
        
        // 4. Guardar orden
        final saveResult = await _orderRepository.saveOrder(order);
        
        return saveResult.fold(
          (failure) => Left(failure),
          (_) async {
            // 5. Enviar confirmación
            await _emailRepository.sendConfirmation(customerEmail, order);
            return Right(order);
          },
        );
      },
    );
  }
}

// features/coffee_order/domain/use_case/calculate_price_usecase.dart
class CalculatePriceUsecase {
  final MenuRepository _menuRepository;
  final PricingService _pricingService;
  
  CalculatePriceUsecase({
    required MenuRepository menuRepository,
    required PricingService pricingService,
  }) : _menuRepository = menuRepository,
       _pricingService = pricingService;
  
  Future<Either<AppException, double>> call({
    required String drink,
  }) async {
    final menuResult = await _menuRepository.getMenu();
    
    return menuResult.fold(
      (failure) => Left(failure),
      (menu) {
        final menuItem = menu.firstWhere(
          (item) => item.name == drink,
          orElse: () => throw Exception('Drink not found'),
        );
        
        final basePrice = menuItem.price;
        final finalPrice = _pricingService.applyLoyaltyDiscount(basePrice);
        
        return Right(finalPrice);
      },
    );
  }
}
```

#### Strategy Pattern (OCP)
```dart
// features/payment/domain/strategies/payment_strategy.dart
abstract class PaymentStrategy {
  Future<PaymentResult> process(double amount);
}

// features/payment/domain/strategies/cash_payment_strategy.dart
class CashPaymentStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> process(double amount) async {
    return PaymentResult(
      success: true,
      method: 'cash',
      amount: amount,
      message: 'Received \$$amount in cash',
    );
  }
}

// features/payment/domain/strategies/credit_card_payment_strategy.dart
class CreditCardPaymentStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> process(double amount) async {
    return PaymentResult(
      success: true,
      method: 'credit_card',
      amount: amount,
      message: 'Processing \$$amount on credit card',
    );
  }
}

// NUEVO método de pago sin modificar código existente (OCP)
// features/payment/domain/strategies/gift_card_payment_strategy.dart
class GiftCardPaymentStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> process(double amount) async {
    return PaymentResult(
      success: true,
      method: 'gift_card',
      amount: amount,
      message: 'Processing \$$amount with gift card',
    );
  }
}
```

---

### 💾 Data Layer

#### Models
```dart
// features/coffee_order/data/models/menu_model.dart
class MenuModel {
  final List<Map<String, dynamic>> items;
  
  MenuModel({required this.items});
  
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'items': items,
  };
}

// features/coffee_order/data/models/order_model.dart
class OrderModel {
  final String id;
  final String customerEmail;
  final String drink;
  final double price;
  final String createdAt;
  
  OrderModel({
    required this.id,
    required this.customerEmail,
    required this.drink,
    required this.price,
    required this.createdAt,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_email': customerEmail,
    'drink': drink,
    'price': price,
    'created_at': createdAt,
  };
}
```

#### Mappers
```dart
// features/coffee_order/data/mappers/menu_mapper.dart
class MenuMapper {
  static List<MenuItem> modelToEntity(MenuModel model) {
    return model.items.map((item) {
      return MenuItem(
        name: item['name'] ?? '',
        price: (item['price'] ?? 0.0).toDouble(),
        category: item['category'] ?? '',
      );
    }).toList();
  }
}

// features/coffee_order/data/mappers/order_mapper.dart
class OrderMapper {
  static Order modelToEntity(OrderModel model) {
    return Order(
      id: model.id,
      customerEmail: model.customerEmail,
      drink: model.drink,
      price: model.price,
      createdAt: DateTime.parse(model.createdAt),
    );
  }
  
  static OrderModel entityToModel(Order entity) {
    return OrderModel(
      id: entity.id,
      customerEmail: entity.customerEmail,
      drink: entity.drink,
      price: entity.price,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
```

#### DataSources
```dart
// features/coffee_order/data/datasource/menu_datasource.dart
abstract class MenuDatasource {
  Future<Either<AppException, MenuModel>> getMenu();
}

// features/coffee_order/data/datasource/ntw_menu_datasource_impl.dart
class NtwMenuDatasourceImpl implements MenuDatasource {
  final ApiServices _apiServices;
  
  NtwMenuDatasourceImpl({required ApiServices apiServices})
    : _apiServices = apiServices;
  
  @override
  Future<Either<AppException, MenuModel>> getMenu() async {
    try {
      final response = await _apiServices.get('/menu');
      final menuModel = MenuModel.fromJson(response);
      return Right(menuModel);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}

// features/coffee_order/data/datasource/order_datasource.dart
abstract class OrderDatasource {
  Future<Either<AppException, void>> saveOrder(OrderModel order);
  Future<Either<AppException, List<OrderModel>>> getOrders();
}

// features/coffee_order/data/datasource/local_order_datasource_impl.dart
class LocalOrderDatasourceImpl implements OrderDatasource {
  final Database _database;
  
  LocalOrderDatasourceImpl({required Database database})
    : _database = database;
  
  @override
  Future<Either<AppException, void>> saveOrder(OrderModel order) async {
    try {
      await _database.insert('orders', order.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
  
  @override
  Future<Either<AppException, List<OrderModel>>> getOrders() async {
    try {
      final results = await _database.query('orders');
      final orders = results.map((row) => OrderModel(
        id: row['id'] as String,
        customerEmail: row['customer_email'] as String,
        drink: row['drink'] as String,
        price: (row['price'] as num).toDouble(),
        createdAt: row['created_at'] as String,
      )).toList();
      return Right(orders);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}
```

#### Repository Implementations
```dart
// features/coffee_order/data/repository/menu_repository_impl.dart
class MenuRepositoryImpl implements MenuRepository {
  final MenuDatasource _datasource;
  
  MenuRepositoryImpl({required MenuDatasource datasource})
    : _datasource = datasource;
  
  @override
  Future<Either<AppException, List<MenuItem>>> getMenu() async {
    final result = await _datasource.getMenu();
    return result.map((model) => MenuMapper.modelToEntity(model));
  }
  
  @override
  Future<Either<AppException, double>> getPrice(String drink) async {
    final menuResult = await getMenu();
    return menuResult.fold(
      (failure) => Left(failure),
      (menu) {
        final item = menu.firstWhere(
          (item) => item.name == drink,
          orElse: () => throw Exception('Drink not found'),
        );
        return Right(item.price);
      },
    );
  }
}

// features/coffee_order/data/repository/order_repository_impl.dart
class OrderRepositoryImpl implements OrderRepository {
  final OrderDatasource _datasource;
  
  OrderRepositoryImpl({required OrderDatasource datasource})
    : _datasource = datasource;
  
  @override
  Future<Either<AppException, void>> saveOrder(Order order) async {
    final orderModel = OrderMapper.entityToModel(order);
    return await _datasource.saveOrder(orderModel);
  }
  
  @override
  Future<Either<AppException, List<Order>>> getOrders() async {
    final result = await _datasource.getOrders();
    return result.map((models) {
      return models.map((model) => OrderMapper.modelToEntity(model)).toList();
    });
  }
}
```

---

### 🎨 Presentation Layer

#### Cubit (State Management)
```dart
// features/coffee_order/presentation/cubit/order_state.dart
class OrderState extends Equatable {
  final OrderStatus status;
  final String? selectedDrink;
  final String? customerEmail;
  final double? totalPrice;
  final String? errorMessage;
  final Order? order;
  
  const OrderState({
    this.status = OrderStatus.initial,
    this.selectedDrink,
    this.customerEmail,
    this.totalPrice,
    this.errorMessage,
    this.order,
  });
  
  OrderState copyWith({
    OrderStatus? status,
    String? selectedDrink,
    String? customerEmail,
    double? totalPrice,
    String? errorMessage,
    Order? order,
  }) {
    return OrderState(
      status: status ?? this.status,
      selectedDrink: selectedDrink ?? this.selectedDrink,
      customerEmail: customerEmail ?? this.customerEmail,
      totalPrice: totalPrice ?? this.totalPrice,
      errorMessage: errorMessage,
      order: order ?? this.order,
    );
  }
  
  @override
  List<Object?> get props => [
    status,
    selectedDrink,
    customerEmail,
    totalPrice,
    errorMessage,
    order,
  ];
}

enum OrderStatus {
  initial,
  loading,
  success,
  failure,
}

// features/coffee_order/presentation/cubit/order_cubit.dart
class OrderCubit extends Cubit<OrderState> with BaseCubitMixin {
  final PlaceOrderUsecase _placeOrderUsecase;
  final CalculatePriceUsecase _calculatePriceUsecase;
  
  OrderCubit({
    required PlaceOrderUsecase placeOrderUsecase,
    required CalculatePriceUsecase calculatePriceUsecase,
  }) : _placeOrderUsecase = placeOrderUsecase,
       _calculatePriceUsecase = calculatePriceUsecase,
       super(const OrderState());
  
  Future<void> placeOrder({
    required String customerEmail,
    required String drink,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));
    
    final result = await _placeOrderUsecase.call(
      customerEmail: customerEmail,
      drink: drink,
    );
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: OrderStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (order) {
        emit(state.copyWith(
          status: OrderStatus.success,
          order: order,
          totalPrice: order.price,
        ));
      },
    );
  }
  
  void selectDrink(String drink) {
    emit(state.copyWith(selectedDrink: drink));
  }
  
  void setCustomerEmail(String email) {
    emit(state.copyWith(customerEmail: email));
  }
}
```

#### Screen (Widget)
```dart
// features/coffee_order/presentation/screens/coffee_order_screen.dart
class CoffeeOrderScreen extends StatelessWidget {
  const CoffeeOrderScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coffee Order')),
      body: BlocProvider(
        create: (context) => OrderCubit(
          placeOrderUsecase: getIt<PlaceOrderUsecase>(),
          calculatePriceUsecase: getIt<CalculatePriceUsecase>(),
        ),
        child: const _CoffeeOrderContent(),
      ),
    );
  }
}

class _CoffeeOrderContent extends StatelessWidget {
  const _CoffeeOrderContent();
  
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final emailController = TextEditingController();
    
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
              ),
              onChanged: (value) => cubit.setCustomerEmail(value),
            ),
            DropdownButton<String>(
              hint: const Text('Select Drink'),
              value: state.selectedDrink,
              items: ['Espresso', 'Latte', 'Cappuccino']
                  .map((drink) => DropdownMenuItem(
                    value: drink,
                    child: Text(drink),
                  ))
                  .toList(),
              onChanged: (value) => cubit.selectDrink(value!),
            ),
            if (state.totalPrice != null)
              Text('Total: \$${state.totalPrice!.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: state.status == OrderStatus.loading
                  ? null
                  : () {
                      cubit.placeOrder(
                        customerEmail: state.customerEmail ?? '',
                        drink: state.selectedDrink ?? '',
                      );
                    },
              child: state.status == OrderStatus.loading
                  ? const CircularProgressIndicator()
                  : const Text('Place Order'),
            ),
            if (state.errorMessage != null)
              Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        );
      },
    );
  }
}
```

---

## ✅ Ventajas de esta Arquitectura

### 🎯 Separación de Responsabilidades
- **Domain**: Lógica de negocio pura, sin dependencias externas
- **Data**: Acceso a datos (API, DB, etc.)
- **Presentation**: UI y estado

### 🧪 Testabilidad
```dart
// Fácil de testear con mocks
test('PlaceOrderUsecase should place order successfully', () async {
  final mockMenuRepo = MockMenuRepository();
  final mockOrderRepo = MockOrderRepository();
  final mockEmailRepo = MockEmailRepository();
  
  final usecase = PlaceOrderUsecase(
    menuRepository: mockMenuRepo,
    orderRepository: mockOrderRepo,
    emailRepository: mockEmailRepo,
  );
  
  // Test...
});
```

### 🔄 Flexibilidad
- Cambiar API → Solo modificar `NtwMenuDatasourceImpl`
- Cambiar DB → Solo modificar `LocalOrderDatasourceImpl`
- Cambiar UI → Solo modificar `CoffeeOrderScreen`

### 📈 Escalabilidad
- Agregar nueva feature → Nueva carpeta en `features/`
- Agregar nuevo método de pago → Nueva `PaymentStrategy` (OCP)
- Agregar nueva validación → Nueva clase `Validator` (SRP)

### 🛡️ Mantenibilidad
- Bug en precio → Revisar `CalculatePriceUsecase`
- Bug en API → Revisar `NtwMenuDatasourceImpl`
- Bug en UI → Revisar `CoffeeOrderScreen`

---

## 🎓 Resumen: SOLID en Clean Architecture

| Principio | Aplicación en Clean Architecture |
|-----------|----------------------------------|
| **S - Single Responsibility** | Cada Use Case, Repository, Datasource tiene UNA responsabilidad |
| **O - Open/Closed** | Strategy Pattern para pagos, bebidas (extensión sin modificación) |
| **L - Liskov Substitution** | Entities y sus subclases son intercambiables |
| **I - Interface Segregation** | Interfaces pequeñas y específicas (MenuRepository, OrderRepository) |
| **D - Dependency Inversion** | Domain depende de interfaces, Data implementa interfaces |

---

## 🚀 Conclusión

La combinación de **Clean Architecture + SOLID** crea:

✅ **Código limpio y organizado**  
✅ **Fácil de testear**  
✅ **Fácil de mantener**  
✅ **Fácil de escalar**  
✅ **Fácil de entender**

Cada capa tiene su responsabilidad, cada clase hace una cosa bien, y el código es extensible sin modificar lo existente. ¡Tu futuro yo te lo agradecerá! 🎉
