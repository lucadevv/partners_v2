import 'package:flutter/material.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';
import 'package:partners/features/home/presentation/widgets/smart_tool_card_widget.dart';

/// Widget for the Smart Tools grid section
/// Follows Single Responsibility Principle (SRP)
class HomeToolsGridSection extends StatelessWidget {
  final List<SmartToolEntity> tools;

  const HomeToolsGridSection({required this.tools, super.key});

  @override
  Widget build(BuildContext context) {
    if (tools.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 300,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 0,
            mainAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return SmartToolCardWidget(tool: tool);
          },
        ),
      ),
    );
  }
}
