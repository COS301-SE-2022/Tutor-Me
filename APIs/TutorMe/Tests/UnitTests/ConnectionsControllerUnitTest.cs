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
                TuteeUserId = Guid.NewGuid(),
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
                TuteeUserId = Guid.NewGuid(),
            },
            new Connection
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),
                TuteeUserId = Guid.NewGuid(),
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
    
  
  
}