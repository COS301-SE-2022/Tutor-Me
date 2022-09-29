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

public class ConnectionsControllerUnitTests
{
    private readonly Mock<IConnectionService> _ConnectionRepositoryMock;
    private static Mock<IMapper> _mapper;

    public ConnectionsControllerUnitTests()
    {
        _ConnectionRepositoryMock = new Mock<IConnectionService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllConnections_ListOfConnections_ReturnsListOfConnections()
    {
    
        //arrange
        List<Connection> Connections = new List<Connection>
        {
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
             
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
              
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
              
            }
        };
        
        
        _ConnectionRepositoryMock.Setup(u => u.GetAllConnections()).Returns(Connections);

        var controller = new ConnectionsController(_ConnectionRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllConnections();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Connection>>(actual);
        Assert.Equal(3, (actual as List<Connection>).Count);

    }
    [Fact]
    public async  Task GetConnectionById_ConnectionId_ReturnsConnectionOfId()
    {
        //arrange
        List<Connection> Connections = new List<Connection>
        {
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
             
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
              
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
              
            }
        };
        
        
        
        _ConnectionRepositoryMock.Setup(u => u.GetConnectionsByUserId(It.IsAny<Guid>())).Returns(Connections);
        
        var controller = new ConnectionsController(_ConnectionRepositoryMock.Object,_mapper.Object);
        
        //act
        Guid id = Guid.NewGuid();
        var result = controller.GetConnectionById(id);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
    
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Connection>>(actual);
    }
    
    [Fact]
    public async  Task GetConnectionById_ConnectionId_ReturnsNotFound()
    {
        //arrange
        List<Connection> Connections = new List<Connection>
        {
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
             
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
              
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
              
            }
        };
        
        
        
        _ConnectionRepositoryMock.Setup(u => u.GetConnectionsByUserId(It.IsAny<Guid>())).Throws(new KeyNotFoundException("No connections found for user"));
        
        var controller = new ConnectionsController(_ConnectionRepositoryMock.Object,_mapper.Object);
        
        //act
        Guid id = Guid.NewGuid();
        try
        {
            controller.GetConnectionById(id);
        }
        catch (Exception e)
        {
            Assert.IsType<KeyNotFoundException>(e);
            Assert.Equal("No connections found for user", e.Message);
        }
        
       
    }


      [Fact]
    public async Task DeleteConnectionById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
          
        };
            
        _ConnectionRepositoryMock.Setup(repo => repo.deleteConnectionById(It.IsAny<Guid>())).Returns(true);
        var controller = new  ConnectionsController(_ConnectionRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteConnection(expectedTutor.ConnectionId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
    [Fact]
    public async Task DeleteConnectionById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
          
        };
            
        _ConnectionRepositoryMock.Setup(repo => repo.deleteConnectionById(It.IsAny<Guid>())).Returns(false);
        var controller = new  ConnectionsController(_ConnectionRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteConnection(expectedTutor.ConnectionId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(false, actual);

    }
  
    
  //Test GetUserConnectionObjectsById 
    [Fact]
    public async Task GetUserConnectionObjectsById_Returns_true()
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


        _ConnectionRepositoryMock.Setup(repo => repo.GetUserConnectionObjectById(It.IsAny<Guid>(),It.IsAny<Guid>())).Returns(users);
        var controller = new  ConnectionsController(_ConnectionRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.GetUserConnectionObjectsById(Guid.NewGuid(),Guid.NewGuid());
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<User>>(actual);
        Assert.Equal(users, actual);

    }
    
    [Fact]
    public async Task GetUserConnectionObjectsById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
          
        };
            
        _ConnectionRepositoryMock.Setup(repo => repo.GetUserConnectionObjectById(It.IsAny<Guid>(),It.IsAny<Guid>())).Throws(new KeyNotFoundException("No connections found for user"));
        var controller = new  ConnectionsController(_ConnectionRepositoryMock.Object,_mapper.Object);

        //Act
        try
        {
            controller.GetUserConnectionObjectsById(Guid.NewGuid(),Guid.NewGuid());
        }
        catch (Exception e)
        {
            Assert.IsType<KeyNotFoundException>(e);
            Assert.Equal("No connections found for user", e.Message);
        }
        
    }
    
    [Fact]
    public async Task GetUserConnectionObjectsById_Returns_User_Type_not_found()
    {

        //Arrange
        var expectedTutor =  new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
          
        };
            
        _ConnectionRepositoryMock.Setup(repo => repo.GetUserConnectionObjectById(It.IsAny<Guid>(),It.IsAny<Guid>())).Throws(new KeyNotFoundException("User Type not found"));
        var controller = new  ConnectionsController(_ConnectionRepositoryMock.Object,_mapper.Object);

        //Act
        try
        {
            controller.GetUserConnectionObjectsById(Guid.NewGuid(),Guid.NewGuid());
        }
        catch (Exception e)
        {
            Assert.IsType<KeyNotFoundException>(e);
            Assert.Equal("User Type not found", e.Message);
        }
        
    }
    
  
  
}