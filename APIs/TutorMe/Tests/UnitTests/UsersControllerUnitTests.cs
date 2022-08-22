using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using TutorMe.Controllers;
using TutorMe.Data;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class UsersControllerUnitTests
{
    private readonly Mock<IUserService> _userRepositoryMock;
    private static Mock<IMapper> _mapper;

    public UsersControllerUnitTests()
    {
        _userRepositoryMock = new Mock<IUserService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllUsers_ListOfUsers_ReturnsListOfUsers()
    {
    
        //arrange
        List<User> users = new List<User>
        {
            new User
            {
                UserId =new Guid(),
                FirstName ="Thabo",
                LastName ="Maduna",
                DateOfBirth ="02/04/2000",
                Status = true,
                Gender ="M",
                Email ="thaboMaduna527@gmail.com",
                Password ="24681012",
                UserTypeId =new Guid(),
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =new Guid(),
                FirstName ="Simphiwe",
                LastName ="Ndlovu",
                DateOfBirth ="02/04/1999",
                Status = true,
                Gender ="M",
                Email ="simphiwendlovu527@gmail.com",
                Password ="12345678",
                UserTypeId =new Guid(),
                InstitutionId =new Guid(),
                Location ="1166 Burnett St, Hatfield, Pretoria, 0028",
                Bio = "Naruto Fan",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =new Guid(),
                FirstName ="Kuda",
                LastName ="Chivunga",
                DateOfBirth ="28/03/2000",
                Status = true,
                Gender ="F",
                Email ="kudaChivunga527@gmail.com",
                Password ="147258369",
                UserTypeId =new Guid(),
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            }
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
    
      
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutor);
            ctx.SaveChangesAsync();
        }
    
        //Modify the tutors Bio
        newTutor.Bio = "Naruto fan";
        var id = new Guid();
        var unExsistingTutor = CreateTutor();
        unExsistingTutor.Id = id;
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TutorsController(ctx1).UpdateTutor(unExsistingTutor.Id,unExsistingTutor);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);

        _userRepositoryMock.Setup(u => u.GetAllUsers()).Returns(users);

        var controller = new UsersController(_userRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllUsers();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<User>>(actual);
        Assert.Equal(3, (actual as List<User>).Count);

    }
    
    [Fact]
    public async  Task GetUserById_UserId_ReturnsUserOfId()
    {
        //arrange
        var user = new User
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
        };
        
        _userRepositoryMock.Setup(u => u.GetUserById(user.UserId)).Returns(user);
        
        var controller = new UsersController(_userRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetUserById(user.UserId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<User>(actual);
    }
    
    [Fact]
    public async  Task AddUser_User_ReturnsUser()
    {
        //arrange
        var user = new User
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
        };
        _userRepositoryMock.Setup(u => u. RegisterUser(It.IsAny<User>())).Returns(user.UserId);
        
        var controller = new UsersController(_userRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.RegisterUser(user);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }
    
    [Fact]
    public async Task UpdateUser_User_ReturnsUser()
    {
        //arrange
        var user = new User
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
        };

        _userRepositoryMock.Setup(u => u.UpdateUser(It.IsAny<User>())).Returns(user);

        var controller = new UsersController(_userRepositoryMock.Object,_mapper.Object);

        //act
        var result =  controller.UpdateUser(user.UserId,user);

        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<User>(actual);
    }

}