import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/canvas_state_provider.dart';
import '../../providers/annotation_edit_provider.dart';
import '../../providers/history_provider.dart';
import '../../commands/delete_command.dart';

class CanvasToolbar extends ConsumerWidget {
  final String groundTruthId;
  const CanvasToolbar({super.key, required this.groundTruthId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasStateProvider);
    final isSaving = canvasState.currentState == CanvasState.saving;
    final selectedAnnotations = ref.watch(selectedAnnotationsProvider);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToolButton(
              icon: Icons.near_me,
              label: 'Seç',
              tool: CanvasTool.select,
              activeTool: canvasState.activeTool,
              disabled: isSaving,
            ),
            _ToolButton(
              icon: Icons.pan_tool,
              label: 'Kaydır',
              tool: CanvasTool.pan,
              activeTool: canvasState.activeTool,
              disabled: isSaving,
            ),
            const Divider(),
            _ToolButton(
              icon: Icons.crop_square,
              label: 'Dikdörtgen',
              tool: CanvasTool.rectangle,
              activeTool: canvasState.activeTool,
              disabled: isSaving,
            ),
            _ToolButton(
              icon: Icons.pentagon_outlined,
              label: 'Çokgen',
              tool: CanvasTool.polygon,
              activeTool: canvasState.activeTool,
              disabled: isSaving,
            ),
            _ToolButton(
              icon: Icons.brush,
              label: 'Fırça',
              tool: CanvasTool.brush,
              activeTool: canvasState.activeTool,
              disabled: isSaving,
            ),
            const Divider(),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Seçileni Sil',
              color: Colors.red,
              onPressed: selectedAnnotations.isEmpty || isSaving
                  ? null
                  : () async {
                      final history = ref.read(historyProvider.notifier);
                      for (final ann in selectedAnnotations) {
                        final cmd = DeleteAnnotationCommand(
                          groundTruthId: groundTruthId,
                          annotationId: ann.id,
                          type: ann.type,
                          geometry: ann.geometry,
                        );
                        await history.executeCommand(cmd);
                      }
                      ref.read(selectedAnnotationsProvider.notifier).state = [];
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends ConsumerWidget {
  final IconData icon;
  final String label;
  final CanvasTool tool;
  final CanvasTool activeTool;
  final bool disabled;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.tool,
    required this.activeTool,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = tool == activeTool;
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(icon),
      tooltip: label,
      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
      style: isSelected
          ? IconButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
            )
          : null,
      onPressed: disabled
          ? null
          : () {
              ref.read(canvasStateProvider.notifier).setTool(tool);
            },
    );
  }
}
