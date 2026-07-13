# Architectural Refactoring Plan: Assessment as the Central Aggregate

Based on the required architectural rules, the current implementation has a redundant and unused `LibraryItem` entity that acts as a middleman. The `LibraryRepository.Add` method is never called, meaning the `LibraryItems` table is currently empty and non-functional.

We will refactor the system to make `Assessment` the authoritative central aggregate. The "Library" will simply become a projection (view) of `Published` Assessments, eliminating the need for a separate physical `LibraryItem` entity.

## User Review Required
> [!WARNING]
> Dropping the `LibraryItems` table and modifying `ParticipantAnswers` and `TrainingItems` tables will require an Entity Framework Core database migration. Since `LibraryItems` was never populated in the backend, no data will be lost there. Existing `TrainingItems` and `ParticipantAnswers` might need to be cleared or migrated if they contain mock data. Please confirm if wiping mock data for these specific junction tables is acceptable during the migration.

## Open Questions
> [!IMPORTANT]
> 1. Should `ParticipantAnswer` **replace** `TrainingItemId` with `AssessmentId`, or **keep both**? (Keeping both helps trace exactly which order/pack the answer belongs to, but replacing it strictly adheres to "ParticipantAnswer references Assessment"). *Recommendation: Keep `TrainingSessionId` and replace `TrainingItemId` with `AssessmentId` to link directly to the central aggregate.*

## Proposed Changes

---

### Backend Domain Entities

#### [DELETE] `apps\api\src\RealityLens.Domain\Entities\LibraryItem.cs`
- Remove this entity entirely. The "Library" is a concept, not a physical table.

#### [MODIFY] `apps\api\src\RealityLens.Domain\Entities\TrainingItem.cs`
- Remove `LibraryItemId` and `LibraryItem` navigation property.
- Add `AssessmentId` and `Assessment` navigation property.

#### [MODIFY] `apps\api\src\RealityLens.Domain\Entities\ParticipantAnswer.cs`
- Replace `TrainingItemId` with `AssessmentId`.

---

### Backend Persistence & EF Core

#### [DELETE] `apps\api\src\RealityLens.Domain\Repositories\ILibraryRepository.cs`
#### [DELETE] `apps\api\src\RealityLens.Persistence\Repositories\LibraryRepository.cs`
- Remove the unused repository.

#### [MODIFY] `apps\api\src\RealityLens.Persistence\RealityLensDbContext.cs`
- Remove `DbSet<LibraryItem>`.

#### [MODIFY] `apps\api\src\RealityLens.Persistence\Configurations\*`
- Update `TrainingItemConfiguration.cs` to map `AssessmentId` instead of `LibraryItemId`.
- Update `ParticipantAnswerConfiguration.cs` to map `AssessmentId` instead of `TrainingItemId`.
- Delete `LibraryItemConfiguration.cs` (if it exists).

---

### Backend CQRS & APIs

#### [MODIFY] `apps\api\src\RealityLens.Application\CQRS\Queries\TrainingLibrary\*`
- Update `SearchLibraryItemsQueryHandler` and `GetLibraryItemByIdQueryHandler` to query the `Assessments` table directly (where `Status == AssessmentStatus.Published`).
- The API response DTOs (`LibraryItemSummaryDto`) will remain the same to avoid breaking the frontend, but the `Id` will now directly be the `AssessmentId`.

#### [MODIFY] `apps\api\src\RealityLens.Application\CQRS\Queries\TrainingPacks\GetTrainingPackItems.cs`
- Update the join query to directly join `TrainingItems` with `Assessments` using `AssessmentId`, bypassing the deleted `LibraryItems`.

#### [MODIFY] `apps\api\src\RealityLens.Application\CQRS\Commands\TrainingPacks\AddTrainingItem.cs`
- Rename `LibraryItemId` to `AssessmentId` in the command and handler.

#### [MODIFY] `apps\api\src\RealityLens.Application\CQRS\Commands\TrainingSessions\SubmitParticipantAnswer.cs`
- Update command to take `AssessmentId` instead of `TrainingItemId`.

---

### Frontend (Flutter App)

#### [MODIFY] `apps\client\lib\features\training_management\data\models\library_item_dto.dart`
- The `id` field will now natively represent the `AssessmentId`. We can safely remove the explicit `assessmentId` field if it becomes redundant, or keep it mapped to the same ID.

#### [MODIFY] `apps\client\lib\features\training_management\presentation\providers\training_pack_items_notifier.dart`
- Variable renames: `libraryItemId` -> `assessmentId` when calling `addItem`.

## Verification Plan

### Automated Tests
- `dotnet build` on the backend.
- Create and run EF Core Migration: `dotnet ef migrations add RefactorToAssessmentCentric -p apps\api\src\RealityLens.Persistence -s apps\api\src\RealityLens.Presentation`.
- `flutter analyze` and `flutter test` on the client.

### Manual Verification
- Verify the Training Library correctly loads published Assessments.
- Verify adding an item to a Training Pack works using the direct Assessment ID.
- Verify submitting an answer during a session successfully maps to the Assessment.
