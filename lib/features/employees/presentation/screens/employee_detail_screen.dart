import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/employees/domain/domain.dart';
import 'package:partners/features/employees/presentation/screens/create_employee_screen_strings.dart';
import 'package:partners/main.dart';

@RoutePage()
class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({super.key, required this.employeeId});

  final String employeeId;

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  EmployeeEntity? _employee;
  bool _loading = true;
  String? _error;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await getIt<GetEmployeeByIdUsecase>().call(widget.employeeId);
    if (!mounted) return;
    result.fold(
      (e) => setState(() {
        _loading = false;
        _error = e.message ?? 'Error al cargar empleado';
      }),
      (entity) => setState(() {
        _loading = false;
        _employee = entity;
      }),
    );
  }

  Future<void> _onDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar empleado'),
        content: const Text(
          '¿Está seguro de eliminar este empleado de la sucursal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => _deleting = true);
    final result = await getIt<DeleteEmployeeUsecase>().call(widget.employeeId);
    if (!mounted) return;
    setState(() => _deleting = false);
    result.fold(
      (e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Error al eliminar'),
          backgroundColor: Colors.red,
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Empleado eliminado de la sucursal correctamente'),
          ),
        );
        context.router.maybePop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.appColor.primary),
            onPressed: () => context.router.maybePop(),
          ),
          title: Text(
            'Detalle de empleado',
            style: TextStyle(
              color: context.appColor.primary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Figtree',
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _employee == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.appColor.primary),
            onPressed: () => context.router.maybePop(),
          ),
          title: Text(
            'Detalle de empleado',
            style: TextStyle(
              color: context.appColor.primary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Figtree',
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error ?? 'Empleado no encontrado',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.appColor.error),
                ),
                16.spaceh,
                ElevatedButton(
                  onPressed: () => context.router.maybePop(),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final e = _employee!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColor.primary),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          'Detalle de empleado',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: _buildPhoto(e),
              ),
            24.spaceh,
            Text(
              e.name,
              textAlign: TextAlign.center,
              style: context.appTextTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree',
              ),
            ),
            8.spaceh,
            Text(
              CreateEmployeeScreenStrings.roleDisplayName(e.role),
              textAlign: TextAlign.center,
              style: context.appTextTheme.bodyLarge?.copyWith(
                color: context.appColor.onSurfaceVariant,
                fontFamily: 'Figtree',
              ),
            ),
            32.spaceh,
            ElevatedButton(
              onPressed: _deleting
                  ? null
                  : () async {
                      await context.router.push(
                        EditEmployeeRoute(employeeId: widget.employeeId),
                      );
                      if (mounted) _load();
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Editar'),
            ),
            12.spaceh,
            OutlinedButton(
              onPressed: _deleting ? null : _onDelete,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: context.appColor.error),
              ),
              child: _deleting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Eliminar de la sucursal',
                      style: TextStyle(color: context.appColor.error),
                    ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildPhoto(EmployeeEntity e) {
    const double size = 120;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.appColor.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.appColor.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: e.photo != null && e.photo!.isNotEmpty
            ? Image.network(
                e.photo!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: 56,
                  color: context.appColor.onSurfaceVariant,
                ),
              )
            : Icon(
                Icons.person,
                size: 56,
                color: context.appColor.onSurfaceVariant,
              ),
      ),
    );
  }
}
