using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class removeTuteesUserIdConnections : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Connections_TuteeUserId",
                table: "Connection");

            migrationBuilder.DropColumn(
                name: "TuteeUserId",
                table: "Connection");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "TuteeUserId",
                table: "Connection",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Connections_TuteeUserId",
                table: "Connection",
                column: "TuteeUserId");
        }
    }
}
