using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Moq;
using TutorMe.Controllers;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class UserTypesTypesControllerUnitTests
{
    private readonly Mock<IUserTypeService> _UserTypeRepositoryMock;
    private static Mock<IMapper> _mapper;

    public UserTypesTypesControllerUnitTests()
    {
        _UserTypeRepositoryMock = new Mock<IUserTypeService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllUserTypes_ListOfUserTypes_ReturnsListOfUserTypes()
    {
    
        //arrange
        List<UserType> UserTypes = new List<UserType>
        {
            new UserType
            {
                UserTypeId = Guid.NewGuid(),
                Type ="Tutor"
            },
            new UserType
            {
                UserTypeId =Guid.NewGuid(),
                Type ="Tutee"
            },
            new UserType
            {
                UserTypeId =Guid.NewGuid(),
                Type ="Tutor"
            }
        };
        
        
        _UserTypeRepositoryMock.Setup(u => u.GetAllUserTypes()).Returns(UserTypes);

        var controller = new UserTypesController(_UserTypeRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllUserTypes();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<UserType>>(actual);
        Assert.Equal(3, (actual as List<UserType>).Count);

    }
    
    [Fact]
    public async  Task GetUserTypeById_UserTypeId_ReturnsUserTypeOfId()
    {
        //arrange
        var UserType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
        };
        
        _UserTypeRepositoryMock.Setup(u => u.GetUserTypeById(UserType.UserTypeId)).Returns(UserType);
        
        var controller = new UserTypesController(_UserTypeRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetUserTypeById(UserType.UserTypeId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<UserType>(actual);
    }
    
    [Fact]
    public async  Task AddUserType_UserType_ReturnsUserType()
    {
        //arrange
        var UserType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
        };
        _UserTypeRepositoryMock.Setup(u => u. createUserType(It.IsAny<UserType>())).Returns(UserType.UserTypeId);
        
        var controller = new UserTypesController(_UserTypeRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.createUserType(UserType);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }
    
    [Fact]
    public async Task DeleteUserTypeById_and_returns_a_type_of_NotFoundResult()
    {

        //Arrange
            var expectedTutor =  new UserType
            {
                UserTypeId = Guid.NewGuid(),
                Type ="Tutor"
            };
            
        _UserTypeRepositoryMock.Setup(repo => repo.deleteUserTypeById(It.IsAny<Guid>())).Returns(true);
        var controller = new  UserTypesController(_UserTypeRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteUserType(expectedTutor.UserTypeId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
}