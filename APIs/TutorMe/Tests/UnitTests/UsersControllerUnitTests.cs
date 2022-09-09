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
    [Fact]
    public async Task UpdateUser_WithUnExistingId_NotFound()
    {
        //Arrange
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
        //Act
        var controller = new UsersController(_userRepositoryMock.Object,_mapper.Object);
        var id = Guid.NewGuid();
        var result =controller.UpdateUser(id,user);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }
   // Test for UpdateUser returns Conflict if user is not registered
    [Fact]
    public async Task UpdateUser_With_An_UnExistingTutor_Conflict()
    {
        //Arrange
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
        
        _userRepositoryMock.Setup(u => u.UpdateUser(user)).Throws<Exception>();
        
        //Act
        var controller = new UsersController(_userRepositoryMock.Object,_mapper.Object);
        var result =controller.UpdateUser(user.UserId,user);
    
        //Assert     
        Assert.NotNull(result);
        Assert.IsType<ConflictObjectResult>(result);

    }
    
    //Test get all Tutors returns all the tutors
    [Fact]
    public async Task GetAllTutors_ReturnsAllTutors()
    {
        //arrange
        List<UserType> userTypes = new List<UserType>
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
        
        List<User> users = new List<User>
        {
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Thabo",
                LastName ="Maduna",
                DateOfBirth ="02/04/2000",
                Status = true,
                Gender ="M",
                Email ="thaboMaduna527@gmail.com",
                Password ="24681012",
                UserTypeId =userTypes[0].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Simphiwe",
                LastName ="Ndlovu",
                DateOfBirth ="02/04/1999",
                Status = true,
                Gender ="M",
                Email ="simphiwendlovu527@gmail.com",
                Password ="12345678",
                UserTypeId =userTypes[1].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 Burnett St, Hatfield, Pretoria, 0028",
                Bio = "Naruto Fan",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Kuda",
                LastName ="Chivunga",
                DateOfBirth ="28/03/2000",
                Status = true,
                Gender ="F",
                Email ="kudaChivunga527@gmail.com",
                Password ="147258369",
                UserTypeId =userTypes[2].UserTypeId,
                InstitutionId =Guid.NewGuid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
                
            }
        };
        
        List<User> tutorList = new List<User>();
       for (int i = 0; i < users.Count; i++)
       {
           for(int ii=0;ii<userTypes.Count;ii++)
           {
               if(users[i].UserTypeId.Equals(userTypes[ii].UserTypeId) && userTypes[ii].Type.Equals("Tutor"))
               {
                   tutorList.Add(users[i]);
               }
           }
          
       }
        _userRepositoryMock.Setup(u => u.GetAllTutors()).Returns(tutorList);
        
        var controller = new UsersController(_userRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllTutors();
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<User>>(actual);
        Assert.Equal(2, (actual as List<User>).Count);

    }
       //Test get all Tutors returns all the tutors
    [Fact]
    public async Task GetAllTutors_ReturnsBadRequest()
    {
        //arrange
        List<UserType> userTypes = new List<UserType>
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
        
        List<User> users = new List<User>
        {
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Thabo",
                LastName ="Maduna",
                DateOfBirth ="02/04/2000",
                Status = true,
                Gender ="M",
                Email ="thaboMaduna527@gmail.com",
                Password ="24681012",
                UserTypeId =userTypes[0].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Simphiwe",
                LastName ="Ndlovu",
                DateOfBirth ="02/04/1999",
                Status = true,
                Gender ="M",
                Email ="simphiwendlovu527@gmail.com",
                Password ="12345678",
                UserTypeId =userTypes[1].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 Burnett St, Hatfield, Pretoria, 0028",
                Bio = "Naruto Fan",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Kuda",
                LastName ="Chivunga",
                DateOfBirth ="28/03/2000",
                Status = true,
                Gender ="F",
                Email ="kudaChivunga527@gmail.com",
                Password ="147258369",
                UserTypeId =userTypes[2].UserTypeId,
                InstitutionId =Guid.NewGuid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
                
            }
        };
        
        List<User> tutorList = new List<User>();
       for (int i = 0; i < users.Count; i++)
       {
           for(int ii=0;ii<userTypes.Count;ii++)
           {
               if(users[i].UserTypeId.Equals(userTypes[ii].UserTypeId) && userTypes[ii].Type.Equals("Tutor"))
               {
                   tutorList.Add(users[i]);
               }
           }
          
       }
        _userRepositoryMock.Setup(u => u.GetAllTutors()).Returns(tutorList);
        
        var controller = new UsersController(_userRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllTutors();
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<User>>(actual);
        Assert.Equal(2, (actual as List<User>).Count);

    }
     //Test get all Tutors returns all the tutees
    [Fact]
    public async Task GetAllTutees_ReturnsAllTutees()
    {
        //arrange
        List<UserType> userTypes = new List<UserType>
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
        
        List<User> users = new List<User>
        {
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Thabo",
                LastName ="Maduna",
                DateOfBirth ="02/04/2000",
                Status = true,
                Gender ="M",
                Email ="thaboMaduna527@gmail.com",
                Password ="24681012",
                UserTypeId =userTypes[0].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Simphiwe",
                LastName ="Ndlovu",
                DateOfBirth ="02/04/1999",
                Status = true,
                Gender ="M",
                Email ="simphiwendlovu527@gmail.com",
                Password ="12345678",
                UserTypeId =userTypes[1].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 Burnett St, Hatfield, Pretoria, 0028",
                Bio = "Naruto Fan",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Kuda",
                LastName ="Chivunga",
                DateOfBirth ="28/03/2000",
                Status = true,
                Gender ="F",
                Email ="kudaChivunga527@gmail.com",
                Password ="147258369",
                UserTypeId =userTypes[2].UserTypeId,
                InstitutionId =Guid.NewGuid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
                
            }
        };
        
        List<User> tutorList = new List<User>();
       for (int i = 0; i < users.Count; i++)
       {
           for(int ii=0;ii<userTypes.Count;ii++)
           {
               if(users[i].UserTypeId.Equals(userTypes[ii].UserTypeId) && userTypes[ii].Type.Equals("Tutee"))
               {
                   tutorList.Add(users[i]);
               }
           }
          
       }
        _userRepositoryMock.Setup(u => u.GetAllTutees()).Returns(tutorList);
        
        var controller = new UsersController(_userRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllTutees();
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<User>>(actual);
        Assert.Equal(1, (actual as List<User>).Count);

    }
   //Test get all Tutors returns all the tutees
    [Fact]
    public async Task GetAllAdmins_ReturnsAllAdmins()
    {
        //arrange
        List<UserType> userTypes = new List<UserType>
        {
            new UserType
            {
                UserTypeId = Guid.NewGuid(),
                Type ="Admin"
            },
            new UserType
            {
                UserTypeId =Guid.NewGuid(),
                Type ="Tutee"
            },
            new UserType
            {
                UserTypeId =Guid.NewGuid(),
                Type ="Admin"
            }

        };
        
        List<User> users = new List<User>
        {
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Thabo",
                LastName ="Maduna",
                DateOfBirth ="02/04/2000",
                Status = true,
                Gender ="M",
                Email ="thaboMaduna527@gmail.com",
                Password ="24681012",
                UserTypeId =userTypes[0].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Simphiwe",
                LastName ="Ndlovu",
                DateOfBirth ="02/04/1999",
                Status = true,
                Gender ="M",
                Email ="simphiwendlovu527@gmail.com",
                Password ="12345678",
                UserTypeId =userTypes[1].UserTypeId,
                InstitutionId =new Guid(),
                Location ="1166 Burnett St, Hatfield, Pretoria, 0028",
                Bio = "Naruto Fan",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =Guid.NewGuid(),
                FirstName ="Kuda",
                LastName ="Chivunga",
                DateOfBirth ="28/03/2000",
                Status = true,
                Gender ="F",
                Email ="kudaChivunga527@gmail.com",
                Password ="147258369",
                UserTypeId =userTypes[2].UserTypeId,
                InstitutionId =Guid.NewGuid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
                
            }
        };
        
        List<User> tutorList = new List<User>();
       for (int i = 0; i < users.Count; i++)
       {
           for(int ii=0;ii<userTypes.Count;ii++)
           {
               if(users[i].UserTypeId.Equals(userTypes[ii].UserTypeId) && userTypes[ii].Type.Equals("Admin"))
               {
                   tutorList.Add(users[i]);
               }
           }
          
       }
        _userRepositoryMock.Setup(u => u.GetAllAdmins()).Returns(tutorList);
        
        var controller = new UsersController(_userRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllAdmins();
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<User>>(actual);
        Assert.Equal(2, (actual as List<User>).Count);

    }

    // Test DeleteUserById returns Ok if user is deleted
    [Fact]
    public async Task DeleteUserById_ReturnsOk()
    {
        //Arrange
        var user = new User
        {
            UserId =Guid.NewGuid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =Guid.NewGuid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
        };
        _userRepositoryMock.Setup(u => u.DeleteUserById(user.UserId)).Returns(true);
        var controller = new UsersController(_userRepositoryMock.Object, _mapper.Object);
        var result = controller.DeleteUserById(user.UserId);
        
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
            
    }
    // Test DeleteUserById returns NotFound if user is not deleted
    [Fact]
    public async Task DeleteUserById_ReturnsNotFound()
    {
        //Arrange
        var user = new User
        {
            UserId = Guid.NewGuid(),
            FirstName = "Thabo",
            LastName = "Maduna",
            DateOfBirth = "02/04/2000",
            Status = true,
        };
        
        _userRepositoryMock.Setup(u => u.DeleteUserById(user.UserId)).Throws<Exception>();
        
        //Act
        var controller = new UsersController(_userRepositoryMock.Object,_mapper.Object);
        var result =controller.DeleteUserById(user.UserId);
    
        //Assert
        Assert.NotNull(result);
        Assert.IsType<ConflictObjectResult>(result);
    }

    //Test UpdateUserById returns Ok if user is updated
    [Fact]
    public async Task UpdateUserById_ReturnsOk()
    {
        //Arrange
        var user = new User
        {
            UserId = Guid.NewGuid(),
            FirstName = "Thabo",
            LastName = "Maduna",
            DateOfBirth = "02/04/2000",
            Status = true,
        };
    }

}