import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'canvas_command.dart';

class BatchCommand implements CanvasCommand {
  final List<CanvasCommand> commands;

  @override
  String get groundTruthId => commands.isNotEmpty ? commands.first.groundTruthId : '';

  BatchCommand(this.commands);

  @override
  Future<void> execute(Ref ref) async {
    for (final cmd in commands) {
      await cmd.execute(ref);
    }
  }

  @override
  Future<void> undo(Ref ref) async {
    for (final cmd in commands.reversed) {
      await cmd.undo(ref);
    }
  }
}
