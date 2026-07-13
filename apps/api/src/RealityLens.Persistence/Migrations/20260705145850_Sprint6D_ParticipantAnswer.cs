using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RealityLens.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Sprint6D_ParticipantAnswer : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "LastHeartbeatAt",
                table: "Participants",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ParticipantAnswers",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TrainingSessionId = table.Column<Guid>(type: "uuid", nullable: false),
                    ParticipantId = table.Column<Guid>(type: "uuid", nullable: false),
                    TrainingItemId = table.Column<Guid>(type: "uuid", nullable: false),
                    Judgment = table.Column<string>(type: "text", nullable: false),
                    AnnotationId = table.Column<Guid>(type: "uuid", nullable: true),
                    IsCorrect = table.Column<bool>(type: "boolean", nullable: false),
                    ClassificationScore = table.Column<decimal>(type: "numeric", nullable: true),
                    LocalizationScore = table.Column<decimal>(type: "numeric", nullable: true),
                    TotalScore = table.Column<decimal>(type: "numeric", nullable: true),
                    SubmittedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    TimeTakenMilliseconds = table.Column<long>(type: "bigint", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Version = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ParticipantAnswers", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ParticipantAnswers_ParticipantId_TrainingItemId",
                table: "ParticipantAnswers",
                columns: new[] { "ParticipantId", "TrainingItemId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ParticipantAnswers_TrainingSessionId",
                table: "ParticipantAnswers",
                column: "TrainingSessionId");

            migrationBuilder.CreateIndex(
                name: "IX_ParticipantAnswers_TrainingSessionId_ParticipantId",
                table: "ParticipantAnswers",
                columns: new[] { "TrainingSessionId", "ParticipantId" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ParticipantAnswers");

            migrationBuilder.DropColumn(
                name: "LastHeartbeatAt",
                table: "Participants");
        }
    }
}
