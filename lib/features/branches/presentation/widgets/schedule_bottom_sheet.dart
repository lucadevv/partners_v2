import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';

/// Modal de horario: días + hora inicio/fin, confirma y actualiza [CreateBranchFormNotifier].
class ScheduleBottomSheetContent extends StatefulWidget {
  final CreateBranchFormNotifier formNotifier;

  const ScheduleBottomSheetContent({
    super.key,
    required this.formNotifier,
  });

  @override
  State<ScheduleBottomSheetContent> createState() =>
      _ScheduleBottomSheetContentState();
}

class _ScheduleBottomSheetContentState extends State<ScheduleBottomSheetContent> {
  late Set<String> _selectedDays;
  late String _startTime;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    _selectedDays = {};
    _startTime = '09:00';
    _endTime = '21:00';
  }

  void _onConfirm() {
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            CreateBranchScreenStrings.scheduleModalSelectAtLeastOneDay,
          ),
        ),
      );
      return;
    }
    final list = _selectedDays.toList();
    list.sort(
      (a, b) =>
          CreateBranchScreenStrings.scheduleModalDays.indexOf(a).compareTo(
        CreateBranchScreenStrings.scheduleModalDays.indexOf(b),
      ),
    );
    final daysStr = list.join(', ');
    final display = daysStr.isEmpty
        ? '$_startTime - $_endTime'
        : '$daysStr: $_startTime - $_endTime';
    widget.formNotifier.setSchedule(display);
    widget.formNotifier.setScheduleData(list, _startTime, _endTime);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.appColor.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const SizedBox(width: 131, height: 5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    CreateBranchScreenStrings.scheduleModalTitle,
                    style: TextStyle(
                      color: context.appColor.primary,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    CreateBranchScreenStrings.scheduleModalDaysLabel,
                    style: TextStyle(
                      color: context.appColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
                20.spaceh,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.start,
                    children: CreateBranchScreenStrings.scheduleModalDays
                        .map((day) {
                      final isSelected = _selectedDays.contains(day);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedDays.remove(day);
                            } else {
                              _selectedDays.add(day);
                            }
                          });
                        },
                        child: SizedBox(
                          width: 100,
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.appColor.primaryContainer
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: context.appColor.primary,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: isSelected
                                      ? context.appColor.onPrimaryContainer
                                      : context.appColor.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Figtree',
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                40.spaceh,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    CreateBranchScreenStrings.scheduleModalTimeLabel,
                    style: TextStyle(
                      color: context.appColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
                20.spaceh,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BuildScheduleTimeField(
                          label: CreateBranchScreenStrings.scheduleModalStartLabel,
                          value: _startTime,
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 9, minute: 0),
                            );
                            if (time != null && mounted) {
                              setState(() {
                                _startTime =
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                      ),
                      19.spacew,
                      Expanded(
                        child: _BuildScheduleTimeField(
                          label: CreateBranchScreenStrings.scheduleModalEndLabel,
                          value: _endTime,
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 21, minute: 0),
                            );
                            if (time != null && mounted) {
                              setState(() {
                                _endTime =
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                40.spaceh,
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.appColor.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _onConfirm,
                          borderRadius: BorderRadius.circular(50),
                          child: Center(
                            child: Text(
                              CreateBranchScreenStrings.scheduleModalConfirm,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildScheduleTimeField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _BuildScheduleTimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.appColor.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        SizedBox(
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColor.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.appColor.primary,
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: context.appColor.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
