using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using NuGet.ContentModel;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Models;
using TutorMe.Services;


namespace Tests.UnitTests;

public class ConnectionServicesUnitTests
{
    private readonly Mock<TutorMeContext> _ConnectionRepositoryMock;
   

    public ConnectionServicesUnitTests()
    {
        _ConnectionRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllConnections_ReturnsListOfConnections()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var Connection = new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
           
        };
        
        var Connection2 = new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
           
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Connection);
            ctx.Add(Connection2);
            ctx.SaveChanges();
        }

        IEnumerable<Connection> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ConnectionServices(ctx1).GetAllConnections();
            //ToDo: Must change all getALL FUNCTIONS to return a list of objects
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Connection>>(result); 
        Assert.Equal(2, okResult.Count());
        var Connections = Assert.IsType<List<Connection>>(okResult);
        Assert.Equal(Connection.ConnectionId, Connections[0].ConnectionId);
        Assert.Equal(Connection2.ConnectionId, Connections[1].ConnectionId);
       
    }
    
    [Fact]
    public void GetAllConnections_Returns_Empty_ListOfConnections()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<Connection> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ConnectionServices(ctx1).GetAllConnections();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Connection>>(result); 
        Assert.Empty(okResult);

    }
    
        
    [Fact]
    public async  Task GetConnectionById_ConnectionId_ReturnsConnection()
    {
        //arrange
        var Connection = new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
           
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Connection);
            ctx.SaveChanges();
        }

        Connection result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ConnectionServices(ctx1).GetConnectionById(Connection.ConnectionId);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Connection>(result);
        Assert.Equal(Connection.ConnectionId, result.ConnectionId);
        Assert.Equal(Connection.ConnectionId, result.ConnectionId);
        
    }
    
    [Fact]
    public async  Task GetConnectionById_ConnectionId_Returns_Connection_not_found()
    {
        //arrange
        var Connection = new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
           
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        Connection result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new ConnectionServices(ctx1).GetConnectionById(Connection.ConnectionId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("Connection not found", e.Message);
        }
      
        
        
       
    }
//Test GetConnectionsByUserId - returns list of connections
    // [Fact]
    // public async Task GetConnectionsByUserId_UserId_ReturnsListOfConnections()
    // {
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //
    //     var Connection = new Connection
    //     {
    //         ConnectionId = Guid.NewGuid(),
    //         TutorId = Guid.NewGuid(),
    //         TuteeId = Guid.NewGuid(),
    //         ModuleId = Guid.NewGuid(),
    //        
    //     };
    //     
    //     var Connection2 = new Connection
    //     {
    //         ConnectionId = Guid.NewGuid(),
    //         TutorId = Guid.NewGuid(),
    //         TuteeId = Guid.NewGuid(),
    //         ModuleId = Guid.NewGuid(),
    //        
    //     };
    //     
    //     var Connection3 = new Connection
    //     {
    //         ConnectionId = Guid.NewGuid(),
    //         TutorId = Guid.NewGuid(),
    //         TuteeId = Guid.NewGuid(),
    //         ModuleId = Guid.NewGuid(),
    //        
    //     };
    //     
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         ctx.Add(Connection);
    //         ctx.Add(Connection2);
    //         ctx.Add(Connection3);
    //         ctx.SaveChanges();
    //     }
    //
    //     IEnumerable<Connection> result;
    //     using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //     {
    //         result =new ConnectionServices(ctx1).GetAllConnections();
    //         //ToDo: Must change all getALL FUNCTIONS to return a list of objects
    //     }
    //     
    //     Assert.NotNull(result);
    //     var okResult = Assert.IsType< List<Connection>>(result); 
    //     Assert.Equal(2, okResult.Count());
    //     var Connections = Assert.IsType<List<Connection>>(okResult);
    //     Assert.Equal(Connection.ConnectionId, Connections[0].ConnectionId);
    //     Assert.Equal(Connection2.ConnectionId, Connections[1].ConnectionId);
    //
    // }
    //
    [Fact]
    public async Task DeleteConnectionById_Returns_true()
    {
        //arrange
        var Connection = new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
           
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Connection);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new ConnectionServices(ctx1).deleteConnectionById(Connection.ConnectionId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteConnectionById_Returns_False()
    {
        //arrange
        var Connection = new Connection
        {
            ConnectionId = Guid.NewGuid(),
            TutorId = Guid.NewGuid(),
            TuteeId = Guid.NewGuid(),
            ModuleId = Guid.NewGuid(),
           
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
           //Empty TutorMeContext
        }

        bool result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new ConnectionServices(ctx1).deleteConnectionById(Connection.ConnectionId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("Connection not found", e.Message);
        }
    
    }
  
}