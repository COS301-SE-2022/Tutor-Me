using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using NuGet.ContentModel;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Models;
using TutorMe.Services;
using Module = TutorMe.Models.Module;

namespace Tests.UnitTests;

public class ModuleServicesUnitTests
{
    private readonly Mock<TutorMeContext> _ModuleRepositoryMock;
   

    public ModuleServicesUnitTests()
    {
        _ModuleRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllModules_ReturnsListOfModules()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var Module = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
        };
        
        var Module2 = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 332",
            ModuleName ="Computer Networks",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "2",
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Module);
            ctx.Add(Module2);
            ctx.SaveChanges();
        }

        IEnumerable<Module> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModuleServices(ctx1).GetAllModules();
            //ToDo: Must change all getALL FUNCTIONS to return a list of objects
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Module>>(result); 
        Assert.Equal(2, okResult.Count());
        var Modules = Assert.IsType<List<Module>>(okResult);
        Assert.Equal(Module.ModuleId, Modules[0].ModuleId);
        Assert.Equal(Module2.ModuleId, Modules[1].ModuleId);
       
    }
    
    [Fact]
    public void GetAllModules_Returns_Empty_ListOfModules()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<Module> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModuleServices(ctx1).GetAllModules();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Module>>(result); 
        Assert.Empty(okResult);

    }
    
        
    [Fact]
    public async  Task GetModuleById_ModuleId_ReturnsModule()
    {
        //arrange
        var Module = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Module);
            ctx.SaveChanges();
        }

        Module result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModuleServices(ctx1).GetModuleById(Module.ModuleId);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Module>(result);
        Assert.Equal(Module.ModuleId, result.ModuleId);
        Assert.Equal(Module.ModuleId, result.ModuleId);
        
    }
    
    [Fact]
    public async  Task GetModuleById_ModuleId_Returns_Module_not_found()
    {
        //arrange
        var Module = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        Module result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new ModuleServices(ctx1).GetModuleById(Module.ModuleId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("Module not found", e.Message);
        }
      
        
        
       
    }

    
    [Fact]
    public async  Task CreateModule_Module_Returns_ModuleId()
    {
        //arrange
        var Module = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
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
            result =new ModuleServices(ctx1).createModule(Module);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
        Assert.Equal(Module.ModuleId, result);
    }
    
    // test CreateModule_Returns_createModule()
    [Fact]
    public async  Task CreateModule_Returns_Type_already_exists()
    {
        //arrange
        var Module = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Module);
        }
        Guid result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new ModuleServices(ctx1).createModule(Module);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("This user type already exists, Please log in", e.Message);
        }

    }
    
    
    
    [Fact]
    public async Task DeleteModuleById_Returns_true()
    {
        //arrange
        var Module = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Module);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModuleServices(ctx1).deleteModuleById(Module.ModuleId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteModuleById_Returns_False()
    {
        //arrange
        var Module = new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
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
                result =new ModuleServices(ctx1).deleteModuleById(Module.ModuleId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("Module not found", e.Message);
        }
    
    }
  
}