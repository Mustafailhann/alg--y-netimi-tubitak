using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace RealityLens.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedDevUsers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "Email", "IsActive", "IsDeleted", "PasswordHash", "RoleId", "UpdatedAt", "Version" },
                values: new object[,]
                {
                    { new Guid("66666666-6666-6666-6666-666666666666"), new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "teacher@realitylens.gov.tr", true, false, "AQAAAAIAAYagAAAAEGv8DVAzG3eUqtvqQEk3PXiHwO9RCf6olWgqQQFI1oqWAbER6ybTyaENB6MfWBQG9g==", new Guid("22222222-2222-2222-2222-222222222222"), new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), new Guid("00000000-0000-0000-0000-000000000001") },
                    { new Guid("77777777-7777-7777-7777-777777777777"), new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "student@realitylens.gov.tr", true, false, "AQAAAAIAAYagAAAAEGv8DVAzG3eUqtvqQEk3PXiHwO9RCf6olWgqQQFI1oqWAbER6ybTyaENB6MfWBQG9g==", new Guid("33333333-3333-3333-3333-333333333333"), new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), new Guid("00000000-0000-0000-0000-000000000001") }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("66666666-6666-6666-6666-666666666666"));

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("77777777-7777-7777-7777-777777777777"));
        }
    }
}
