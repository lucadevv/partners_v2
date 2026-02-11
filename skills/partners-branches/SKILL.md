---
name: partners-branches
description: >
  Branch management patterns for Partners app - branch creation, worker assignment, schedule management.
  Trigger: Working with branch features, employee management, scheduling.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [branches]
  auto_invoke:
    - "Branch management, workers, schedules"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Branch Management Overview

Partners app supports multi-branch operations with worker management and scheduling.

## Core Components

### Branch Entity
Represents physical store locations with coordinates and operating hours.

### Worker Entity
Employees assigned to specific branches with roles and schedules.

### Schedule Entity
Time-based scheduling system for workers and branch operations.

## Domain Entities

### Branch Entity
```dart
class Branch extends Entity {
  final String name;
  final String address;
  final String district;
  final String province;
  final String department;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String email;
  final BranchStatus status;
  final String category;
  final String? subCategory;
  final List<String> operatingHours;
  final Map<String, dynamic>? metadata;
  
  const Branch({
    required String id,
    required this.name,
    required this.address,
    required this.district,
    required this.province,
    required this.department,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.status,
    required this.category,
    this.subCategory,
    required this.operatingHours,
    this.metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isActive => status == BranchStatus.active;
  bool get isInactive => status == BranchStatus.inactive;
  bool get isPending => status == BranchStatus.pending;
  
  String get fullAddress => '$address, $district, $province, $department';
  LatLng get coordinates => LatLng(latitude, longitude);
  
  String get statusDisplay {
    switch (status) {
      case BranchStatus.active:
        return 'Activo';
      case BranchStatus.inactive:
        return 'Inactivo';
      case BranchStatus.pending:
        return 'Pendiente';
      case BranchStatus.suspended:
        return 'Suspendido';
    }
  }
}
```

### Worker Entity
```dart
class Worker extends Entity {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String documentType;
  final String documentNumber;
  final WorkerRole role;
  final String branchId;
  final String? scheduleId;
  final List<String> skills;
  final DateTime? hireDate;
  final DateTime? terminationDate;
  final bool isActive;
  final double? baseSalary;
  final Map<String, dynamic>? metadata;
  
  const Worker({
    required String id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.documentType,
    required this.documentNumber,
    required this.role,
    required this.branchId,
    this.scheduleId,
    required this.skills,
    this.hireDate,
    this.terminationDate,
    this.isActive = true,
    this.baseSalary,
    this.metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  String get fullName => '$firstName $lastName';
  bool get isManager => role == WorkerRole.manager || role == WorkerRole.admin;
  bool get isActiveEmployee => isActive && terminationDate == null;
  bool get hasSchedule => scheduleId != null && scheduleId!.isNotEmpty;
  
  String get roleDisplay {
    switch (role) {
      case WorkerRole.admin:
        return 'Administrador';
      case WorkerRole.manager:
        return 'Gerente';
      case WorkerRole.supervisor:
        return 'Supervisor';
      case WorkerRole.cashier:
        return 'Cajero';
      case WorkerRole.assistant:
        return 'Asistente';
    }
  }
}
```

### Schedule Entity
```dart
class Schedule extends Entity {
  final String branchId;
  final String name;
  final List<ScheduleDay> days;
  final List<Holiday> holidays;
  final bool isDefault;
  final ScheduleType type;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  
  const Schedule({
    required String id,
    required this.branchId,
    required this.name,
    required this.days,
    required this.holidays,
    this.isDefault = false,
    required this.type,
    this.effectiveFrom,
    this.effectiveTo,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isActiveNow {
    final now = DateTime.now();
    if (effectiveFrom != null && now.isBefore(effectiveFrom!)) return false;
    if (effectiveTo != null && now.isAfter(effectiveTo!)) return false;
    return true;
  }
  
  ScheduleDay? getTodaySchedule {
    final today = DateTime.now();
    final dayName = _getDayName(today.weekday);
    return days.firstWhere((day) => day.day == dayName, orElse: () => null);
  }
  
  bool get isWorkingToday {
    final todaySchedule = getTodaySchedule;
    return todaySchedule?.isWorkingDay ?? false;
  }
  
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Lunes';
      case 2: return 'Martes';
      case 3: return 'Miércoles';
      case 4: return 'Jueves';
      case 5: return 'Viernes';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return '';
    }
  }
}
```

### Schedule Day Entity
```dart
class ScheduleDay {
  final String day;
  final bool isWorkingDay;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;
  final List<Break> breaks;
  final String? specialNotes;
  
  const ScheduleDay({
    required this.day,
    required this.isWorkingDay,
    this.openTime,
    this.closeTime,
    this.breaks = const [],
    this.specialNotes,
  });
  
  // Business logic
  Duration? get workingHours {
    if (!isWorkingDay || openTime == null || closeTime == null) {
      return null;
    }
    
    final openMinutes = openTime!.hour * 60 + openTime!.minute;
    final closeMinutes = closeTime!.hour * 60 + closeTime!.minute;
    var totalMinutes = closeMinutes - openMinutes;
    
    // Subtract break times
    for (final break_ in breaks) {
      final breakStart = break_.startTime.hour * 60 + break_.startTime.minute;
      final breakEnd = break_.endTime.hour * 60 + break_.endTime.minute;
      totalMinutes -= (breakEnd - breakStart);
    }
    
    return Duration(minutes: totalMinutes);
  }
  
  String get workingHoursDisplay {
    if (!isWorkingDay || openTime == null || closeTime == null) {
      return 'Cerrado';
    }
    
    final openStr = '${openTime!.hour.toString().padLeft(2, '0')}:${openTime!.minute.toString().padLeft(2, '0')}';
    final closeStr = '${closeTime!.hour.toString().padLeft(2, '0')}:${closeTime!.minute.toString().padLeft(2, '0')}';
    
    return '$openStr - $closeStr';
  }
}
```

## Use Cases

### Create Branch Use Case
```dart
class CreateBranchUseCase implements UseCase<Branch, CreateBranchParams> {
  final BranchRepository _branchRepository;
  final LocationRepository _locationRepository;
  final AuthManager _authManager;
  
  CreateBranchUseCase(
    this._branchRepository,
    this._locationRepository,
    this._authManager,
  );
  
  @override
  Future<Either<BranchFailure, Branch>> call(CreateBranchParams params) async {
    // Validation
    final validationError = _validateBranchParams(params);
    if (validationError != null) {
      return Left(BranchFailure.invalidData(validationError));
    }
    
    // Check user permissions
    final currentUser = await _authManager.getCurrentUser();
    if (currentUser == null || !_canCreateBranch(currentUser.role)) {
      return Left(BranchFailure.insufficientPermissions);
    }
    
    // Validate coordinates
    final isValidCoordinates = await _locationRepository.validateCoordinates(
      params.latitude,
      params.longitude,
    );
    
    if (!isValidCoordinates) {
      return Left(BranchFailure.invalidLocation);
    }
    
    try {
      // Create branch
      final branch = Branch(
        id: _generateBranchId(),
        name: params.name,
        address: params.address,
        district: params.district,
        province: params.province,
        department: params.department,
        latitude: params.latitude,
        longitude: params.longitude,
        phoneNumber: params.phoneNumber,
        email: params.email,
        status: BranchStatus.pending,  // Requires approval
        category: params.category,
        subCategory: params.subCategory,
        operatingHours: params.operatingHours,
        metadata: params.metadata,
        createdAt: DateTime.now(),
      );
      
      final createdBranch = await _branchRepository.createBranch(branch);
      
      // Create default schedule if not provided
      if (params.createDefaultSchedule) {
        await _createDefaultSchedule(createdBranch.id);
      }
      
      return Right(createdBranch);
    } catch (e) {
      return Left(BranchFailure.custom('Failed to create branch: $e'));
    }
  }
  
  String? _validateBranchParams(CreateBranchParams params) {
    if (params.name.trim().isEmpty) return 'El nombre es requerido';
    if (params.name.trim().length < 3) return 'El nombre debe tener al menos 3 caracteres';
    if (params.address.trim().isEmpty) return 'La dirección es requerida';
    if (params.district.trim().isEmpty) return 'El distrito es requerido';
    if (params.province.trim().isEmpty) return 'La provincia es requerida';
    if (params.department.trim().isEmpty) return 'El departamento es requerido';
    
    if (params.phoneNumber.trim().isEmpty) return 'El teléfono es requerido';
    if (!RegExp(r'^[\d\s\-\+\(\)]+$').hasMatch(params.phoneNumber)) {
      return 'El teléfono no es válido';
    }
    
    if (params.email.trim().isEmpty) return 'El email es requerido';
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(params.email)) {
      return 'El email no es válido';
    }
    
    if (params.latitude < -90 || params.latitude > 90) return 'Latitud inválida';
    if (params.longitude < -180 || params.longitude > 180) return 'Longitud inválida';
    
    return null;
  }
  
  bool _canCreateBranch(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager;
  }
  
  void _createDefaultSchedule(String branchId) async {
    final defaultSchedule = Schedule(
      id: _generateScheduleId(),
      branchId: branchId,
      name: 'Horario estándar',
      days: [
        ScheduleDay(day: 'Lunes', isWorkingDay: true, openTime: TimeOfDay(hour: 9, minute: 0), closeTime: TimeOfDay(hour: 18, minute: 0)),
        ScheduleDay(day: 'Martes', isWorkingDay: true, openTime: TimeOfDay(hour: 9, minute: 0), closeTime: TimeOfDay(hour: 18, minute: 0)),
        ScheduleDay(day: 'Miércoles', isWorkingDay: true, openTime: TimeOfDay(hour: 9, minute: 0), closeTime: TimeOfDay(hour: 18, minute: 0)),
        ScheduleDay(day: 'Jueves', isWorkingDay: true, openTime: TimeOfDay(hour: 9, minute: 0), closeTime: TimeOfDay(hour: 18, minute: 0)),
        ScheduleDay(day: 'Viernes', isWorkingDay: true, openTime: TimeOfDay(hour: 9, minute: 0), closeTime: TimeOfDay(hour: 18, minute: 0)),
        ScheduleDay(day: 'Sábado', isWorkingDay: true, openTime: TimeOfDay(hour: 9, minute: 0), closeTime: TimeOfDay(hour: 13, minute: 0)),
        ScheduleDay(day: 'Domingo', isWorkingDay: false),
      ],
      holidays: [],
      isDefault: true,
      type: ScheduleType.regular,
      effectiveFrom: DateTime.now(),
      createdAt: DateTime.now(),
    );
    
    await _branchRepository.createSchedule(defaultSchedule);
  }
}
```

### Assign Worker Use Case
```dart
class AssignWorkerUseCase implements UseCase<Worker, AssignWorkerParams> {
  final WorkerRepository _workerRepository;
  final BranchRepository _branchRepository;
  final AuthManager _authManager;
  
  AssignWorkerUseCase(
    this._workerRepository,
    this._branchRepository,
    this._authManager,
  );
  
  @override
  Future<Either<WorkerFailure, Worker>> call(AssignWorkerParams params) async {
    // Check user permissions
    final currentUser = await _authManager.getCurrentUser();
    if (currentUser == null || !_canAssignWorker(currentUser.role)) {
      return Left(WorkerFailure.insufficientPermissions);
    }
    
    // Validate branch exists and is active
    final branch = await _branchRepository.getBranchById(params.branchId);
    if (branch == null) {
      return Left(WorkerFailure.branchNotFound);
    }
    
    if (branch.status != BranchStatus.active) {
      return Left(WorkerFailure.inactiveBranch);
    }
    
    // Check if worker already assigned
    final existingWorker = await _workerRepository.getWorkerByDocument(
      params.documentType,
      params.documentNumber,
    );
    
    if (existingWorker != null && existingWorker.isActiveEmployee) {
      return Left(WorkerFailure.alreadyAssigned);
    }
    
    try {
      // Create worker
      final worker = Worker(
        id: _generateWorkerId(),
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        phoneNumber: params.phoneNumber,
        documentType: params.documentType,
        documentNumber: params.documentNumber,
        role: params.role,
        branchId: params.branchId,
        skills: params.skills,
        hireDate: DateTime.now(),
        isActive: true,
        metadata: params.metadata,
        createdAt: DateTime.now(),
      );
      
      final createdWorker = await _workerRepository.createWorker(worker);
      
      return Right(createdWorker);
    } catch (e) {
      return Left(WorkerFailure.custom('Failed to assign worker: $e'));
    }
  }
  
  bool _canAssignWorker(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager || role == UserRole.supervisor;
  }
}
```

### Create Schedule Use Case
```dart
class CreateScheduleUseCase implements UseCase<Schedule, CreateScheduleParams> {
  final ScheduleRepository _scheduleRepository;
  final BranchRepository _branchRepository;
  final AuthManager _authManager;
  
  CreateScheduleUseCase(
    this._scheduleRepository,
    this._branchRepository,
    this._authManager,
  );
  
  @override
  Future<Either<ScheduleFailure, Schedule>> call(CreateScheduleParams params) async {
    // Check permissions
    final currentUser = await _authManager.getCurrentUser();
    if (currentUser == null || !_canManageSchedule(currentUser.role)) {
      return Left(ScheduleFailure.insufficientPermissions);
    }
    
    // Validate branch
    final branch = await _branchRepository.getBranchById(params.branchId);
    if (branch == null) {
      return Left(ScheduleFailure.branchNotFound);
    }
    
    // Validate schedule data
    final validationError = _validateScheduleParams(params);
    if (validationError != null) {
      return Left(ScheduleFailure.invalidData(validationError));
    }
    
    try {
      // Create schedule
      final schedule = Schedule(
        id: _generateScheduleId(),
        branchId: params.branchId,
        name: params.name,
        days: params.days,
        holidays: params.holidays,
        isDefault: params.isDefault,
        type: params.type,
        effectiveFrom: params.effectiveFrom,
        effectiveTo: params.effectiveTo,
        createdAt: DateTime.now(),
      );
      
      final createdSchedule = await _scheduleRepository.createSchedule(schedule);
      
      // Set as default if specified
      if (params.isDefault) {
        await _scheduleRepository.setDefaultSchedule(schedule.id);
      }
      
      return Right(createdSchedule);
    } catch (e) {
      return Left(ScheduleFailure.custom('Failed to create schedule: $e'));
    }
  }
  
  String? _validateScheduleParams(CreateScheduleParams params) {
    if (params.name.trim().isEmpty) return 'El nombre del horario es requerido';
    if (params.days.isEmpty) return 'Se requiere al menos un día de trabajo';
    if (params.days.length > 7) return 'No puede haber más de 7 días';
    
    // Validate each day
    for (final day in params.days) {
      if (day.isWorkingDay) {
        if (day.openTime == null || day.closeTime == null) {
          return 'Los días de trabajo deben tener horas de apertura y cierre';
        }
        
        if (!_isValidTimeRange(day.openTime!, day.closeTime!)) {
          return 'La hora de cierre debe ser posterior a la de apertura';
        }
      }
    }
    
    return null;
  }
  
  bool _isValidTimeRange(TimeOfDay open, TimeOfDay close) {
    final openMinutes = open.hour * 60 + open.minute;
    final closeMinutes = close.hour * 60 + close.minute;
    return closeMinutes > openMinutes;
  }
  
  bool _canManageSchedule(UserRole role) {
    return role == UserRole.admin || role == UserRole.manager || role == UserRole.supervisor;
  }
}
```

## Repository Patterns

### Branch Repository Interface
```dart
abstract class BranchRepository {
  Future<Either<BranchFailure, Branch>> createBranch(Branch branch);
  Future<Either<BranchFailure, List<Branch>>> getBranches({
    BranchStatus? status,
    String? category,
    String? province,
    int page = 1,
    int limit = 20,
  });
  
  Future<Either<BranchFailure, Branch?>> getBranchById(String id);
  Future<Either<BranchFailure, void>> updateBranch(Branch branch);
  Future<Either<BranchFailure, void>> deleteBranch(String id);
  Future<Either<BranchFailure, List<Branch>>> searchBranches(String query);
  Future<Either<BranchFailure, List<Branch>>> getNearbyBranches(double latitude, double longitude, double radiusKm);
}
```

### Worker Repository Interface
```dart
abstract class WorkerRepository {
  Future<Either<WorkerFailure, Worker>> createWorker(Worker worker);
  Future<Either<WorkerFailure, List<Worker>>> getWorkers({
    String? branchId,
    WorkerRole? role,
    bool? isActive,
    int page = 1,
    int limit = 20,
  });
  
  Future<Either<WorkerFailure, Worker?>> getWorkerById(String id);
  Future<Either<WorkerFailure, Worker?>> getWorkerByDocument(String documentType, String documentNumber);
  Future<Either<WorkerFailure, void>> updateWorker(Worker worker);
  Future<Either<WorkerFailure, void>> assignWorkerToBranch(String workerId, String branchId);
  Future<Either<WorkerFailure, void>> terminateWorker(String workerId, String reason);
  Future<Either<WorkerFailure, List<Worker>>> searchWorkers(String query);
}
```

### Schedule Repository Interface
```dart
abstract class ScheduleRepository {
  Future<Either<ScheduleFailure, Schedule>> createSchedule(Schedule schedule);
  Future<Either<ScheduleFailure, List<Schedule>>> getSchedules(String branchId);
  Future<Either<ScheduleFailure, Schedule?>> getScheduleById(String id);
  Future<Either<ScheduleFailure, void>> updateSchedule(Schedule schedule);
  Future<Either<ScheduleFailure, void>> deleteSchedule(String id);
  Future<Either<ScheduleFailure, void>> setDefaultSchedule(String scheduleId);
  Future<Either<ScheduleFailure, Schedule?>> getDefaultSchedule(String branchId);
  Future<Either<ScheduleFailure, void>> assignScheduleToWorkers(String scheduleId, List<String> workerIds);
}
```

## UI Patterns

### Branch Form Widget
```dart
class BranchFormWidget extends StatefulWidget {
  final Branch? branch;
  final Function(Branch) onSave;
  final bool isLoading;
  
  const BranchFormWidget({
    Key? key,
    this.branch,
    required this.onSave,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  _BranchFormWidgetState createState() => _BranchFormWidgetState();
}

class _BranchFormWidgetState extends State<BranchFormWidget> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _districtController;
  late TextEditingController _provinceController;
  late TextEditingController _departmentController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  
  String? _selectedCategory;
  String? _selectedSubCategory;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }
  
  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.branch?.name ?? '');
    _addressController = TextEditingController(text: widget.branch?.address ?? '');
    _districtController = TextEditingController(text: widget.branch?.district ?? '');
    _provinceController = TextEditingController(text: widget.branch?.province ?? '');
    _departmentController = TextEditingController(text: widget.branch?.department ?? '');
    _phoneController = TextEditingController(text: widget.branch?.phoneNumber ?? '');
    _emailController = TextEditingController(text: widget.branch?.email ?? '');
    
    _selectedCategory = widget.branch?.category;
    _selectedSubCategory = widget.branch?.subCategory;
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre de la sucursal'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Este campo es requerido';
              if (value.length < 3) return 'Mínimo 3 caracteres';
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Dirección'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Este campo es requerido';
              return null;
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(labelText: 'Categoría'),
            items: [
              DropdownMenuItem(value: 'tienda', child: Text('Tienda')),
              DropdownMenuItem(value: 'kiosko', child: Text('Kiosko')),
              DropdownMenuItem(value: 'restaurant', child: Text('Restaurante')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
                _selectedSubCategory = null; // Reset subcategory
              });
            },
          ),
          SizedBox(height: 24),
          CustomButton(
            text: widget.branch == null ? 'Crear Sucursal' : 'Actualizar Sucursal',
            onPressed: widget.isLoading ? null : _saveBranch,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
  
  void _saveBranch() {
    // Form validation and save logic
    final branch = Branch(
      id: widget.branch?.id ?? _generateId(),
      name: _nameController.text,
      address: _addressController.text,
      district: _districtController.text,
      province: _provinceController.text,
      department: _departmentController.text,
      latitude: 0.0, // Get from location picker
      longitude: 0.0, // Get from location picker
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      status: BranchStatus.pending,
      category: _selectedCategory!,
      subCategory: _selectedSubCategory,
      operatingHours: [], // Get from schedule form
      createdAt: widget.branch?.createdAt ?? DateTime.now(),
    );
    
    widget.onSave(branch);
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _provinceController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
```

## Related Skills

- `partners` - Project overview and navigation
- `partners-domain` - Branch domain entities and use cases
- `partners-data` - Branch data sources and models
- `partners-ui` - Branch UI patterns
- `partners-testing` - Branch testing
- `partners-rbac` - Branch permissions
- `mapbox-integration` - Branch location features
- `state-management` - Branch BLoC/Cubit patterns