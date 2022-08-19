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

    [Fact]
    public async Task GetGroupByIdAsync_WithUnExistingGroup_ReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Type>())).ReturnsAsync((Group)null);
        var controller = new GroupsController(repositoryStub.Object);

        //Act
        var result = await controller.GetGroupById(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetGroupByIdAsync_WithAnExistingDb_ReturnsFound()
    {
        //Arrange
        var expectedGroup = CreateGroup();
       
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedGroup));
        var controller = new GroupsController(repositoryStub.Object);

        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetGroupById(yourGuid);

        //Assert 
        result.Value.Should().BeEquivalentTo(expectedGroup,
              //Verifying all the DTO variables matches the expected Group 
              options => options.ComparingByMembers<Group>());

    }

    [Fact]
    public async Task GetGroupByIdAsync_WithAnEmptyDb()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group).Returns((DbSet<Group>)null);

        //Act
        var controller = new GroupsController(repositoryStub.Object);

        var result = await controller.GetGroupById(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetAllGroupsAsync_WithExistingItem_ReturnsNull()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new GroupsController(repositoryStub.Object);


        //Act
        var result = await controller.GetAllGroups();

        //Assert     
        Assert.Null(result.Value);

    }

    [Fact]
    public async Task GetAllGroupsAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group).Returns((DbSet<Group>)null);

        //Act
        var controller = new GroupsController(repositoryStub.Object);

        var result = await controller.GetAllGroups();

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
   
    //Test the UpdateGroup Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task UpdateGroup_With_differentIds_BadRequestResult()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedGroup = CreateGroup();
        //Act
        var controller = new GroupsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.UpdateGroup(id, expectedGroup);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public async Task UpdateGroup_With_same_Id_but_UnExisting_Group_returns_NullReferenceException()//####
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedGroup = CreateGroup();
        //repositoryStub.Setup(repo => repo.Group.Find(expectedGroup.Id).Equals(expectedGroup.Id)).Returns(false);
        repositoryStub.Setup(repo => repo.Group).Returns((DbSet<Group>)null);
        //Act
        var controller = new GroupsController(repositoryStub.Object);
     
        try
        {
            await controller.UpdateGroup(expectedGroup.Id, expectedGroup);
        }
        //Assert   
        catch (Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }

    [Fact]
    public async Task UpdateGroup_WithUnExistingId_NotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedGroup = CreateGroup();
        //Act
        var controller = new GroupsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.UpdateGroup(id, expectedGroup);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }
    
    [Fact]
    public void ModifiesGroup_Returns_NotFoundResult()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
    
        var newGroup = CreateGroup();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newGroup);
            ctx.SaveChangesAsync();
        }
    
        //Modify the tutors Bio
        newGroup.ModuleName = "Software Engineering Cos 301";
        var id = Guid.NewGuid();
        var unExsistingGroup = CreateGroup();
        unExsistingGroup.Id = id;
        Task<IActionResult>  result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupsController(ctx1).UpdateGroup(unExsistingGroup.Id,unExsistingGroup);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }

   [Fact]
   public async Task RegisterGroup_and_returns_a_type_of_Action_Result()
   {

       //Arrange
       var expectedGroup = CreateGroup();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedGroup));
       var controller = new GroupsController(repositoryStub.Object);

       //Act

       var result = await controller.RegisterGroup(expectedGroup);
       // Assert
       Assert.IsType<ActionResult<Api.Models.Group>>(result);
   }

   [Fact]
   public async Task RegisterGroup_and_returns_null()
   {

       //Arrange
       var expectedGroup = CreateGroup();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Group)null);
       var controller = new GroupsController(repositoryStub.Object);

       //Act

       var result = await controller.RegisterGroup(expectedGroup);
       Assert.Null(result.Value);
   }

       [Fact]
   public async Task RegisterGroup_and_returns_ObjectResult()
   {

       //Arrange
       var expectedGroup = CreateGroup();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Group).Returns((DbSet<Group>)null);

       var controller = new GroupsController(repositoryStub.Object);

       //Act

       var result = await controller.RegisterGroup(expectedGroup);
       // Assert
       // Assert.IsType<ActionResult<Api.Models.Group>>(result);
       Assert.IsType<ObjectResult>(result.Result);
   }

    [Fact]
   public async Task RegisterGroup_and_returns_CreatedAtActionResult()
   {

       //Arrange
       var expectedGroup = CreateGroup();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Group.Add(expectedGroup)).Returns((Func<EntityEntry<Group>>)null);

       var controller = new GroupsController(repositoryStub.Object);

       //Act

       var result = await controller.RegisterGroup(expectedGroup);
       // Assert
       // Assert.IsType<ActionResult<Api.Models.Group>>(result);
       Assert.IsType<CreatedAtActionResult>(result.Result);
   }

   [Fact]
   public async Task RegisterGroup_and_returns_GroupExists_DbUpdateException()
   {

       //Arrange
       var expectedGroup = CreateGroup();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Group.Add(expectedGroup)).Throws<DbUpdateException>();

       //repositoryStub.Setup(repo => repo.Group.Update(expectedGroup)).Throws< DbUpdateException>();

       var controller = new GroupsController(repositoryStub.Object);

       //Act
       try
       {
          await controller.RegisterGroup(expectedGroup);
       }
       // Assert
       catch (Exception e)
       {
           Assert.IsType<DbUpdateException>(e);
       }

   }

   [Fact]
   public async Task DeleteGroupById_and_returns_a_type_of_NotFoundResult()
   {

       //Arrange
       var expectedGroup = CreateGroup();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Group)null);
       var controller = new GroupsController(repositoryStub.Object);

        //Act
        var result = await controller.DeleteGroupById(expectedGroup.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
    [Fact]
    public async Task DeleteGroupById_and_returns_a_type_of_NotFound()
    {

        //Arrange
        var expectedTutor = CreateGroup();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group).Returns((DbSet<Group>)null);
        var controller = new GroupsController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteGroupById(expectedTutor.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }

       // Mock the DeleteGroupById method  and return a Value 
   [Fact]
   public async Task DeleteGroupById_and_returns_a_type_of_NoContentResult()
   {

       //Arrange
       var expectedGroup = CreateGroup();

       var repositoryStub = new Mock<TutorMeContext>();
       repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedGroup);
       var controller = new GroupsController(repositoryStub.Object);

        //Act
        var result = await controller.DeleteGroupById(expectedGroup.Id);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
    
}