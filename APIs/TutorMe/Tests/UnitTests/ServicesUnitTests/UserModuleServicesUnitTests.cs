using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using NuGet.ContentModel;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Services;
using TutorMe.Models;
using TutorMe.Services;
using Module = TutorMe.Models.Module;

namespace Tests.UnitTests;

public class UserModuleServicesUnitTests
{
    private readonly Mock<TutorMeContext> _UserModuleRepositoryMock;
   

    public UserModuleServicesUnitTests()
    {
        _UserModuleRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllUserModules_ReturnsListOfUserModules()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
       
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };
        
        var UserModule2 = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(UserModule);
            ctx.Add(UserModule2);
            ctx.SaveChanges();
        }

        IEnumerable<UserModule> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserModuleServices(ctx1).GetAllUserModules();
            
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<UserModule>>(result); 
        Assert.Equal(2, okResult.Count());
        var UserModules = Assert.IsType<List<UserModule>>(okResult);
        Assert.Equal(UserModule.UserModuleId, UserModules[0].UserModuleId);
        Assert.Equal(UserModule2.UserModuleId, UserModules[1].UserModuleId);
       
    }
    
    [Fact]
    public void GetAllUserModules_Returns_Empty_ListOfUserModules()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<UserModule> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserModuleServices(ctx1).GetAllUserModules();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<UserModule>>(result); 
        Assert.Empty(okResult);

    }
    // Test GetUserModulesByUserIdReturnsUserModules
    [Fact]
    public void GetUserModulesByUserId_ReturnsUserModules()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        var expectedModule =  new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
        };
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = expectedModule.ModuleId,
            UserId = Guid.NewGuid(),
        };
        
        var UserModule2 = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = UserModule.UserId,
        };
        var UserModule3 = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(UserModule);
            ctx.Add(UserModule2);
            ctx.Add(UserModule3);
            ctx.Add(expectedModule);
            ctx.SaveChanges();
        }
    
        IEnumerable<Module>  result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserModuleServices(ctx1).GetUserModulesByUserId(UserModule.UserId);
            //ToDo: Must change GetUserModulesByUserId FUNCTIONS to return a list of objects
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Module>>(result); 
        Assert.Equal(1, okResult.Count());
        var UserModules = Assert.IsType<List<Module>>(okResult);
        Assert.Equal(expectedModule.ModuleId, UserModules[0].ModuleId);
        Assert.Equal(expectedModule.Code, UserModules[0].Code);
        Assert.Equal(expectedModule.ModuleName, UserModules[0].ModuleName);
        Assert.Equal(expectedModule.InstitutionId, UserModules[0].InstitutionId);
        Assert.Equal(expectedModule.Faculty, UserModules[0].Faculty);
        Assert.Equal(expectedModule.Year, UserModules[0].Year);
        
    }
    
    // [Fact]
    // public void GetUserModulesByUserId_ReturnsRecord_not_found()
    // {
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //     var expectedModule =  new Module
    //     {
    //         ModuleId  = Guid.NewGuid(),
    //         Code  = "COS 301",
    //         ModuleName ="Software Engineering",
    //         InstitutionId = Guid.NewGuid(),
    //         Faculty ="Faculty of Engineering and Built Environment",
    //         Year = "3",
    //     };
    //     var UserModule = new UserModule
    //     {
    //         UserModuleId = Guid.NewGuid(),
    //         ModuleId = expectedModule.ModuleId,
    //         UserId = Guid.NewGuid(),
    //     };
    //     
    //     var UserModule2 = new UserModule
    //     {
    //         UserModuleId = Guid.NewGuid(),
    //         ModuleId = Guid.NewGuid(),
    //         UserId = UserModule.UserId,
    //     };
    //     var UserModule3 = new UserModule
    //     {
    //         UserModuleId = Guid.NewGuid(),
    //         ModuleId = Guid.NewGuid(),
    //         UserId = Guid.NewGuid(),
    //     };
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         //ctx.Add(UserModule); //UserModule not added
    //         ctx.Add(UserModule2);
    //         ctx.Add(UserModule3);
    //         ctx.Add(expectedModule);
    //        ctx.SaveChanges();
    //     }
    //
    //     IEnumerable<Module>  result;
    //     try
    //     {
    //         using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //         {
    //             result =new UserModuleServices(ctx1).GetUserModulesByUserId(UserModule.UserModuleId);
    //         }
    //     }
    //     catch (Exception e)
    //     {
    //         Assert.Equal("User Module Record not found.", e.Message);
    //     }
    // }
    //
        
    [Fact]
    public async  Task GetUserModuleById_UserModuleId_ReturnsUserModule()
    {
        //arrange
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(UserModule);
            ctx.SaveChanges();
        }

        UserModule result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserModuleServices(ctx1).GetUserModuleById(UserModule.UserModuleId);
        }
        
        
        //act
        Assert.NotNull(result);
        Assert.IsType<UserModule>(result);
        Assert.Equal(UserModule.ModuleId, result.ModuleId);
        Assert.Equal(UserModule.UserModuleId, result.UserModuleId);
        
    }
   
    
    [Fact]
    public async  Task GetUserModuleById_UserModuleId_Returns_UserModule_not_found()
    {
        //arrange
        
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        UserModule result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new UserModuleServices(ctx1).GetUserModuleById(UserModule.UserModuleId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("UserModule not found", e.Message);
        }
      
        
        
       
    }

    
    [Fact]
    public async  Task CreateUserModule_UserModule_Returns_UserModuleId()
    {
        //arrange
        var UserModule = new IUserModule
        {
            // UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };

        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        Guid result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserModuleServices(ctx1).createUserModule(UserModule);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
       
    }
    
    // test CreateUserModule_Returns_createUserModule()
    // [Fact]
    // public async  Task CreateUserModule_Returns_Type_already_exists()
    // {
    //     //arrange
    //     var UserModule = new IUserModule
    //     {
    //         UserModuleId = Guid.NewGuid(),
    //         ModuleId = Guid.NewGuid(),
    //         UserId = Guid.NewGuid(),
    //     };
    //     
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         ctx.Add(UserModule);
    //         ctx.SaveChanges();
    //         // 'IUserModule' was not found. Ensure that the entity type has been added to the model.
    //     }
    //     Guid result;
    //     try
    //     {
    //         using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //         {
    //             result =new UserModuleServices(ctx1).createUserModule(UserModule);
    //         }
    //     }
    //     catch (Exception e)
    //     {
    //         Assert.Equal("This user type already exists, Please log in", e.Message);
    //     }
    //
    // }
    //
    //
    
    [Fact]
    public async Task DeleteUserModuleById_Returns_true()
    {
        //arrange
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(UserModule);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserModuleServices(ctx1).deleteUserModuleById(UserModule.UserModuleId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteUserModuleById_Returns_False()
    {
        //arrange
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
           //Empty TutorMeContext
        }

        bool result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new UserModuleServices(ctx1).deleteUserModuleById(UserModule.UserModuleId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("UserModule not found", e.Message);
        }
    
    }
  
}