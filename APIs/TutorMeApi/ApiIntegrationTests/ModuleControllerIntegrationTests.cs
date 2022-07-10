using System.Reflection;
using Api.Controllers;
using Api.Data;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Module = Api.Models.Module;


namespace IntegrationTests;

public class ModuleControllerIntegrationTests
{
    //DTO
    private static Module CreateModule()
    {
        return new()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "Software engineering 301",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year=Guid.NewGuid().ToString()
        };
    }
    [Fact]
    public void ListsModulesFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newModule = CreateModule();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newModule);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<IEnumerable<Module>>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new ModulesController(ctx1).GetModules();
            }
            
            
            var okResult = Assert.IsType<ActionResult<IEnumerable<Module >>>(result.Result);

            var modules = Assert.IsType<List<Module>>(okResult.Value);
            var module = Assert.Single(modules);
            Assert.NotNull(module);
        
            Assert.Equal("Software engineering 301", module.ModuleName);
            Assert.Equal("University Of Pretoria", module.Institution);
            Assert.Equal("Faculty of Engineering, Built Environment and IT", module.Faculty);
                
                  module.Should().BeEquivalentTo(newModule,
                //Verifying all the DTO variables matches the expected Module (newModule)
                options => options.ComparingByMembers<Module>());
    }
    
    [Fact]
    public void GetsModuleFromDatabaseById()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newModule = CreateModule();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newModule);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<Module>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new ModulesController(ctx1).GetModule(newModule.Code);
            }
            
  
            var okResult = Assert.IsType<ActionResult<Module >>(result.Result);
            var module = Assert.IsType<Module>(okResult.Value);
            
           
            Assert.NotNull(module);
            Assert.Equal("Software engineering 301", module.ModuleName);
            Assert.Equal("University Of Pretoria", module.Institution);
            Assert.Equal("Faculty of Engineering, Built Environment and IT", module.Faculty);
                
            module.Should().BeEquivalentTo(newModule,
                //Verifying all the DTO variables matches the expected Module (newModule)
                options => options.ComparingByMembers<Module>());
    }


    [Fact]
    public void ModifiesModuleFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newModule = CreateModule();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newModule);
            ctx.SaveChangesAsync();
        }

        //Modify the Modules Name
        newModule.ModuleName = "Computer networks 332";
        
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModulesController(ctx1).PutModule(newModule.Code,newModule);
        }

        // result should be of type NoContentResult
        Assert.IsType<NoContentResult>(result.Result);
        
        //Now checking if the Bio was actually Modified on the database 
        Task<ActionResult<Module>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new ModulesController(ctx1).GetModule(newModule.Code);
        }

        var okResult = Assert.IsType<ActionResult<Module >>(resultCheck.Result);
        var module = Assert.IsType<Module>(okResult.Value);
           
        Assert.NotNull(module);
        Assert.Equal("Computer networks 332", module.ModuleName);
        Assert.Equal("University Of Pretoria", module.Institution);
        Assert.Equal("Faculty of Engineering, Built Environment and IT", module.Faculty);
        module.Should().BeEquivalentTo(newModule,
            //Verifying all the DTO variables matches the expected Module (newModule)
            options => options.ComparingByMembers<Module>());
    }
    
    [Fact]
    public void AddsModuleToDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newModule = CreateModule();

        Task<ActionResult<Module>> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModulesController(ctx1).PostModule(newModule);
        }

        Assert.IsType<ActionResult<Module >>(result.Result);
        
        //Now checking if the Module was actually added to the database 
        Task<ActionResult<Module>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new ModulesController(ctx1).GetModule(newModule.Code);
        }

        var okResult = Assert.IsType<ActionResult<Module >>(resultCheck.Result);
        var module = Assert.IsType<Module>(okResult.Value);
           
        Assert.NotNull(module);
      
        Assert.Equal("Software engineering 301", module.ModuleName);
        Assert.Equal("University Of Pretoria", module.Institution);
        Assert.Equal("Faculty of Engineering, Built Environment and IT", module.Faculty);
        module.Should().BeEquivalentTo(newModule,
            //Verifying all the DTO variables matches the expected Module (newModule)
            options => options.ComparingByMembers<Module>());
    }
    
    [Fact]
    public void DeletesModuleOnDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newModule = CreateModule();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newModule);
            ctx.SaveChangesAsync();
        }
        

        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ModulesController(ctx1).DeleteModule(newModule.Code);
        }

        Assert.IsType< NoContentResult>(result.Result);
        
        //Now checking if the Module was actually deleted to the database 
        Task<ActionResult<Module>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new ModulesController(ctx1).GetModule(newModule.Code);
        }

        var notFoundResult = Assert.IsType<ActionResult<Module >>(resultCheck.Result);
        var module = Assert.IsType<NotFoundResult>(notFoundResult.Result);
        Assert.NotNull(module);
        Assert.Equal(404, module.StatusCode);
        
    }

    }