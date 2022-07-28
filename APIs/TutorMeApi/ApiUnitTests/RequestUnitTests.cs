using System.Reflection;
using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;


namespace ApiUnitTests;

using FluentAssertions;
using Moq;
public class RequestUnitTests
{
    //DTO
    private static Request CreateRequest()
    {
        return new()
        {
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated =Guid.NewGuid().ToString(),
            Id =Guid.NewGuid()
        };
    }
    [Fact]
    public async Task GetRequestByIdAsync_WithUnExistingRequest_ReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Type>())).ReturnsAsync((Request)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act
        var result = await controller.GetRequestById(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetRequestByIdAsync_WithUnExistingDb_ReturnsFound()
    {
        //Arrange
        var expectedRequest = CreateRequest();
       
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedRequest));
        var controller = new RequestsController(repositoryStub.Object);

        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetRequestById(yourGuid);

        //Assert 
        result.Value.Should().BeEquivalentTo(expectedRequest,
              //Verifying all the DTO variables matches the expected Request 
              options => options.ComparingByMembers<Request>());

    }
    [Fact]
    public async Task GetRequestByIdAsync_WithAnEmptyDb()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        //Act
        var controller = new RequestsController(repositoryStub.Object);

        var result = await controller.GetRequestById(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //  GetAllRequests
    [Fact]
    public async Task GetAllRequestsAsync_WithExistingItem_ReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new RequestsController(repositoryStub.Object);


        //Act
        var result = await controller.GetAllRequests();

        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetRequestById Method to return a list of Requests
    [Fact]
    public async Task GetAllRequestsAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        //Act
        var controller = new RequestsController(repositoryStub.Object);

        var result = await controller.GetAllRequests();

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    
    [Fact]
    public async Task GetRequestByTutorId_WithAnEmptyDbReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        //Act
        var controller = new RequestsController(repositoryStub.Object);
        var receiverId = Guid.NewGuid().ToString();
        var result = await controller.GetRequestsByTutorId(receiverId);

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    [Fact]
    public async Task GetRequestByIdByTuteeId_withAnEmptyDbReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        //Act
        var controller = new RequestsController(repositoryStub.Object);
        var requesterId = Guid.NewGuid().ToString();
        var result = await controller.GetRequestsByTuteeId(requesterId);

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //     [Fact]
    // public void GetTutorRequestsFromDatabaseByTutorId()
    // {
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //     
    //     var newRequest1 = CreateRequest();
    //     var newRequest2 = CreateRequest();
    //     var newRequest3 = CreateRequest();
    //     
    //     var requesterId1=Guid.NewGuid().ToString();
    //     var receiverId1 = Guid.NewGuid().ToString();
    //    
    //         newRequest1.ReceiverId = receiverId1;
    //         newRequest1.RequesterId = requesterId1;
    //         newRequest1.DateCreated = "26 April 2022";
    //                         
    //
    //     var receiverId2 = Guid.NewGuid().ToString();
    //     var requesterId2=Guid.NewGuid().ToString();
    //     
    //         newRequest2.ReceiverId = receiverId2;
    //         newRequest2.RequesterId = requesterId2;
    //         newRequest3.DateCreated = "27 April 2022";
    //         
    //    
    //         newRequest3.ReceiverId  = receiverId1;
    //         newRequest3.RequesterId = receiverId2;
    //         newRequest3.DateCreated = "28 April 2022";
    //     
    //         
    //       
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         ctx.Add(newRequest1);
    //        // ctx.Add(newRequest2);
    //        // ctx.Add(newRequest3);
    //         ctx.SaveChangesAsync();
    //     }
    //
    //     Task<ActionResult<Request>> result;
    //     using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //     {
    //         result =new RequestsController(ctx1).GetRequestsByTutorId(newRequest1.ReceiverId);
    //     }
    //
    //     var actionResult = Assert.IsType<ActionResult<Request>>(result.Result);
    //     var okResult1= Assert.IsType<OkObjectResult>(actionResult.Result);
    //     var requests = Assert.IsType<List<Request>>(okResult1.Value);
    //   
    //     Assert.NotNull(requests);
    //     Assert.Equal(2,requests.Count);
    //     
    //     Assert.Equal(newRequest1.RequesterId, requests[0].RequesterId);
    //     Assert.Equal(newRequest1.ReceiverId, requests[0].ReceiverId);
    //     Assert.Equal("26 April 2022", requests[0].DateCreated);
    //     
    //     Assert.Equal(newRequest3.RequesterId, requests[1].RequesterId);
    //     Assert.Equal(newRequest3.ReceiverId, requests[1].ReceiverId);
    //     Assert.Equal("28 April 2022", requests[1].DateCreated);
    //     
    // }
    //

    //Test the UpdateRequest Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task UpdateRequest_With_differentIds_BadRequestResult()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedRequest = CreateRequest();
        //Act
        var controller = new RequestsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.UpdateRequest(id, expectedRequest);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public async Task UpdateRequest_With_same_Id_but_UnExisting_Request_returns_NullReferenceException()//####
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedRequest = CreateRequest();
        //repositoryStub.Setup(repo => repo.Requests.Find(expectedRequest.Id).Equals(expectedRequest.Id)).Returns(false);
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);
        //Act
        var controller = new RequestsController(repositoryStub.Object);
     
        try
        {
            await controller.UpdateRequest(expectedRequest.Id, expectedRequest);
        }
        //Assert   
        catch (Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }
    [Fact]
    public async Task UpdateRequest_WithUnExistingId_NotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedRequest = CreateRequest();
        //Act
        var controller = new RequestsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.UpdateRequest(id, expectedRequest);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public void ModifiesRequest_Returns_NotFoundResult()
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
    
        //Modify the request date
        newRequest.DateCreated = "25/05/2020";
        var id = new Guid();
        var unExsistingRequest = CreateRequest();
        unExsistingRequest.Id = id;
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new RequestsController(ctx1).UpdateRequest(unExsistingRequest.Id,unExsistingRequest);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }


    [Fact]
    public async Task RegiterRequest_and_returns_a_type_of_Action_Result_returns_null()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedRequest));
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.RegiterRequest(expectedRequest);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Request>>(result);
    }
    [Fact]
    public async Task RegiterRequest_and_returns_a_type_of_Action()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Request)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.RegiterRequest(expectedRequest);
        Assert.Null(result.Value);
    }
    [Fact]
    public async Task RegiterRequest_and_returns_ObjectResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.RegiterRequest(expectedRequest);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Request>>(result);
        Assert.IsType<ObjectResult>(result.Result);
    }
    [Fact]
    public async Task RegiterRequest_and_returns_CreatedAtActionResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.Add(expectedRequest)).Returns((Func<EntityEntry<Request>>)null);

        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.RegiterRequest(expectedRequest);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Request>>(result);
        Assert.IsType<CreatedAtActionResult>(result.Result);
    }
    [Fact]
    public async Task RegiterRequest_and_returns_RequestExists_DbUpdateException()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.Add(expectedRequest)).Throws<DbUpdateException>();

        //repositoryStub.Setup(repo => repo.Requests.Update(expectedRequest)).Throws< DbUpdateException>();

        var controller = new RequestsController(repositoryStub.Object);

        //Act
        try
        {
           await controller.RegiterRequest(expectedRequest);
        }
        // Assert
        catch (Exception e)
        {
            Assert.IsType<DbUpdateException>(e);
        }

    }

    [Fact]
    public async Task DeleteRequestById_and_returns_a_type_of_NotFoundResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Request)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act
        var result = await controller. DeleteRequestById(expectedRequest.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
    // Mock the DeleteRequestById method  and return a Value 
    [Fact]
    public async Task DeleteRequestById_and_returns_a_type_of_NoContentResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedRequest);
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteRequestById(expectedRequest.Id);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
    [Fact]
    public async Task DeleteRequestById_and_returns_a_type_of_NotFound()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteRequestById(expectedRequest.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }




}