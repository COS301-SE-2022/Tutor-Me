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
public class AdminUnitTests
{
    //DTO
    private static Admin CreateAdmin()
    {
        return new()
        { 
            Id =Guid.NewGuid(),
            Name ="Farai",
            Email ="FaraiChivunga@gmail.com",
            Password ="12345@adminFarai"
        };
    }

    [Fact]
    public async Task GetAdminAsync_WithUnExistingAdmin_ReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.FindAsync(It.IsAny<Type>())).ReturnsAsync((Admin)null);
        var controller = new AdminsController(repositoryStub.Object);

        //Act
        var result = await controller.GetAdmin(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetAdminAsync_WithAnExistingDb_ReturnsFound()
    {
        //Arrange
        var expectedAdmin = CreateAdmin();
       
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedAdmin));
        var controller = new AdminsController(repositoryStub.Object);

        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetAdmin(yourGuid);

        //Assert 
        result.Value.Should().BeEquivalentTo(expectedAdmin,
              //Verifying all the DTO variables matches the expected Admin 
              options => options.ComparingByMembers<Admin>());
    }

    [Fact]
    public async Task GetAdminAsync_WithAnEmptyDb()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin).Returns((DbSet<Admin>)null);

        //Act
        var controller = new AdminsController(repositoryStub.Object);

        var result = await controller.GetAdmin(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetAdminsAsync_WithExistingItem_ReturnsNull()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new AdminsController(repositoryStub.Object);


        //Act
        var result = await controller.GetAdmin();

        //Assert     
        Assert.Null(result.Value);

    }

    [Fact]
    public async Task GetAdminsAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin).Returns((DbSet<Admin>)null);

        //Act
        var controller = new AdminsController(repositoryStub.Object);

        var result = await controller.GetAdmin();

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
   
    //Test the PutAdmin Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task PutAdmin_With_differentIds_BadRequestResult()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedAdmin = CreateAdmin();
        //Act
        var controller = new AdminsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.PutAdmin(id, expectedAdmin);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public async Task PutAdmin_With_same_Id_but_UnExisting_Admin_returns_NullReferenceException()//####
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedAdmin = CreateAdmin();
        //repositoryStub.Setup(repo => repo.Admin.Find(expectedAdmin.Id).Equals(expectedAdmin.Id)).Returns(false);
        repositoryStub.Setup(repo => repo.Admin).Returns((DbSet<Admin>)null);
        //Act
        var controller = new AdminsController(repositoryStub.Object);
     
        try
        {
            await controller.PutAdmin(expectedAdmin.Id, expectedAdmin);
        }
        //Assert   
        catch (Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }

    [Fact]
    public async Task PutAdmin_WithUnExistingId_NotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedAdmin = CreateAdmin();
        //Act
        var controller = new AdminsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.PutAdmin(id, expectedAdmin);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }
    
    [Fact]
    public void ModifiesAdmin_Returns_NotFoundResult()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
    
        var newAdmin = CreateAdmin();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newAdmin);
            ctx.SaveChangesAsync();
        }
    
        //Modify the tutors Bio
        newAdmin.Email = "Fari@gmail.com";
        var id = Guid.NewGuid();
        var unExsistingAdmin = CreateAdmin();
        unExsistingAdmin.Id = id;
        Task<IActionResult>  result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new AdminsController(ctx1).PutAdmin(unExsistingAdmin.Id,unExsistingAdmin);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }

    [Fact]
    public async Task PostAdmin_and_returns_a_type_of_Action_Result()
    {

        //Arrange
        var expectedAdmin = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedAdmin));
        var controller = new AdminsController(repositoryStub.Object);

        //Act

        var result = await controller.PostAdmin(expectedAdmin);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Admin>>(result);
    }

    [Fact]
    public async Task PostAdmin_and_returns_null()
    {

        //Arrange
        var expectedAdmin = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Admin)null);
        var controller = new AdminsController(repositoryStub.Object);

        //Act

        var result = await controller.PostAdmin(expectedAdmin);
        Assert.Null(result.Value);
    }

        [Fact]
    public async Task PostAdmin_and_returns_ObjectResult()
    {

        //Arrange
        var expectedAdmin = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin).Returns((DbSet<Admin>)null);

        var controller = new AdminsController(repositoryStub.Object);

        //Act

        var result = await controller.PostAdmin(expectedAdmin);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Admin>>(result);
        Assert.IsType<ObjectResult>(result.Result);
    }

     [Fact]
    public async Task PostAdmin_and_returns_CreatedAtActionResult()
    {

        //Arrange
        var expectedAdmin = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.Add(expectedAdmin)).Returns((Func<EntityEntry<Admin>>)null);

        var controller = new AdminsController(repositoryStub.Object);

        //Act

        var result = await controller.PostAdmin(expectedAdmin);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Admin>>(result);
        Assert.IsType<CreatedAtActionResult>(result.Result);
    }

    [Fact]
    public async Task PostAdmin_and_returns_AdminExists_DbUpdateException()
    {

        //Arrange
        var expectedAdmin = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.Add(expectedAdmin)).Throws<DbUpdateException>();

        //repositoryStub.Setup(repo => repo.Admin.Update(expectedAdmin)).Throws< DbUpdateException>();

        var controller = new AdminsController(repositoryStub.Object);

        //Act
        try
        {
           await controller.PostAdmin(expectedAdmin);
        }
        // Assert
        catch (Exception e)
        {
            Assert.IsType<DbUpdateException>(e);
        }

    }

    [Fact]
    public async Task DeleteAdmin_and_returns_a_type_of_NotFoundResult()
    {

        //Arrange
        var expectedAdmin = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Admin)null);
        var controller = new AdminsController(repositoryStub.Object);

        //Act
        var result = await controller.DeleteAdmin(expectedAdmin.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
    [Fact]
    public async Task DeleteAdmin_and_returns_a_type_of_NotFound()
    {

        //Arrange
        var expectedTutor = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin).Returns((DbSet<Admin>)null);
        var controller = new AdminsController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteAdmin(expectedTutor.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }

        // Mock the DeleteAdmin method  and return a Value 
    [Fact]
    public async Task DeleteAdmin_and_returns_a_type_of_NoContentResult()
    {

        //Arrange
        var expectedAdmin = CreateAdmin();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Admin.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedAdmin);
        var controller = new AdminsController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteAdmin(expectedAdmin.Id);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
    
}