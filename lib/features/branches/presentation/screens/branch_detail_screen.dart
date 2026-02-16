import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/branches/domain/domain.dart';
import 'package:partners/features/branches/presentation/screens/branch_detail_screen_strings.dart';
import 'package:partners/features/employees/presentation/screens/create_employee_screen_strings.dart';
import 'package:partners/main.dart';

@RoutePage()
class BranchDetailScreen extends StatefulWidget {
  const BranchDetailScreen({super.key, required this.branchId});

  final String branchId;

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  BranchDetailEntity? _branch;
  bool _loading = true;
  String? _error;

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
    final result = await getIt<GetBranchByIdUsecase>().call(widget.branchId);
    if (!mounted) return;
    result.fold(
      (e) => setState(() {
        _loading = false;
        _error = e.message ?? BranchDetailScreenStrings.errorLoading;
      }),
      (entity) => setState(() {
        _loading = false;
        _branch = entity;
      }),
    );
  }

  String _scheduleDisplay(BranchDetailEntity b) {
    if (b.branchSchedules.isEmpty) return '—';
    final first = b.branchSchedules.first;
    final days = <String>[];
    if (first.monday) days.add('Lunes');
    if (first.tuesday) days.add('Martes');
    if (first.wednesday) days.add('Miércoles');
    if (first.thursday) days.add('Jueves');
    if (first.friday) days.add('Viernes');
    if (first.saturday) days.add('Sábado');
    if (first.sunday) days.add('Domingo');
    if (days.isEmpty) return '—';
    final range = days.length == 7
        ? 'Lunes a Domingo'
        : days.length == 1
            ? days.first
            : '${days.first} a ${days.last}';
    return '$range: ${first.startTime} a ${first.endTime}';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _branch == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error ?? BranchDetailScreenStrings.errorLoading,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.appColor.error),
                ),
                16.spaceh,
                ElevatedButton(
                  onPressed: () => context.router.maybePop(),
                  child: const Text(BranchDetailScreenStrings.backButton),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final b = _branch!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [
                  context.appColor.secondary,
                  Colors.transparent,
                ],
              ),
            ),
            child: SizedBox.expand(),
          ),
          RefreshIndicator(
            onRefresh: _load,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBranchCard(context, b),
                  24.spaceh,
                  Text(
                    BranchDetailScreenStrings.employeesSectionTitle,
                    style: context.appTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  12.spaceh,
                  if (b.employees.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          BranchDetailScreenStrings.noEmployees,
                          style: context.appTextTheme.bodyMedium?.copyWith(
                            color: context.appColor.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    ...b.employees.map(
                      (e) => _EmployeeTile(
                        name: e.name,
                        role: CreateEmployeeScreenStrings.roleDisplayName(e.role),
                        photoUrl: e.photo,
                        appColor: context.appColor,
                        appTextTheme: context.appTextTheme,
                      ),
                    ),
                  100.spaceh,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: context.appColor.primary),
        onPressed: () => context.router.maybePop(),
      ),
      title: Text(
        BranchDetailScreenStrings.appBarTitle,
        style: TextStyle(
          color: context.appColor.primary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'Figtree',
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBranchCard(BuildContext context, BranchDetailEntity b) {
    final isActive = b.isActive;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.appColor.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (b.logo != null && b.logo!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.network(
                b.logo!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: context.appColor.surfaceContainerHighest,
                  child: Icon(
                    Icons.store,
                    size: 56,
                    color: context.appColor.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: context.appColor.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.store,
                  size: 56,
                  color: context.appColor.onSurfaceVariant,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        b.name,
                        style: context.appTextTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? context.appColor.primaryContainer
                            : context.appColor.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isActive
                            ? BranchDetailScreenStrings.statusActive
                            : BranchDetailScreenStrings.statusInactive,
                        style: context.appTextTheme.labelSmall?.copyWith(
                          color: isActive
                              ? context.appColor.onPrimaryContainer
                              : context.appColor.onSurfaceVariant,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                  ],
                ),
                if (b.isMain) ...[
                  8.spaceh,
                  Text(
                    BranchDetailScreenStrings.mainBranch,
                    style: context.appTextTheme.bodySmall?.copyWith(
                      color: context.appColor.primary,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
                16.spaceh,
                _InfoRow(
                  icon: Icons.location_on,
                  label: BranchDetailScreenStrings.addressLabel,
                  value: b.address,
                  appColor: context.appColor,
                  appTextTheme: context.appTextTheme,
                ),
                12.spaceh,
                _InfoRow(
                  icon: Icons.phone,
                  label: BranchDetailScreenStrings.phoneLabel,
                  value: b.phoneContacts,
                  appColor: context.appColor,
                  appTextTheme: context.appTextTheme,
                ),
                12.spaceh,
                _InfoRow(
                  icon: Icons.access_time,
                  label: BranchDetailScreenStrings.scheduleLabel,
                  value: _scheduleDisplay(b),
                  appColor: context.appColor,
                  appTextTheme: context.appTextTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.appColor,
    required this.appTextTheme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ColorScheme appColor;
  final TextTheme appTextTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: appColor.onSurface),
        8.spacew,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: appTextTheme.labelSmall?.copyWith(
                  color: appColor.onSurfaceVariant,
                  fontFamily: 'Figtree',
                ),
              ),
              2.spaceh,
              Text(
                value,
                style: appTextTheme.bodyMedium?.copyWith(
                  fontFamily: 'Figtree',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.name,
    required this.role,
    required this.photoUrl,
    required this.appColor,
    required this.appTextTheme,
  });

  final String name;
  final String role;
  final String? photoUrl;
  final ColorScheme appColor;
  final TextTheme appTextTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: appColor.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: appColor.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: photoUrl != null && photoUrl!.isNotEmpty
                      ? Image.network(
                          photoUrl!,
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            color: appColor.onSurfaceVariant,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: appColor.onSurfaceVariant,
                        ),
                ),
              ),
              16.spacew,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: appTextTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    4.spaceh,
                    Text(
                      role,
                      style: appTextTheme.bodySmall?.copyWith(
                        color: appColor.onSurfaceVariant,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
