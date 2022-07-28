using System.Reflection;
using Api.Controllers;
using Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Module = Api.Models.Module;


namespace ApiUnitTests;

using FluentAssertions;
using Moq;

public class ModulesUnitTests
{
    //DTO
     private  static Module CreateModule() 
    {
        return new()
        {  Code =Guid.NewGuid().ToString(),
           ModuleName = Guid.NewGuid().ToString(),
           Institution = Guid.NewGuid().ToString(),
           Faculty = Guid.NewGuid().ToString(),
        };
    }
    [Fact]
    public async Task GetModuleAsync_WithUnExistingModule_ReturnsNotFound()
    {
        //Arrange
        
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules.FindAsync(It.IsAny<string>())).ReturnsAsync((Module)null);
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        var result = await controller.GetModule(Guid.NewGuid().ToString());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetModuleAsync_WithUnExistingDb_ReturnsFound()
    {   
        //Arrange
        var expectedModule = CreateModule();
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules.FindAsync(It.IsAny<string>())).ReturnsAsync((expectedModule));
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        var yourGuid = Guid.NewGuid().ToString();
        var result = await controller.GetModule(yourGuid);
    
        //Assert 
        result.Value.Should().BeEquivalentTo(expectedModule,
            //Verifying all the DTO variables matches the expected Module 
              options => options.ComparingByMembers<Module>());
        
    }
    [Fact]
    public async Task GetModuleAsync_WithAnEmptyDb()
    {       
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();

        repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);
        
        //Act
        var controller = new ModulesController(repositoryStub.Object);
       
        var result = await controller.GetModule(Guid.NewGuid().ToString());
    
        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //  GetModules
    [Fact]
    public async Task GetModulesAsync_WithExistingItem_ReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new ModulesController(repositoryStub.Object);

          
        //Act
        var result = await controller.GetModules();
    
        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetModule Method to return a list of Modules
    [Fact]
    public async Task GetModulesAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);
        
        //Act
        var controller = new ModulesController(repositoryStub.Object);
       
        var result = await controller.GetModules();
    
        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
  
   
    [Fact]
    public async Task PutModule_With_differentIds_BadRequestResult()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedModule = CreateModule();
         //Act
        var controller = new ModulesController(repositoryStub.Object);
        var id= Guid.NewGuid().ToString();
        var result = await controller.PutModule(id,expectedModule);

        //Assert     
        Assert.IsType< BadRequestResult>(result);
    }
   
    [Fact]
    public async Task PutModule_With_same_Id_but_UnExisting_Module_returns_NullReferenceException()//####
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedModule = CreateModule();
      
       repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);
        //Act
        var controller = new ModulesController(repositoryStub.Object);
         try
        {
          await controller.PutModule(expectedModule.Code,expectedModule);
        }
        //Assert   
        catch(Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }
    [Fact]
    public async Task  PutModule_WithUnExistingId_NotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
       
        var expectedModule = CreateModule();
        //Act
        var controller = new ModulesController(repositoryStub.Object);
        var id= Guid.NewGuid().ToString();
        var result = await controller.PutModule(id,expectedModule);

        //Assert     
        Assert.IsType< BadRequestResult>(result);
    }

    [Fact]
    public void ModifiesModule_Returns_NotFoundResult()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
    
        var newRequest = CreateModule();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newRequest);
            ctx.SaveChangesAsync();
        }
    
        //Modify the tutors Bio
        newRequest.ModuleName = "Software Engineering Cos 301";
        var id = Guid.NewGuid().ToString();
        var unExsistingModule = CreateModule();
        unExsistingModule.Code = id;
        Task<IActionResult>  result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModulesController(ctx1).PutModule(unExsistingModule.Code,unExsistingModule);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }


    [Fact]
    public async Task PostModule_and_returns_a_type_of_Action_Result_returns_null()
    {
         
        //Arrange
        var expectedModule = CreateModule();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules.FindAsync(It.IsAny<string>())).ReturnsAsync((expectedModule));
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.PostModule(expectedModule);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Module>>(result);
      
    }
    [Fact]
     public async Task PostModule_and_returns_a_type_of_Action()
    {
         
        //Arrange
        var expectedModule = CreateModule();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules.FindAsync(It.IsAny<string>())).ReturnsAsync((Module)null);
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.PostModule(expectedModule);
        // Assert
       // Assert.IsType<ActionResult<Api.Models.Module>>(result);
       Assert.Null(result.Value);
    }
     [Fact]
     public async Task PostModule_and_returns_ObjectResult()
     {
         
         //Arrange
         var expectedModule = CreateModule();

         var repositoryStub = new Mock<TutorMeContext>();
         repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);

         var controller = new ModulesController(repositoryStub.Object);
        
         //Act
        
         var result = await controller.PostModule(expectedModule);
         // Assert
         // Assert.IsType<ActionResult<Api.Models.Module>>(result);
         Assert.IsType<ObjectResult>(result.Result);
     }
     [Fact]
     public async Task PostModule_and_returns_CreatedAtActionResult()
     {
         
         //Arrange
         var expectedModule = CreateModule();

         var repositoryStub = new Mock<TutorMeContext>();
         repositoryStub.Setup(repo => repo.Modules.Add(expectedModule)).Returns((Func<EntityEntry<Module>>)null);

         var controller = new ModulesController(repositoryStub.Object);
        
         //Act
        
         var result = await controller.PostModule(expectedModule);
         // Assert
         // Assert.IsType<ActionResult<Api.Models.Module>>(result);
         Assert.IsType<CreatedAtActionResult>(result.Result);
     }
     [Fact]
     public async Task PostModule_and_returns_ModuleExists_DbUpdateException()
     {
         
         //Arrange
         var expectedModule = CreateModule();

         var repositoryStub = new Mock<TutorMeContext>();
         repositoryStub.Setup(repo => repo.Modules.Add(expectedModule)).Throws<DbUpdateException>();

         //repositoryStub.Setup(repo => repo.Modules.Update(expectedModule)).Throws< DbUpdateException>();

         var controller = new ModulesController(repositoryStub.Object);
        
         //Act
         try
         {
             await controller.PostModule(expectedModule);
         }
         // Assert
         catch(Exception e)
         {
             Assert.IsType<DbUpdateException>(e);
         }
         
     }
  
    [Fact]  
    public async Task DeleteModule_and_returns_a_type_of_NotFoundResult()
    {
         
        //Arrange
        var expectedModule = CreateModule();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules.FindAsync(It.IsAny<string>())).ReturnsAsync((Module)null);
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        var result = await controller.DeleteModule(expectedModule.Code);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
     // Mock the DeleteModule method  and return a Value 
    [Fact]
    public async Task DeleteModule_and_returns_a_type_of_NoContentResult()
    {
         
        //Arrange
        var expectedModule = CreateModule();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules.FindAsync(It.IsAny<string>())).ReturnsAsync(expectedModule);
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.DeleteModule(expectedModule.Code);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
    [Fact]
    public async Task DeleteModule_and_returns_a_type_of_NotFound()
    {
         
        //Arrange
        var expectedModule = CreateModule();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.DeleteModule(expectedModule.Code);
        // Assert
        Assert.IsType< NotFoundResult>(result);
    }
    



}

