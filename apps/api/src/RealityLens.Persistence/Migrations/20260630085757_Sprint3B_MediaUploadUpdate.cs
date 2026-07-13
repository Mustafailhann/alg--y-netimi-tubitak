using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RealityLens.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Sprint3B_MediaUploadUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FileType",
                table: "Media");

            migrationBuilder.RenameColumn(
                name: "StorageUrl",
                table: "Media",
                newName: "StoragePath");

            migrationBuilder.RenameColumn(
                name: "FileName",
                table: "Media",
                newName: "OriginalFileName");

            migrationBuilder.AddColumn<string>(
                name: "Checksum",
                table: "Media",
                type: "character varying(64)",
                maxLength: 64,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Extension",
                table: "Media",
                type: "character varying(16)",
                maxLength: 16,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "MimeType",
                table: "Media",
                type: "character varying(128)",
                maxLength: 128,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<DateTime>(
                name: "UploadedAt",
                table: "Media",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<Guid>(
                name: "UploadedByUserId",
                table: "Media",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.UpdateData(
                table: "ManipulationCategories",
                keyColumn: "Id",
                keyValue: new Guid("44444444-4444-4444-4444-444444444444"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636), new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636) });

            migrationBuilder.UpdateData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("11111111-1111-1111-1111-111111111111"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636), new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636) });

            migrationBuilder.UpdateData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("22222222-2222-2222-2222-222222222222"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636), new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636) });

            migrationBuilder.UpdateData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333333"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636), new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636) });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("55555555-5555-5555-5555-555555555555"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636), new DateTime(2026, 6, 30, 8, 57, 57, 275, DateTimeKind.Utc).AddTicks(6636) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Checksum",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "Extension",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "MimeType",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "UploadedAt",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "UploadedByUserId",
                table: "Media");

            migrationBuilder.RenameColumn(
                name: "StoragePath",
                table: "Media",
                newName: "StorageUrl");

            migrationBuilder.RenameColumn(
                name: "OriginalFileName",
                table: "Media",
                newName: "FileName");

            migrationBuilder.AddColumn<string>(
                name: "FileType",
                table: "Media",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "ManipulationCategories",
                keyColumn: "Id",
                keyValue: new Guid("44444444-4444-4444-4444-444444444444"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822), new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822) });

            migrationBuilder.UpdateData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("11111111-1111-1111-1111-111111111111"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822), new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822) });

            migrationBuilder.UpdateData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("22222222-2222-2222-2222-222222222222"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822), new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822) });

            migrationBuilder.UpdateData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333333"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822), new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822) });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("55555555-5555-5555-5555-555555555555"),
                columns: new[] { "CreatedAt", "UpdatedAt" },
                values: new object[] { new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822), new DateTime(2026, 6, 30, 6, 35, 6, 173, DateTimeKind.Utc).AddTicks(1822) });
        }
    }
}
