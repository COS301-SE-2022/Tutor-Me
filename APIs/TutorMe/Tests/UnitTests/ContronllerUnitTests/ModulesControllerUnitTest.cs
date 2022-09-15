using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Moq;
using TutorMe.Controllers;
using TutorMe.Models;
using TutorMe.Services;
using Module = TutorMe.Models.Module;

namespace Tests.UnitTests;

public class ModulesControllerUnitTests
{
    private readonly Mock<IModuleService> _ModuleRepositoryMock;
    private static Mock<IMapper> _mapper;

    public ModulesControllerUnitTests()
    {
        _ModuleRepositoryMock = new Mock<IModuleService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllModules_ListOfModules_ReturnsListOfModules()
    {
    
        //arrange
        List<Module> Modules = new List<Module>
        {
            new Module
            {
                ModuleId  = Guid.NewGuid(),
                Code  = "COS 301",
                ModuleName ="Software Engineering",
                InstitutionId = Guid.NewGuid(),
                Faculty ="Faculty of Engineering and Built Environment",
                Year = "3",
            },
            new Module
            {
                ModuleId  = Guid.NewGuid(),
                Code  = "COS 332",
                ModuleName ="Computer Networks",
                InstitutionId = Guid.NewGuid(),
                Faculty ="Faculty of Engineering and Built Environment",
                Year = "2",
            },
            new Module
            {
                ModuleId  = Guid.NewGuid(),
                Code  = "COS 333",
                ModuleName ="Computer Systems",
                InstitutionId = Guid.NewGuid(),
                Faculty ="Faculty of Engineering and Built Environment",
                Year = "2",
            }
        };
        
        
        _ModuleRepositoryMock.Setup(u => u.GetAllModules()).Returns(Modules);

        var controller = new ModulesController(_ModuleRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllModules();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Module>>(actual);
        Assert.Equal(3, (actual as List<Module>).Count);

    }
    [Fact]
    public async  Task GetModuleById_ModuleId_ReturnsModuleById()
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
        
        _ModuleRepositoryMock.Setup(u => u.GetModuleById(Module.ModuleId)).Returns(Module);
        
        var controller = new ModulesController(_ModuleRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetModuleById(Module.ModuleId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Module>(actual);
    }

    
    [Fact]
    public async  Task AddModule_Module_ReturnsModule()
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
        _ModuleRepositoryMock.Setup(u => u. createModule(It.IsAny<Module>())).Returns(Module.ModuleId);
        
        var controller = new ModulesController(_ModuleRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.createModule(Module);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }

       
    [Fact]
    public async Task DeleteModuleById_Returns_True()
    {
        //Arrange
            var expectedModule =  new Module
            {
                ModuleId  = Guid.NewGuid(),
                Code  = "COS 301",
                ModuleName ="Software Engineering",
                InstitutionId = Guid.NewGuid(),
                Faculty ="Faculty of Engineering and Built Environment",
                Year = "3",
            };
            
        _ModuleRepositoryMock.Setup(repo => repo.deleteModuleById(It.IsAny<Guid>())).Returns(true);
        var controller = new  ModulesController(_ModuleRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteModule(expectedModule.ModuleId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);
    
    }
    [Fact]
    public async Task DeleteModuleById_Returns_False()
    {
        //Arrange
        var expectedModule =  new Module
        {
            ModuleId  = Guid.NewGuid(),
            Code  = "COS 301",
            ModuleName ="Software Engineering",
            InstitutionId = Guid.NewGuid(),
            Faculty ="Faculty of Engineering and Built Environment",
            Year = "3",
        };
            
        _ModuleRepositoryMock.Setup(repo => repo.deleteModuleById(It.IsAny<Guid>())).Returns(false);
        var controller = new  ModulesController(_ModuleRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteModule(expectedModule.ModuleId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(false, actual);
    }
    
}