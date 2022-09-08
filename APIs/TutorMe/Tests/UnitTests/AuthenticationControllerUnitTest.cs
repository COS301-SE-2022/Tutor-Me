using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Moq;
using TutorMe.Controllers;
using TutorMe.Entities;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class AuthenticationControllerUnitTests
{
    private readonly Mock<IUserAuthenticationService> _UserTypeRepositoryMock;
    private static Mock<IMapper> _mapper;

    public AuthenticationControllerUnitTests()
    {
        _UserTypeRepositoryMock = new Mock<IUserAuthenticationService>();
        _mapper = new Mock<IMapper>();
    }

    // Test  User LogInUser(UserLogIn userDetails) method
    [Fact]
    public async Task LogInUser_ReturnsUser()
    {
        // Arrange
        var user = new User
        {
            UserId = new Guid(),
            FirstName = "Thabo",
            LastName = "Maduna",
            DateOfBirth = "02/04/2000",
            Status = true,
            Gender = "M",
            Email = "simphiwendlovu527@gmail.com",
            Password = "12345678",
            UserTypeId = new Guid(),
            InstitutionId = new Guid(),
            Location = "1166 TMN, 0028",
            Bio = "The boys",
            Year = "3",
            Rating = 0
        };

        var expectedUser = new UserLogIn
        {
            Email = "simphiwendlovu527@gmail.com",
            Password = "12345678",
            TypeId = Guid.NewGuid()

        };

        _UserTypeRepositoryMock.Setup(x => x.LogInUser(expectedUser)).Returns(user);
        var controller = new AuthenticationController(_UserTypeRepositoryMock.Object, _mapper.Object);
        var result = controller.LogInUser(expectedUser);
        var okResult = result as OkObjectResult;
        Assert.NotNull(okResult);
        Assert.Equal(200, okResult.StatusCode);
        Assert.Equal(user, okResult.Value);
    }
    //Test LogInUser_Returns Exception
    [Fact]
    public async Task LogInUser_ReturnsExceptionUnauthorizedObjectResult()
    {
        var user = new User
        {
            UserId = new Guid(),
            FirstName = "Thabo",
            LastName = "Maduna",
            DateOfBirth = "02/04/2000",
            Status = true,
            Gender = "M",
            Email = "simphiwendlovu527@gmail.com",
            Password = "12345678",
            UserTypeId = new Guid(),
            InstitutionId = new Guid(),
            Location = "1166 TMN, 0028",
            Bio = "The boys",
            Year = "3",
            Rating = 0
        };
        
        var expectedUser = new UserLogIn
        {
            Email = "simphiwendlovu527@gmail.com",
            Password = "12345678",
            TypeId = Guid.NewGuid()

        };
        var invalidUser = new UserLogIn
        {
            Email = "badbuy@gmail.com",
            Password = "1234567899",
            TypeId = Guid.NewGuid()

        };
        _UserTypeRepositoryMock.Setup(u => u.LogInUser(invalidUser)).Throws<Exception>();
        
        //Act
        var controller = new AuthenticationController(_UserTypeRepositoryMock.Object,_mapper.Object);
        var result =controller.LogInUser(invalidUser);
    
        //Assert     
        Assert.NotNull(result);
        Assert.IsType<UnauthorizedObjectResult>(result);

    }


    
}