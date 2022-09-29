
using AutoMapper;
using Microsoft.AspNetCore.Mvc;

using Moq;
using NuGet.Versioning;
using TutorMe.Controllers;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class AccountControllerUnitTests
{
    private readonly Mock<IJwtService> _JwtRepositoryMock;
    private readonly TutorMeContext _TutorMeContextMock;
    private static Mock<IMapper> _mapper;

    public AccountControllerUnitTests()
    {
        // _TutorMeContextMock = new Mock<TutorMeContext>();
        _JwtRepositoryMock = new Mock<IJwtService>();
        _mapper = new Mock<IMapper>();
    }
    
    //test AuthToken method to return a token and a user object if the user is found
    [Fact]
    public async Task AuthToken_ReturnsTokenAndUser_IfUserIsFound()
    {
        //Arrange
        UserLogIn authRequest = new UserLogIn
        {
            Email = Guid.Empty.ToString(),
            Password = Guid.Empty.ToString(),
            TypeId = Guid.Empty

        };
        var resp = new AuthResponse
            { Token = Guid.NewGuid().ToString(), RefreshToken = Guid.NewGuid().ToString(), IsSuccess = true };
       
            

        var controller = new AccountController(_JwtRepositoryMock.Object,_TutorMeContextMock);

        try
        {
            controller.AuthToken(authRequest);
        }
        catch (Exception e)
        {
            Assert.IsType<BadRequestObjectResult>(e);
            Assert.Equal("UserName and Password must be provided.", e.Message);
        }

    }
    
    [Fact]
    public async Task AuthToken_ReturnsUnauthorized()
    {
        //Arrange
        UserLogIn authRequest = new UserLogIn
        {
            Email = Guid.NewGuid().ToString(),
            Password = Guid.NewGuid().ToString(),
            TypeId = Guid.NewGuid()
    
        };
        var resp = new AuthResponse
            { Token = Guid.NewGuid().ToString(), RefreshToken = Guid.NewGuid().ToString(), IsSuccess = true };
       
        _JwtRepositoryMock.Setup(u => u.GetTokenAsync( authRequest,Guid.NewGuid().ToString())).Returns((Task<AuthResponse>)null);
        
    
        var controller = new AccountController(_JwtRepositoryMock.Object,_TutorMeContextMock);
        
        var response=await controller.AuthToken(authRequest);
        
        Assert.IsType<UnauthorizedResult>(response);
        
    
    }
    
    
    
}