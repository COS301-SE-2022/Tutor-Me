using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Moq;
using TutorMe.Controllers;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class AuthenticationControllerUnitTests
{
    private readonly Mock<IUserTypeService> _UserTypeRepositoryMock;
    private static Mock<IMapper> _mapper;

    public AuthenticationControllerUnitTests()
    {
        _UserTypeRepositoryMock = new Mock<IUserTypeService>();
        _mapper = new Mock<IMapper>();
    }
    
    
}