using System.Reflection;
using Api.Controllers;
using Api.Data;
using Api.Models;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace IntegrationTests;

public class RequestControllerIntegrationTests
{
    //DTO
    private static Request CreateRequest()
    {
        return new()
        {
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            Id =Guid.NewGuid()
            
        };
    }
    [Fact]
    public void ListsRequestsFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newRequest = CreateRequest();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newRequest);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<IEnumerable<Request>>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new RequestsController(ctx1).GetRequests();
            }
            
            
            var okResult = Assert.IsType<ActionResult<IEnumerable<Request >>>(result.Result);

            var requests = Assert.IsType<List<Request>>(okResult.Value);
            var request = Assert.Single(requests);
            Assert.NotNull(request);
            Assert.Equal(newRequest.RequesterId, request.RequesterId);
            Assert.Equal(newRequest.ReceiverId, request.ReceiverId);
            Assert.Equal("26 April 1999", request.DateCreated);
            Assert.Equal(newRequest.Id, request.Id);
            request.Should().BeEquivalentTo(newRequest,
                //Verifying all the DTO variables matches the expected Request (newRequest)
                options => options.ComparingByMembers<Request>());
    }
    
    [Fact]
    public void GetsRequestFromDatabaseById()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newRequest = CreateRequest();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newRequest);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<Request>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new RequestsController(ctx1).GetRequest(newRequest.Id);
            }
            
  
            var okResult = Assert.IsType<ActionResult<Request >>(result.Result);
            var request = Assert.IsType<Request>(okResult.Value);
            
           
            Assert.NotNull(request);
            Assert.Equal(newRequest.RequesterId, request.RequesterId);
            Assert.Equal(newRequest.ReceiverId, request.ReceiverId);
            Assert.Equal("26 April 1999", request.DateCreated);
            Assert.Equal(newRequest.Id, request.Id);
            request.Should().BeEquivalentTo(newRequest,
                //Verifying all the DTO variables matches the expected Request (newRequest)
                options => options.ComparingByMembers<Request>());
    }
        
    [Fact]
    public void GetTutorRequestsFromDatabaseByTutorId()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        var newRequest1 = CreateRequest();
        var newRequest2 = CreateRequest();
        var newRequest3 = CreateRequest();
        
        var requesterId1=Guid.NewGuid().ToString();
        var receiverId1 = Guid.NewGuid().ToString();
       
            newRequest1.ReceiverId = receiverId1;
            newRequest1.RequesterId = requesterId1;
            newRequest1.DateCreated = "26 April 2022";
                            
    
        var receiverId2 = Guid.NewGuid().ToString();
        var requesterId2=Guid.NewGuid().ToString();
        
            newRequest2.ReceiverId = receiverId2;
            newRequest2.RequesterId = requesterId2;
            newRequest3.DateCreated = "27 April 2022";
            
       
            newRequest3.ReceiverId  = receiverId1;
            newRequest3.RequesterId = receiverId2;
            newRequest3.DateCreated = "28 April 2022";
        
            
          
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newRequest1);
            ctx.Add(newRequest2);
            ctx.Add(newRequest3);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<Request>> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestsController(ctx1).GetTutorRequests(newRequest1.ReceiverId);
        }

        var actionResult = Assert.IsType<ActionResult<Request>>(result.Result);
        var okResult1= Assert.IsType<OkObjectResult>(actionResult.Result);
        var requests = Assert.IsType<List<Request>>(okResult1.Value);
      
        Assert.NotNull(requests);
        Assert.Equal(2,requests.Count);
        
        Assert.Equal(newRequest1.RequesterId, requests[0].RequesterId);
        Assert.Equal(newRequest1.ReceiverId, requests[0].ReceiverId);
        Assert.Equal("26 April 2022", requests[0].DateCreated);
        
        Assert.Equal(newRequest3.RequesterId, requests[1].RequesterId);
        Assert.Equal(newRequest3.ReceiverId, requests[1].ReceiverId);
        Assert.Equal("28 April 2022", requests[1].DateCreated);
        
    }
    
      [Fact]
    public void GetTuteeRequestsFromDatabaseByTuteeId()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        var newRequest1 = CreateRequest();
        var newRequest2 = CreateRequest();
        var newRequest3 = CreateRequest();
        
        var requesterId1=Guid.NewGuid().ToString();
        var receiverId1 = Guid.NewGuid().ToString();
       
            newRequest1.ReceiverId = receiverId1;
            newRequest1.RequesterId = requesterId1;
            newRequest1.DateCreated = "26 April 2022";
                            
    
        var receiverId2 = Guid.NewGuid().ToString();
        var requesterId2=Guid.NewGuid().ToString();
        
            newRequest2.ReceiverId = receiverId2;
            newRequest2.RequesterId = requesterId2;
            newRequest3.DateCreated = "27 April 2022";
            
       
            newRequest3.ReceiverId  = receiverId1;
            newRequest3.RequesterId = receiverId2;
            newRequest3.DateCreated = "28 April 2022";
        
            
          
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newRequest1);
            ctx.Add(newRequest2);
            ctx.Add(newRequest3);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<Request>> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestsController(ctx1).GetTuteeRequests(newRequest1.RequesterId);
        }

        var actionResult = Assert.IsType<ActionResult<Request>>(result.Result);
        var okResult1= Assert.IsType<OkObjectResult>(actionResult.Result);
        var requests = Assert.IsType<List<Request>>(okResult1.Value);
      
        Assert.NotNull(requests);
        Assert.Single(requests);
        
        Assert.Equal(newRequest1.RequesterId, requests[0].RequesterId);
        Assert.Equal(newRequest1.ReceiverId, requests[0].ReceiverId);
        Assert.Equal("26 April 2022", requests[0].DateCreated);
        
    }


    [Fact]
    public void ModifiesRequestFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newRequest = CreateRequest();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newRequest);
            ctx.SaveChangesAsync();
        }

        //Modify the Requests DateCreated
        newRequest.DateCreated = "27 April 1999";
        
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestsController(ctx1).PutRequest(newRequest.Id,newRequest);
        }

        // result should be of type NoContentResult
        Assert.IsType<NoContentResult>(result.Result);
        
        //Now checking if the Date was actually Modified on the database 
        Task<ActionResult<Request>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new RequestsController(ctx1).GetRequest(newRequest.Id);
        }

        var okResult = Assert.IsType<ActionResult<Request >>(resultCheck.Result);
        var request = Assert.IsType<Request>(okResult.Value);
           
        Assert.NotNull(request);
        Assert.Equal(newRequest.RequesterId, request.RequesterId);
        Assert.Equal(newRequest.ReceiverId, request.ReceiverId);
        Assert.Equal("27 April 1999", request.DateCreated);
        Assert.Equal(newRequest.Id, request.Id);
        request.Should().BeEquivalentTo(newRequest,
            //Verifying all the DTO variables matches the expected Request (newRequest)
            options => options.ComparingByMembers<Request>());
    }
    
    [Fact]
    public void AddsRequestToDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newRequest = CreateRequest();

        Task<ActionResult<Request>> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestsController(ctx1).PostRequest(newRequest);
        }

        Assert.IsType<ActionResult<Request >>(result.Result);
        
        //Now checking if the Request was actually added to the database 
        Task<ActionResult<Request>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new RequestsController(ctx1).GetRequest(newRequest.Id);
        }

        var okResult = Assert.IsType<ActionResult<Request >>(resultCheck.Result);
        var request = Assert.IsType<Request>(okResult.Value);
           
        Assert.NotNull(request);
        Assert.Equal(newRequest.RequesterId, request.RequesterId);
        Assert.Equal(newRequest.ReceiverId, request.ReceiverId);
        Assert.Equal("26 April 1999", request.DateCreated);
        Assert.Equal(newRequest.Id, request.Id);
        request.Should().BeEquivalentTo(newRequest,
            //Verifying all the DTO variables matches the expected Request (newRequest)
            options => options.ComparingByMembers<Request>());
    }
    
    [Fact]
    public void DeletesRequestOnDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newRequest = CreateRequest();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newRequest);
            ctx.SaveChangesAsync();
        }
        

        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestsController(ctx1).DeleteRequest(newRequest.Id);
        }

        Assert.IsType< NoContentResult>(result.Result);
        
        //Now checking if the Request was actually deleted to the database 
        Task<ActionResult<Request>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new RequestsController(ctx1).GetRequest(newRequest.Id);
        }

        var notFoundResult = Assert.IsType<ActionResult<Request >>(resultCheck.Result);
        var request = Assert.IsType<NotFoundResult>(notFoundResult.Result);
        Assert.NotNull(request);
        Assert.Equal(404, request.StatusCode);
        
    }

    }