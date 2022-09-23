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
using TutorMe.Entities;

namespace Tests.UnitTests;

public class RequestServicesUnitTests
{
    private readonly Mock<TutorMeContext> _RequestRepositoryMock;
   

    public RequestServicesUnitTests()
    {
        _RequestRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllRequests_ReturnsListOfRequests()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        var Request2 = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="22/06/2020",
            ModuleId=Guid.NewGuid()
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.Add(Request2);
            ctx.SaveChanges();
        }

        IEnumerable<Request> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).GetAllRequests();
            //ToDo: Must change all getALL FUNCTIONS to return a list of objects
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Request>>(result); 
        Assert.Equal(2, okResult.Count());
        var Requests = Assert.IsType<List<Request>>(okResult);
        Assert.Equal(Request.DateCreated, Requests[0].DateCreated);
        Assert.Equal(Request2.DateCreated, Requests[1].DateCreated);
       
    }
    
    [Fact]
    public void GetAllRequests_Returns_Empty_ListOfRequests()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<Request> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).GetAllRequests();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Request>>(result); 
        Assert.Empty(okResult);
       
        
    }
    
    
    [Fact]
    public async  Task GetRequestById_RequestId_ReturnsRequest()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.SaveChanges();
        }

        Request result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).GetRequestById(Request.RequestId);
        }
        
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Request>(result);
        Assert.Equal(Request.DateCreated, result.DateCreated);
        Assert.Equal(Request.RequestId, result.RequestId);
        
    }
    [Fact]
    public async  Task GetRequestById_RequestId_Returns_Request_not_found()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        Request result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new RequestServices(ctx1).GetRequestById(Request.RequestId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("Request not found", e.Message);
        }
      
        
        
       
    }
//Test AcceptRequestByIdReturnsTrue
    [Fact]
    public async Task AcceptRequestById_RequestId_ReturnsTrue()
    {
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        var Request2 = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="22/06/2020",
            ModuleId=Guid.NewGuid()
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.Add(Request2);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).AcceptRequestById(Request.RequestId);
         
        }
        
        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);

    }
    
    //Test AcceptRequestByIdReturns_not_found
    [Fact]
    public async Task AcceptRequestById_RequestId_ReturnsRequest_not_found()
    {
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        var Request2 = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="22/06/2020",
            ModuleId=Guid.NewGuid()
        };
        
        //Only add Request2 to the context
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
           
            ctx.Add(Request2);
            ctx.SaveChanges();
        }

        bool result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new RequestServices(ctx1).AcceptRequestById(Request.RequestId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("Request not found", e.Message);
        }

    }
    // Test  RejectRequestByIdReturnsTrue
    [Fact]
    public async Task RejectRequestById_RequestId_ReturnsTrue()
    {
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        var Request2 = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="22/06/2020",
            ModuleId=Guid.NewGuid()
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.Add(Request2);
            ctx.SaveChanges();
        }
        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).RejectRequestById(Request.RequestId);
        }
        
        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    }
    
    //Test RejectRequestByIdReturns_not_found
    [Fact]
    public async Task RejectRequestById_RequestId_ReturnsRequest_not_found()
    {
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        var Request2 = new Request
        {
           RequestId  = Request.RequestId,
            TuteeId  = Request.TuteeId,
            TutorId  = Request.TutorId,
            DateCreated ="20/04/2020",
            ModuleId=Request.ModuleId
        };
        
        //Only add Request2 to the context
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
           
            ctx.Add(Request2);
            ctx.SaveChanges();
        }
        bool result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new RequestServices(ctx1).RejectRequestById(Request.RequestId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("Request record not found", e.Message);
        }
    }
    [Fact]
    public async  Task CreateRequest_Request_Returns_RequestId()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
            var Request1 = new IRequest
        {
            RequestId  = Request.RequestId,
            TuteeId  = Request.TuteeId,
            TutorId  = Request.TutorId,
            DateCreated ="20/04/2020",
            ModuleId=Request.ModuleId
        };

        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        Guid result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).createRequest(Request1);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
        Assert.Equal(Request.RequestId, result);
    }
    
    // test CreateRequest_Returns_createRequest()
    [Fact]
    public async  Task CreateRequest_Returns_Type_already_exists()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        var Request1 = new IRequest
        {
            RequestId  = Request.RequestId,
            TuteeId  = Request.TuteeId,
            TutorId  = Request.TutorId,
            DateCreated ="20/04/2020",
            ModuleId=Request.ModuleId
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.SaveChanges();
        }
        Guid result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new RequestServices(ctx1).createRequest(Request1);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("This Request already exists, Please log in", e.Message);
        }

    }
    //Test GetRequestByTutorById_TutorId_ReturnsRequest
    [Fact]
    public async  Task GetRequestByTutorById_TutorId_ReturnsRequest()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.SaveChanges();
        }
        Request result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).GetRequestByTutorById(Request.TutorId);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Request>(result);
        Assert.Equal(Request.DateCreated, result.DateCreated);
        Assert.Equal(Request.RequestId, result.RequestId);
        
    }
    //Test GetRequestByTuteeById_TuteeId_ReturnsRequest
    [Fact]
    public async  Task GetRequestByTuteeById_TuteeId_ReturnsRequest()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.SaveChanges();
        }
        Request result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).GetRequestByTuteeById(Request.TuteeId);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Request>(result);
        Assert.Equal(Request.DateCreated, result.DateCreated);
        Assert.Equal(Request.RequestId, result.RequestId);
        
    }
    
    [Fact]
    public async Task DeleteRequestById_Returns_true()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Request);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestServices(ctx1).deleteRequestById(Request.RequestId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteRequestById_Returns_False()
    {
        //arrange
        var Request = new Request
        {
            RequestId  = Guid.NewGuid(),
            TuteeId  = Guid.NewGuid(),
            TutorId  = Guid.NewGuid(),
            DateCreated ="20/04/2020",
            ModuleId=Guid.NewGuid()
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
                result =new RequestServices(ctx1).deleteRequestById(Request.RequestId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("Request not found", e.Message);
        }
    
    }
  
}
