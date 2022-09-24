using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class addEventOwner : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "OwnerId",
                table: "Event",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<string>(
                name: "TimeOfEvent",
                table: "Event",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Event_OwnerId",
                table: "Event",
                column: "OwnerId");

            migrationBuilder.AddForeignKey(
                name: "Events_Owner_FK",
                table: "Event",
                column: "OwnerId",
                principalTable: "User",
                principalColumn: "UserId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "Events_Owner_FK",
                table: "Event");

            migrationBuilder.DropIndex(
                name: "IX_Event_OwnerId",
                table: "Event");

            migrationBuilder.DropColumn(
                name: "OwnerId",
                table: "Event");

            migrationBuilder.DropColumn(
                name: "TimeOfEvent",
                table: "Event");
        }
    }
}
