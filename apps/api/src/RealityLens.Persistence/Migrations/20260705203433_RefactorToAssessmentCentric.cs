using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RealityLens.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RefactorToAssessmentCentric : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Annotations_Answers_AnswerId",
                table: "Annotations");

            migrationBuilder.DropForeignKey(
                name: "FK_Annotations_GroundTruths_GroundTruthId",
                table: "Annotations");

            migrationBuilder.DropForeignKey(
                name: "FK_TrainingItems_LibraryItems_LibraryItemId",
                table: "TrainingItems");

            migrationBuilder.DropTable(
                name: "LibraryItems");

            migrationBuilder.DropIndex(
                name: "IX_Annotations_AnswerId",
                table: "Annotations");

            migrationBuilder.DropIndex(
                name: "IX_Annotations_GroundTruthId",
                table: "Annotations");

            migrationBuilder.DropCheckConstraint(
                name: "CK_Annotation_ExclusiveOwner",
                table: "Annotations");

            migrationBuilder.DropColumn(
                name: "AnswerId",
                table: "Annotations");

            migrationBuilder.DropColumn(
                name: "GroundTruthId",
                table: "Annotations");

            migrationBuilder.RenameColumn(
                name: "LibraryItemId",
                table: "TrainingItems",
                newName: "AssessmentId");

            migrationBuilder.RenameIndex(
                name: "IX_TrainingItems_LibraryItemId",
                table: "TrainingItems",
                newName: "IX_TrainingItems_AssessmentId");

            migrationBuilder.AddColumn<Guid>(
                name: "AssessmentId",
                table: "ParticipantAnswers",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "AnnotationId",
                table: "GroundTruths",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "AnnotationId",
                table: "Answers",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "CreatedBy",
                table: "Annotations",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddForeignKey(
                name: "FK_TrainingItems_Assessments_AssessmentId",
                table: "TrainingItems",
                column: "AssessmentId",
                principalTable: "Assessments",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TrainingItems_Assessments_AssessmentId",
                table: "TrainingItems");

            migrationBuilder.DropColumn(
                name: "AssessmentId",
                table: "ParticipantAnswers");

            migrationBuilder.DropColumn(
                name: "AnnotationId",
                table: "GroundTruths");

            migrationBuilder.DropColumn(
                name: "AnnotationId",
                table: "Answers");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                table: "Annotations");

            migrationBuilder.RenameColumn(
                name: "AssessmentId",
                table: "TrainingItems",
                newName: "LibraryItemId");

            migrationBuilder.RenameIndex(
                name: "IX_TrainingItems_AssessmentId",
                table: "TrainingItems",
                newName: "IX_TrainingItems_LibraryItemId");

            migrationBuilder.AddColumn<Guid>(
                name: "AnswerId",
                table: "Annotations",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "GroundTruthId",
                table: "Annotations",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "LibraryItems",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AssessmentId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    GroundTruthSnapshot = table.Column<string>(type: "jsonb", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    PublishedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Version = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LibraryItems", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Annotations_AnswerId",
                table: "Annotations",
                column: "AnswerId");

            migrationBuilder.CreateIndex(
                name: "IX_Annotations_GroundTruthId",
                table: "Annotations",
                column: "GroundTruthId");

            migrationBuilder.AddCheckConstraint(
                name: "CK_Annotation_ExclusiveOwner",
                table: "Annotations",
                sql: "(\"GroundTruthId\" IS NOT NULL AND \"AnswerId\" IS NULL) OR (\"GroundTruthId\" IS NULL AND \"AnswerId\" IS NOT NULL)");

            migrationBuilder.AddForeignKey(
                name: "FK_Annotations_Answers_AnswerId",
                table: "Annotations",
                column: "AnswerId",
                principalTable: "Answers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Annotations_GroundTruths_GroundTruthId",
                table: "Annotations",
                column: "GroundTruthId",
                principalTable: "GroundTruths",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_TrainingItems_LibraryItems_LibraryItemId",
                table: "TrainingItems",
                column: "LibraryItemId",
                principalTable: "LibraryItems",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
