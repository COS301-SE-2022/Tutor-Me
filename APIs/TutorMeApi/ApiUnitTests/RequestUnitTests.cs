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
    public async Task GetRequestAsync_WithUnExistingRequest_ReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Type>())).ReturnsAsync((Request)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act
        var result = await controller.GetRequest(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetRequestAsync_WithUnExistingDb_ReturnsFound()
    {
        //Arrange
        var expectedRequest = CreateRequest();
       
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedRequest));
        var controller = new RequestsController(repositoryStub.Object);

        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetRequest(yourGuid);

        //Assert 
        result.Value.Should().BeEquivalentTo(expectedRequest,
              //Verifying all the DTO variables matches the expected Request 
              options => options.ComparingByMembers<Request>());

    }
    [Fact]
    public async Task GetRequestAsync_WithAnEmptyDb()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        //Act
        var controller = new RequestsController(repositoryStub.Object);

        var result = await controller.GetRequest(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //  GetRequests
    [Fact]
    public async Task GetRequestsAsync_WithExistingItem_ReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new TutorsController(repositoryStub.Object);


        //Act
        var result = await controller.GetTutors();

        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetRequest Method to return a list of Requests
    [Fact]
    public async Task GetRequestsAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        //Act
        var controller = new RequestsController(repositoryStub.Object);

        var result = await controller.GetRequests();

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
        var result = await controller.GetTutorRequests(receiverId);

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    [Fact]
    public async Task GetRequestByTuteeId_ithAnEmptyDbReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        //Act
        var controller = new RequestsController(repositoryStub.Object);
        var requesterId = Guid.NewGuid().ToString();
        var result = await controller.GetTuteeRequests(requesterId);

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //Test the PutRequest Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task PutRequest_With_differentIds_BadRequestResult()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedRequest = CreateRequest();
        //Act
        var controller = new RequestsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.PutRequest(id, expectedRequest);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public async Task PutRequest_With_same_Id_but_UnExisting_Request_returns_NullReferenceException()//####
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
            await controller.PutRequest(expectedRequest.Id, expectedRequest);
        }
        //Assert   
        catch (Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }
    [Fact]
    public async Task PutRequest_WithUnExistingId_NotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var expectedRequest = CreateRequest();
        //Act
        var controller = new RequestsController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.PutRequest(id, expectedRequest);

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
            result =new RequestsController(ctx1).PutRequest(unExsistingRequest.Id,unExsistingRequest);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }


    [Fact]
    public async Task PostRequest_and_returns_a_type_of_Action_Result_returns_null()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedRequest));
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.PostRequest(expectedRequest);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Request>>(result);
    }
    [Fact]
    public async Task PostRequest_and_returns_a_type_of_Action()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Request)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.PostRequest(expectedRequest);
        Assert.Null(result.Value);
    }
    [Fact]
    public async Task PostRequest_and_returns_ObjectResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);

        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.PostRequest(expectedRequest);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Request>>(result);
        Assert.IsType<ObjectResult>(result.Result);
    }
    [Fact]
    public async Task PostRequest_and_returns_CreatedAtActionResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.Add(expectedRequest)).Returns((Func<EntityEntry<Request>>)null);

        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.PostRequest(expectedRequest);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.Request>>(result);
        Assert.IsType<CreatedAtActionResult>(result.Result);
    }
    [Fact]
    public async Task PostRequest_and_returns_RequestExists_DbUpdateException()
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
           await controller.PostRequest(expectedRequest);
        }
        // Assert
        catch (Exception e)
        {
            Assert.IsType<DbUpdateException>(e);
        }

    }

    [Fact]
    public async Task DeleteRequest_and_returns_a_type_of_NotFoundResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Request)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act
        var result = await controller.DeleteRequest(expectedRequest.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
    // Mock the DeleteRequest method  and return a Value 
    [Fact]
    public async Task DeleteRequest_and_returns_a_type_of_NoContentResult()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedRequest);
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteRequest(expectedRequest.Id);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
    [Fact]
    public async Task DeleteRequest_and_returns_a_type_of_NotFound()
    {

        //Arrange
        var expectedRequest = CreateRequest();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Requests).Returns((DbSet<Request>)null);
        var controller = new RequestsController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteRequest(expectedRequest.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }




}