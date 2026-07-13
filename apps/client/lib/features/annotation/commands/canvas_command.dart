import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CanvasCommand {
  /// The GroundTruthId this command applies to, used for provider invalidation.
  String get groundTruthId;

  /// Executes the forward action (e.g. create, update, delete).
  /// This must await the API request.
  Future<void> execute(Ref ref);

  /// Executes the reverse action (e.g. delete after create, revert update, recreate after delete).
  /// This must await the API request.
  Future<void> undo(Ref ref);
}
