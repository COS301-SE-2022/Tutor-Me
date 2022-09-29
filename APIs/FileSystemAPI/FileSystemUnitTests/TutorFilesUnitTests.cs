using System.Reflection;
using AutoMapper;
using FileSystem.Controllers;
using FileSystem.Data;
using FileSystem.Entities;
using FileSystem.Models;
using FileSystem.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using NuGet.Versioning;
//using TutorMe.Controllers;
//using TutorMe.Data;
//using TutorMe.Models;
//using TutorMe.Services;


namespace Tests.UnitTests;

public class UserFilesControllerUnitTests
{
    private readonly Mock<IUserFilesService> _UserFilesRepositoryMock;
    private readonly FilesContext tutorMeContext;
    private static Mock<IMapper> _mapper;

    public UserFilesControllerUnitTests()
    {
        _UserFilesRepositoryMock = new Mock<IUserFilesService>();
        _mapper = new Mock<IMapper>();
        tutorMeContext = new FilesContext();
    }

    //[Fact]
    //public async Task GetAllUserFiles_ListOfUserFiles_ReturnsListOfUserFiles()
    //{

    //    //arrange
    //    List<UserFiles> UserFiles = new List<UserFiles>
    //    {
    //        new UserFiles
    //        {

    //        UserFilesId = Guid.NewGuid(),
    //        Name ="University Of Pretoria",
    //        Location ="Hatfield"
    //        },
    //        new UserFiles
    //        {
    //            UserFilesId = Guid.NewGuid(),
    //            Name ="University Of Freestate",

    //            Location ="Freestate"
    //        },
    //        new UserFiles
    //        {
    //            UserFilesId = Guid.NewGuid(),
    //            Name ="University Of Johannesburg",

    //            Location ="Johannesburg"
    //        }
    //    };


    //    _UserFilesRepositoryMock.Setup(u => u.GetAllUserFiles()).Returns(UserFiles);

    //    var controller = new UserFilesController(_UserFilesRepositoryMock.Object, _mapper.Object);
    //    var result = controller.GetAllUserFiles();


    //    Assert.NotNull(result);
    //    Assert.IsType<OkObjectResult>(result);

    //    var actual = (result as OkObjectResult).Value;
    //    Assert.IsType<List<UserFiles>>(actual);
    //    Assert.Equal(3, (actual as List<UserFiles>).Count);

    //}

    [Fact]
    public async Task GetUserFilesById_UserFilesId_ReturnsUnauthorized()
    {
        //arrange
        var userFiles = new UserFiles
        {
            Id = Guid.NewGuid(),
            UserImage = Guid.NewGuid().ToByteArray(),
            UserTranscript = Guid.NewGuid().ToByteArray(),
            ImageKey = Guid.NewGuid().ToByteArray(),
            ImageIV = Guid.NewGuid().ToByteArray(),
            TranscriptKey = Guid.NewGuid().ToByteArray(),
            TranscriptIV = Guid.NewGuid().ToByteArray(),
        };


      
        _UserFilesRepositoryMock.Setup(u => u.GetImageByUserId(userFiles.Id)).Returns(Task.FromResult(Guid.NewGuid().ToByteArray()));

        var controller = new UserFilesController(tutorMeContext, _UserFilesRepositoryMock.Object );

        //act
        var result = await controller.GetImageByUserId(userFiles.Id, "madunathabo2@gmail.com", "TutorMe#1", new Guid("98CA5264-1266-4158-82B6-5DE7FDD03599"));

        //Assert.NotNull(result);
        Assert.IsType<UnauthorizedResult>(result);
        var actual = (result as UnauthorizedResult);
        Assert.IsType<UnauthorizedResult>(actual);
    }

    [Fact]
    public async Task AddUserFiles_UserFiles_ReturnsUnauthorized()
    {
        //arrange
        var userAuth = new UserAuth
        {
            Email = "madunathabo2@gmail.com",
            Password = "Tutorme#1",
            TypeId = new Guid("98CA5264-1266-4158-82B6-5DE7FDD03599")
        };
        var UserFiles = new IUserFiles
        {
            Id = Guid.NewGuid(),
            UserImage = Guid.NewGuid().ToByteArray(),
            UserTranscript = Guid.NewGuid().ToByteArray()
        };
        _UserFilesRepositoryMock.Setup(u => u.createUserRecord(It.IsAny<IUserFiles>())).Returns(Guid.NewGuid());

        var controller = new UserFilesController(tutorMeContext, _UserFilesRepositoryMock.Object);

        //act
        var result = controller.createUserRecord(UserFiles, userAuth.Email, userAuth.Password, userAuth.TypeId);

        Assert.NotNull(result);
        Assert.IsType<UnauthorizedResult>(result.Result);

        var actual = (result.Result as UnauthorizedResult);
        Assert.IsType<UnauthorizedResult>(actual);
    }



    [Fact]
    public async Task DeleteUserFilesById_Returns_true()
    {

        //Arrange
        var userAuth = new UserAuth
        {
            Email = "madunathabo2@gmail.com",
            Password = "Tutorme#1",
            TypeId = new Guid("98CA5264-1266-4158-82B6-5DE7FDD03599")
        };
        var UserFiles = new IUserFiles
        {
            Id = Guid.NewGuid(),
            UserImage = Guid.NewGuid().ToByteArray(),
            UserTranscript = Guid.NewGuid().ToByteArray()
        };

        _UserFilesRepositoryMock.Setup(repo => repo.DeleteUserFilesById(It.IsAny<Guid>())).Returns(true);
        var controller = new UserFilesController(_UserFilesRepositoryMock.Object, _mapper.Object);

        //Act
        var result = controller.DeleteUserFiles(expectedTutor.UserFilesId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }

    //[Fact]
    //public async Task DeleteUserFilesById_Returns_False()
    //{

    //    //Arrange
    //    var expectedTutor = new UserFiles
    //    {
    //        Name = "University Of Pretoria",

    //        Location = "Hatfield"
    //    };

    //    _UserFilesRepositoryMock.Setup(repo => repo.deleteUserFilesById(It.IsAny<Guid>())).Returns(false);
    //    var controller = new UserFilesController(_UserFilesRepositoryMock.Object, _mapper.Object);

    //    //Act
    //    var result = controller.DeleteUserFiles(expectedTutor.UserFilesId);
    //    // Assert
    //    Assert.NotNull(result);
    //    Assert.IsType<OkObjectResult>(result);
    //    var actual = (result as OkObjectResult).Value;
    //    Assert.IsType<Boolean>(actual);
    //    Assert.Equal(false, actual);

    //}

}