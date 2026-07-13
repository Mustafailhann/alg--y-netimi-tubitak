using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RealityLens.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class MultipleAnnotationsSupport : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AnnotationId",
                table: "ParticipantAnswers");

            migrationBuilder.DropColumn(
                name: "AnnotationId",
                table: "GroundTruths");

            migrationBuilder.AddColumn<Guid>(
                name: "GroundTruthId",
                table: "Annotations",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "ParticipantAnswerId",
                table: "Annotations",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Annotations_GroundTruthId",
                table: "Annotations",
                column: "GroundTruthId");

            migrationBuilder.CreateIndex(
                name: "IX_Annotations_ParticipantAnswerId",
                table: "Annotations",
                column: "ParticipantAnswerId");

            migrationBuilder.AddForeignKey(
                name: "FK_Annotations_GroundTruths_GroundTruthId",
                table: "Annotations",
                column: "GroundTruthId",
                principalTable: "GroundTruths",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Annotations_ParticipantAnswers_ParticipantAnswerId",
                table: "Annotations",
                column: "ParticipantAnswerId",
                principalTable: "ParticipantAnswers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Annotations_GroundTruths_GroundTruthId",
                table: "Annotations");

            migrationBuilder.DropForeignKey(
                name: "FK_Annotations_ParticipantAnswers_ParticipantAnswerId",
                table: "Annotations");

            migrationBuilder.DropIndex(
                name: "IX_Annotations_GroundTruthId",
                table: "Annotations");

            migrationBuilder.DropIndex(
                name: "IX_Annotations_ParticipantAnswerId",
                table: "Annotations");

            migrationBuilder.DropColumn(
                name: "GroundTruthId",
                table: "Annotations");

            migrationBuilder.DropColumn(
                name: "ParticipantAnswerId",
                table: "Annotations");

            migrationBuilder.AddColumn<Guid>(
                name: "AnnotationId",
                table: "ParticipantAnswers",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "AnnotationId",
                table: "GroundTruths",
                type: "uuid",
                nullable: true);
        }
    }
}
