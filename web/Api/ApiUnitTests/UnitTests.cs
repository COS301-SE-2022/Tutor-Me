using System.Drawing.Printing;
using Api.Controllers;
using Api.Data;
using Api.Models;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing.Constraints;
using Microsoft.EntityFrameworkCore.ValueGeneration;
using Microsoft.Extensions.Options;

namespace ApiUnitTests;

using Moq;
public class UnitTests
{
    [Fact]
    public async Task GetTutorAsync_WithUnexistingTutor_ReturnsNotFound()
    {
        //Arranage
      
        
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Type>())).ReturnsAsync((Tutor)null);
        var controller = new TutorsController(repositoryStub.Object);
        
        //Act
        var result = await controller.GetTutor(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }
    
    
  
}

