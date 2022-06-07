using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;

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

    // [Fact]
    // public async Task GetTutorAsync_WithExistingItem_ReturnsFound()
    // {
       
    //     //Arranage
    //     var expectedTutor = createTutor();
    //     // id = Guid.NewGuid();
        
    //     var repositoryStub = new Mock<TutorMeContext>();
    //     repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutor));
    //     var controller = new TutorsController(repositoryStub.Object);
        
    //     //Act
    //     Guid yourGuid = Guid.NewGuid();
    //     var result = await controller.GetTutor(yourGuid);
    
    //     //Assert     
      
    
    //          result.Value.Should().BeEquivalentTo(expectedTutor,
    //         //Verifying all the DTO variables matches the expected Tutor 
    //           options => options.ComparingByMembers<Tutor>());
        
    // }
    // //DTO
    //  private Tutor createTutor() 
    // {
    //     return new()
    //     {
    //         Id = Guid.NewGuid(),
    //         FirstName = Guid.NewGuid().ToString(),
    //         LastName = Guid.NewGuid().ToString(),
    //         Age = Guid.NewGuid().ToString(),
    //         Gender = Guid.NewGuid().ToString(),
    //         Institution = Guid.NewGuid().ToString(),
    //         Modules = Guid.NewGuid().ToString(),
    //         Email = Guid.NewGuid().ToString(),
    //         Password = Guid.NewGuid().ToString(),
    //         Location = Guid.NewGuid().ToString(),
    //         TuteesCode = Guid.NewGuid().ToString(),
    //         Bio = Guid.NewGuid().ToString(),
    //         Connections = Guid.NewGuid().ToString(),
    //     };
    // }
    
    
  
}

