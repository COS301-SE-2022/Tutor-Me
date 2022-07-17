using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace ApiUnitTests;

using FluentAssertions;
using Moq;
public class GroupUnitTests
{
    //DTO
    private static Group CreateGroup()
    {
        return new()
        { 
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName =Guid.NewGuid().ToString(),
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description=Guid.NewGuid().ToString(),
        };
    }
   

}