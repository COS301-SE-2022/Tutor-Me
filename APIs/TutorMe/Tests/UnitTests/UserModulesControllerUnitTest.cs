using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using NuGet.Versioning;
using TutorMe.Controllers;
using TutorMe.Data;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class UsersModuleControllerUnitTests
{
    private readonly Mock<IUserModuleService> _UserModuleRepositoryMock;
    private static Mock<IMapper> _mapper;

    public UsersModuleControllerUnitTests()
    {
        _UserModuleRepositoryMock = new Mock<IUserModuleService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllUserModules_ListOfUserModules_ReturnsListOfUserModules()
    {
    
        //arrange
        List<UserModule> UserModules = new List<UserModule>
        {
            new UserModule
            {
                UserModuleId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
                UserId = Guid.NewGuid(),

            },
            new UserModule
            {
                UserModuleId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
                UserId = Guid.NewGuid(),

            },
            new UserModule
            {
                UserModuleId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
                UserId = Guid.NewGuid(),

            }
        };
        
        
        _UserModuleRepositoryMock.Setup(u => u.GetAllUserModules()).Returns(UserModules);

        var controller = new UserModulesController(_UserModuleRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllUserModules();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<UserModule>>(actual);
        Assert.Equal(3, (actual as List<UserModule>).Count);

    }
    
    [Fact]
    public async  Task GetUserModuleById_UserModuleId_ReturnsUserModuleOfId()
    {
        //arrange
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),

        };
        
        _UserModuleRepositoryMock.Setup(u => u.GetUserModuleById(UserModule.UserModuleId)).Returns(UserModule);
        
        var controller = new UserModulesController(_UserModuleRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetUserModuleById(UserModule.UserModuleId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<UserModule>(actual);
    }
    
    [Fact]
    public async  Task AddUserModule_UserModule_ReturnsUserModule()
    {
        //arrange
        var UserModule = new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),

        };
        _UserModuleRepositoryMock.Setup(u => u. createUserModule(It.IsAny<UserModule>())).Returns(UserModule.UserModuleId);
        
        var controller = new UserModulesController(_UserModuleRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.createUserModule(UserModule);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }
    
 
    
    [Fact]
    public async Task DeleteUserModuleById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),

        };
            
        _UserModuleRepositoryMock.Setup(repo => repo.deleteUserModuleById(It.IsAny<Guid>())).Returns(true);
        var controller = new  UserModulesController(_UserModuleRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteUserModule(expectedTutor.UserModuleId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
    [Fact]
    public async Task DeleteUserModuleById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new UserModule
        {
            UserModuleId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),

        };
            
        _UserModuleRepositoryMock.Setup(repo => repo.deleteUserModuleById(It.IsAny<Guid>())).Returns(false);
        var controller = new  UserModulesController(_UserModuleRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteUserModule(expectedTutor.UserModuleId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(false, actual);

    }
  
}