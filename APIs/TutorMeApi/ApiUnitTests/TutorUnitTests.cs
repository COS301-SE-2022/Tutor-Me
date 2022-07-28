using System.Reflection;
using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;


namespace ApiUnitTests;
using FluentAssertions;
using Moq;
public class TutorUnitTests
{
    //DTO
    private static Tutor CreateTutor()
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
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = Guid.NewGuid().ToString(),
            Connections = Guid.NewGuid().ToString(),
            Rating = Guid.NewGuid().ToString(),
            Year=Guid.NewGuid().ToString()
        };
    }
    [Fact]
    public async Task GetTutorAsync_WithUnExistingTutor_ReturnsNotFound()
    {
        //Arrange

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Type>())).ReturnsAsync((Tutor)null);
        var controller = new TutorsController(repositoryStub.Object);

        //Act
        var result = await controller.GetTutor(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetTutorAsync_WithUnExistingDb_ReturnsFound()
    {
        //Arrange
        var expectedTutor = CreateTutor();
       
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutor));
        var controller = new TutorsController(repositoryStub.Object);

        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetTutor(yourGuid);

        //Assert 
        result.Value.Should().BeEquivalentTo(expectedTutor,
              //Verifying all the DTO variables matches the expected Tutor 
              options => options.ComparingByMembers<Tutor>());

    }
    [Fact]
    public async Task GetTutorAsync_WithAnEmptyDb()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors).Returns((DbSet<Tutor>)null);

        //Act
        var controller = new TutorsController(repositoryStub.Object);

        var result = await controller.GetTutor(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //  GetTutors
    [Fact]
    public async Task GetTutorsAsync_WithExistingItem_ReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new TutorsController(repositoryStub.Object);


        //Act
        var result = await controller.GetTutors();

        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetTutor Method to return a list of tutors
    [Fact]
    public async Task GetTutorsAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors).Returns((DbSet<Tutor>)null);

        //Act
        var controller = new TutorsController(repositoryStub.Object);

        var result = await controller.GetTutors();

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    [Fact]
    public async Task GetTutorByEmail_WithExistingEmailReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors).Returns((DbSet<Tutor>)null);

        //Act
        var controller = new TutorsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var email = Guid.NewGuid().ToString();
        var result = await controller.GetTutorByEmail(email, id);

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //Test the PutTutor Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task PutTutor_With_differentIds_BadRequestResult()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedTutor = CreateTutor();
        //Act
        var controller = new TutorsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.PutTutor(id, expectedTutor);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }
     [Fact]
    public void ModifiesTutor_Returns_NotFoundResult()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
    
        var newTutor = CreateTutor();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutor);
            ctx.SaveChangesAsync();
        }
    
        //Modify the tutors Bio
        newTutor.Bio = "Naruto fan";
        var id = new Guid();
        var unExsistingTutor = CreateTutor();
        unExsistingTutor.Id = id;
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TutorsController(ctx1).PutTutor(unExsistingTutor.Id,unExsistingTutor);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }
    

    [Fact]
    public async Task PutTutor_With_same_Id_but_UnExisting_Tutor_returns_NullReferenceException()//####
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedTutor = CreateTutor();
        //repositoryStub.Setup(repo => repo.Tutors.Find(expectedTutor.Id).Equals(expectedTutor.Id)).Returns(false);
        repositoryStub.Setup(repo => repo.Tutors).Returns((DbSet<Tutor>)null);
        //Act
        var controller = new TutorsController(repositoryStub.Object);
     
       try
       {
           await controller.PutTutor(expectedTutor.Id, expectedTutor);
       }
       //Assert   
       catch (Exception e)
       {
           Assert.IsType<NullReferenceException>(e);
       }

   }
   [Fact]
   public async Task PutTutor_WithUnExistingId_NotFound()
   {
       //Arrange
       var repositoryStub = new Mock<TutorMeContext>();
       var expectedTutor = CreateTutor();
       //Act
       var controller = new TutorsController(repositoryStub.Object);
       var id = Guid.NewGuid();
       var result = await controller.PutTutor(id, expectedTutor);

       //Assert     
       Assert.IsType<BadRequestResult>(result);
   }



    [Fact]
    public async Task PostTutor_and_returns_a_type_of_Action_Result_returns_null()
    {

        //Arrange
        var expectedTutor = CreateTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutor));
        var controller = new TutorsController(repositoryStub.Object);

        //Act

        var result = await controller.PostTutor(expectedTutor);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Tutor>>(result);
    }
    [Fact]
    public async Task PostTutor_and_returns_a_type_of_Action()
    {

        //Arrange
        var expectedTutor = CreateTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutor)null);
        var controller = new TutorsController(repositoryStub.Object);

        //Act

        var result = await controller.PostTutor(expectedTutor);
        Assert.Null(result.Value);
    }
    [Fact]
    public async Task PostTutor_and_returns_ObjectResult()
    {

        //Arrange
        var expectedTutor = CreateTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors).Returns((DbSet<Tutor>)null);

        var controller = new TutorsController(repositoryStub.Object);

        //Act

        var result = await controller.PostTutor(expectedTutor);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Tutor>>(result);
        Assert.IsType<ObjectResult>(result.Result);
    }
    [Fact]
    public async Task PostTutor_and_returns_CreatedAtActionResult()
    {

        //Arrange
        var expectedTutor = CreateTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.Add(expectedTutor)).Returns((Func<EntityEntry<Tutor>>)null);

       var controller = new TutorsController(repositoryStub.Object);

       //Act

       var result = await controller.PostTutor(expectedTutor);
       // Assert
       // Assert.IsType<ActionResult<Api.Models.Tutor>>(result);
       Assert.IsType<CreatedAtActionResult>(result.Result);
   }
   [Fact]
   public async Task PostTutor_and_returns_TutorExists_DbUpdateException()
   {

       //Arrange
       var expectedTutor = CreateTutor();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutors.Add(expectedTutor)).Throws<DbUpdateException>();

       //repositoryStub.Setup(repo => repo.Tutors.Update(expectedTutor)).Throws< DbUpdateException>();

       var controller = new TutorsController(repositoryStub.Object);

       //Act
       try
       {
          await controller.PostTutor(expectedTutor);
       }
       // Assert
       catch (Exception e)
       {
           Assert.IsType<DbUpdateException>(e);
       }

   }

   [Fact]
   public async Task DeleteTutor_and_returns_a_type_of_NotFoundResult()
   {

       //Arrange
       var expectedTutor = CreateTutor();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutor)null);
       var controller = new TutorsController(repositoryStub.Object);

       //Act
       var result = await controller.DeleteTutor(expectedTutor.Id);
       // Assert
       Assert.IsType<NotFoundResult>(result);
   }
   // Mock the DeleteTutor method  and return a Value 
   [Fact]
   public async Task DeleteTutor_and_returns_a_type_of_NoContentResult()
   {

       //Arrange
       var expectedTutor = CreateTutor();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedTutor);
       var controller = new TutorsController(repositoryStub.Object);

       //Act

       var result = await controller.DeleteTutor(expectedTutor.Id);
       // Assert
       Assert.IsType<NoContentResult>(result);
   }
   [Fact]
   public async Task DeleteTutor_and_returns_a_type_of_NotFound()
   {

       //Arrange
       var expectedTutor = CreateTutor();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Tutors).Returns((DbSet<Tutor>)null);
       var controller = new TutorsController(repositoryStub.Object);

       //Act

       var result = await controller.DeleteTutor(expectedTutor.Id);
       // Assert
       Assert.IsType<NotFoundResult>(result);
   }




}

