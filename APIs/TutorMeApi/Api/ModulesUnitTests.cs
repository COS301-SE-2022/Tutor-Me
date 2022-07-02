using System.Data.Common;
using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Moq;

namespace ApiUnitTests;

using FluentAssertions;
using Moq;

public class ModulesUnitTests
{
     List<Module> _expectedModules=new List <Module>{ createModule(), createModule(), createModule(), createModule() };

      //DTO
     private  static Module createModule() 
    {
        return new()
        { 
            Code =Guid.NewGuid().ToString(),
           ModuleName = Guid.NewGuid().ToString(),
        Institution = Guid.NewGuid().ToString(),
           Faculty = Guid.NewGuid().ToString(),
        };
    }
    [Fact]
    public async Task GetModuleAsync_WithUnexistingModule_ReturnsNotFound()
    {
        //Arranage
        
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
        //Arranage
        var expectedModule = createModule();
        // id = Guid.NewGuid().ToString();
        
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
    public async Task GetModuleAsync_WithanEmpyDb()
    {       
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
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
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new ModulesController(repositoryStub.Object);

          
        //Act
        var yourGuid = Guid.NewGuid().ToString();
        var result = await controller.GetModules();
    
        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetModule Method to return a list of Modules
    [Fact]
    public async Task GetModulesAsync_WithExistingItemReturnsFound()
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);
        
        //Act
        var controller = new ModulesController(repositoryStub.Object);
       
        var result = await controller.GetModules();
    
        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
  
    //Test the PutModule Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task PutModule_With_differentIds_BadRequestResult()
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        var expectedModule = createModule();
         //Act
        var controller = new ModulesController(repositoryStub.Object);
        var id= Guid.NewGuid().ToString();
        var email= Guid.NewGuid().ToString();
        var result = await controller.PutModule(id,expectedModule);

        //Assert     
        Assert.IsType< BadRequestResult>(result);
    }
   
    [Fact]
    public async Task PutModule_With_same_Id_but_UnExisting_Module_returns_NullReferenceException()//####
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        var expectedModule = createModule();
        //repositoryStub.Setup(repo => repo.Modules.Find(expectedModule.Id).Equals(expectedModule.Id)).Returns(false);
       repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);
        //Act
        var controller = new ModulesController(repositoryStub.Object);
        var id= Guid.NewGuid().ToString();
        var email= Guid.NewGuid().ToString();
        try
        {
            var result = await controller.PutModule(expectedModule.Code,expectedModule);
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
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        var expectedModule = createModule();
        //Act
        var controller = new ModulesController(repositoryStub.Object);
        var id= Guid.NewGuid().ToString();
        var email= Guid.NewGuid().ToString();
        var result = await controller.PutModule(id,expectedModule);

        //Assert     
        Assert.IsType< BadRequestResult>(result);
    }

 


    [Fact]
    public async Task PostModule_and_returns_a_type_of_Action_Result_returns_null()
    {
         
        //Arranage
        var expectedModule = createModule();

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
         
        //Arranage
        var expectedModule = createModule();

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
         
         //Arranage
         var expectedModule = createModule();

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
         
         //Arranage
         var expectedModule = createModule();

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
         
         //Arranage
         var expectedModule = createModule();

         var repositoryStub = new Mock<TutorMeContext>();
         repositoryStub.Setup(repo => repo.Modules.Add(expectedModule)).Throws<DbUpdateException>();

         //repositoryStub.Setup(repo => repo.Modules.Update(expectedModule)).Throws< DbUpdateException>();

         var controller = new ModulesController(repositoryStub.Object);
        
         //Act
         try
         {
             var result = await controller.PostModule(expectedModule);
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
         
        //Arranage
        var expectedModule = createModule();

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
         
        //Arranage
        var expectedModule = createModule();

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
         
        //Arranage
        var expectedModule = createModule();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Modules).Returns((DbSet<Module>)null);
        var controller = new ModulesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.DeleteModule(expectedModule.Code);
        // Assert
        Assert.IsType< NotFoundResult>(result);
    }
    



}

