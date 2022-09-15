using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class changeRequest : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Requests");

            migrationBuilder.CreateTable(
                name: "Request",
                columns: table => new
                {
                    RequestId = table.Column<Guid>(type: "uniqueidentifier", maxLength: 36, nullable: false, defaultValueSql: "(newid())"),
                    TuteeId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TutorId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DateCreated = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ModuleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Request", x => x.RequestId);
                    table.ForeignKey(
                        name: "Requests_Module_FK",
                        column: x => x.ModuleId,
                        principalTable: "Module",
                        principalColumn: "ModuleId");
                    table.ForeignKey(
                        name: "Requests_Tutee_FK",
                        column: x => x.TuteeId,
                        principalTable: "User",
                        principalColumn: "UserId");
                    table.ForeignKey(
                        name: "Requests_Tutor_FK",
                        column: x => x.TutorId,
                        principalTable: "User",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Requests_ModuleId",
                table: "Request",
                column: "ModuleId");

            migrationBuilder.CreateIndex(
                name: "IX_Requests_TuteeId",
                table: "Request",
                column: "TuteeId");

            migrationBuilder.CreateIndex(
                name: "IX_Requests_TutorId",
                table: "Request",
                column: "TutorId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Request");

            migrationBuilder.CreateTable(
                name: "Requests",
                columns: table => new
                {
                    RequestId = table.Column<Guid>(type: "uniqueidentifier", maxLength: 36, nullable: false, defaultValueSql: "(newid())"),
                    ModuleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TuteeId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TutorId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DateCreated = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Requests", x => x.RequestId);
                    table.ForeignKey(
                        name: "Requests_Module_FK",
                        column: x => x.ModuleId,
                        principalTable: "Module",
                        principalColumn: "ModuleId");
                    table.ForeignKey(
                        name: "Requests_Tutee_FK",
                        column: x => x.TuteeId,
                        principalTable: "User",
                        principalColumn: "UserId");
                    table.ForeignKey(
                        name: "Requests_Tutor_FK",
                        column: x => x.TutorId,
                        principalTable: "User",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Requests_ModuleId",
                table: "Requests",
                column: "ModuleId");

            migrationBuilder.CreateIndex(
                name: "IX_Requests_TuteeId",
                table: "Requests",
                column: "TuteeId");

            migrationBuilder.CreateIndex(
                name: "IX_Requests_TutorId",
                table: "Requests",
                column: "TutorId");
        }
    }
}
