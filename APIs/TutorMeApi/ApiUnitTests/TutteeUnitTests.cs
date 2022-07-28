using System.Reflection;
using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;


namespace ApiUnitTests;

using FluentAssertions;
using Moq;
public class TuteeUnitTests
{
    //DTO
    private static Tutee CreateTutee()
    {
        return new()
        {
            Id = Guid.NewGuid(),
            FirstName = Guid.NewGuid().ToString(),
            LastName = Guid.NewGuid().ToString(),
            DateOfBirth = Guid.NewGuid().ToString(),
            Gender = Guid.NewGuid().ToString(),
            Status = Guid.NewGuid().ToString(),
            Faculty = Guid.NewGuid().ToString(),
            Course = Guid.NewGuid().ToString(),
            Institution = Guid.NewGuid().ToString(),
            Modules = Guid.NewGuid().ToString(),
            Email = Guid.NewGuid().ToString(),
            Password = Guid.NewGuid().ToString(),
            Location = Guid.NewGuid().ToString(),
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = Guid.NewGuid().ToString(),
            Connections = Guid.NewGuid().ToString()

        };
    }
    [Fact]
    public async Task GetTuteeByIdAsync_WithUnExistingTutee_ReturnsNotFound()
    {
        //Arrange

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Type>())).ReturnsAsync((Tutee)null);
        var controller = new TuteesController(repositoryStub.Object);

        //Act
        var result = await controller.GetTuteeById(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetTuteeByIdAsync_WithUnExistingDb_ReturnsFound()
    {
        //Arrange
        var expectedTutee = CreateTutee();
        // id = Guid.NewGuid();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutee));
        var controller = new TuteesController(repositoryStub.Object);

        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetTuteeById(yourGuid);

        //Assert 
        result.Value.Should().BeEquivalentTo(expectedTutee,
              //Verifying all the DTO variables matches the expected Tutee 
              options => options.ComparingByMembers<Tutee>());

    }
    [Fact]
    public async Task GetTuteeByIdAsync_WithAnEmptyDb()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);

        //Act
        var controller = new TuteesController(repositoryStub.Object);

        var result = await controller.GetTuteeById(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //  GetAllTutees
    [Fact]
    public async Task GetAllTuteesAsync_WithExistingItem_ReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new TuteesController(repositoryStub.Object);


        //Act
        Guid.NewGuid();
        var result = await controller.GetAllTutees();

        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetTuteeById Method to return a list of Tutees
    [Fact]
    public async Task GetAllTuteesAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);

        //Act
        var controller = new TuteesController(repositoryStub.Object);

        var result = await controller.GetAllTutees();

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
   
   [Fact]
   public async Task UpdateTutee_With_differentIds_BadRequestResult()
   {
       //Arrange
       var repositoryStub = new Mock<TutorMeContext>();
       var expectedTutee = CreateTutee();
       //Act
       var controller = new TuteesController(repositoryStub.Object);
       var id = Guid.NewGuid();
       var result = await controller.UpdateTutee(id, expectedTutee);

       //Assert     
       Assert.IsType<BadRequestResult>(result);
   }

   [Fact]
   public async Task UpdateTutee_With_same_Id_but_UnExisting_Tutor_returns_NullReferenceException()//####
   {
       //Arrange
       var repositoryStub = new Mock<TutorMeContext>();
       var expectedTutee = CreateTutee();
       //repositoryStub.Setup(repo => repo.Tutees.Find(expectedTutee.Id).Equals(expectedTutee.Id)).Returns(false);
       repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);
       //Act
       var controller = new TuteesController(repositoryStub.Object);
      
        try
        {
           await controller.UpdateTutee(expectedTutee.Id, expectedTutee);
        }
        //Assert   
        catch (Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }
    [Fact]
    public async Task UpdateTutee_WithUnExistingId_NotFound()
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        var expectedTutee = CreateTutee();
        //Act
        var controller = new TuteesController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.UpdateTutee(id, expectedTutee);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public void ModifiesTutee_Returns_NotFoundResult()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
    
        var newTutee = CreateTutee();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutee);
            ctx.SaveChangesAsync();
        }
    
        //Modify the tutors Bio
        newTutee.Bio = "Naruto fan";
        var id = new Guid();
        var unExsistingTutee = CreateTutee();
        unExsistingTutee.Id = id;
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TuteesController(ctx1).UpdateTutee(unExsistingTutee.Id,unExsistingTutee);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }


    [Fact]
    public async Task RegisterTutee_and_returns_a_type_of_Action_Result_returns_null()
    {

        //Arrange
        var expectedTutee = CreateTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutee));
        var controller = new TuteesController(repositoryStub.Object);

        //Act

        var result = await controller.RegisterTutee(expectedTutee);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Tutee>>(result);

    }
    [Fact]
    public async Task RegisterTutee_and_returns_a_type_of_Action()
    {

        //Arrange
        var expectedTutee = CreateTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutee)null);
        var controller = new TuteesController(repositoryStub.Object);

        //Act

        var result = await controller.RegisterTutee(expectedTutee);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Tutee>>(result);
        Assert.Null(result.Value);
    }
    [Fact]
    public async Task RegisterTutee_and_returns_ObjectResult()
    {

        //Arrange
        var expectedTutee = CreateTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);

        var controller = new TuteesController(repositoryStub.Object);

        //Act

        var result = await controller.RegisterTutee(expectedTutee);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Tutee>>(result);
        Assert.IsType<ObjectResult>(result.Result);
    }
    [Fact]
    public async Task RegisterTutee_and_returns_CreatedAtActionResult()
    {

       //Arrange
       var expectedTutee = CreateTutee();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutees.Add(expectedTutee)).Returns((Func<EntityEntry<Tutee>>)null);

       var controller = new TuteesController(repositoryStub.Object);

       //Act

       var result = await controller.RegisterTutee(expectedTutee);
       // Assert
       // Assert.IsType<ActionResult<Api.Models.Tutee>>(result);
       Assert.IsType<CreatedAtActionResult>(result.Result);
   }
   [Fact]
   public async Task RegisterTutee_and_returns_TuteeExists_DbUpdateException()
   {

       //Arrange
       var expectedTutee = CreateTutee();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutees.Add(expectedTutee)).Throws<DbUpdateException>();

        var controller = new TuteesController(repositoryStub.Object);

       //Act
       try
       {
           var result = await controller.RegisterTutee(expectedTutee);
       }
       // Assert
       catch (Exception e)
       {
           Assert.IsType<DbUpdateException>(e);
       }

   }

   [Fact]
   public async Task DeleteTuteeById_and_returns_a_type_of_NotFoundResult()
   {

       //Arrange
       var expectedTutee = CreateTutee();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutee)null);
       var controller = new TuteesController(repositoryStub.Object);

       //Act
       var result = await controller.DeleteTuteeById(expectedTutee.Id);
       // Assert
       Assert.IsType<NotFoundResult>(result);
   }
   // Mock the DeleteTuteeById method  and return a Value 
   [Fact]
   public async Task DeleteTuteeById_and_returns_a_type_of_NoContentResult()
   {

       //Arrange
       var expectedTutee = CreateTutee();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedTutee);
       var controller = new TuteesController(repositoryStub.Object);

       //Act

       var result = await controller.DeleteTuteeById(expectedTutee.Id);
       // Assert
       Assert.IsType<NoContentResult>(result);
   }
   [Fact]
   public async Task DeleteTuteeById_and_returns_a_type_of_NotFound()
   {

       //Arrange
       var expectedTutee = CreateTutee();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);
       var controller = new TuteesController(repositoryStub.Object);

       //Act

       var result = await controller.DeleteTuteeById(expectedTutee.Id);
       // Assert
       Assert.IsType<NotFoundResult>(result);
   }




}

