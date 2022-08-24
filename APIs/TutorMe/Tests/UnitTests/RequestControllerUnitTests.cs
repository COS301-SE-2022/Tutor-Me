using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Moq;
using TutorMe.Controllers;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class RequestControllerUnitTests
{
    private readonly Mock<IRequestService> _RequestRepositoryMock;
    private static Mock<IMapper> _mapper;

    public RequestControllerUnitTests()
    {
        _RequestRepositoryMock = new Mock<IRequestService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllRequests_ListOfRequests_ReturnsListOfRequests()
    {
    
        //arrange
        List<Request> Requests = new List<Request>
        {
            new Request
            {
                RequestId  = Guid.NewGuid(),
                TuteeId  = Guid.NewGuid(),
                TutorId  = Guid.NewGuid(),
                DateCreated ="20/04/2020",
                ModuleId=Guid.NewGuid()
            },
            new Request
            {
                RequestId  = Guid.NewGuid(),
                TuteeId  = Guid.NewGuid(),
                TutorId  = Guid.NewGuid(),
                DateCreated ="20/05/2020",
                ModuleId=Guid.NewGuid()
            },
            new Request
            {
                RequestId  = Guid.NewGuid(),
                TuteeId  = Guid.NewGuid(),
                TutorId  = Guid.NewGuid(),
                DateCreated ="20/06/2020",
                ModuleId=Guid.NewGuid()
            }
        };
        
        
        _RequestRepositoryMock.Setup(u => u.GetAllRequests()).Returns(Requests);

        var controller = new RequestsController(_RequestRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllRequests();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Request>>(actual);
        Assert.Equal(3, (actual as List<Request>).Count);

    }
    [Fact]
    public async  Task GetRequestById_RequestId_ReturnsRequestById()
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
        
        _RequestRepositoryMock.Setup(u => u.GetRequestById(Request.RequestId)).Returns(Request);
        
        var controller = new RequestsController(_RequestRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetRequestById(Request.RequestId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Request>(actual);
    }

    // test for get request by tutor id
    [Fact]
    public async  Task GetRequestByTutorIdReturnsRequest()
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
        
        _RequestRepositoryMock.Setup(u => u.GetRequestByTutorById(Request.TutorId)).Returns(Request);
        
        var controller = new RequestsController(_RequestRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetRequestByTutorById(Request.TutorId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Request>(actual);
    }
    [Fact]
    public async  Task AddRequest_Request_ReturnsRequest()
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
        _RequestRepositoryMock.Setup(u => u. createRequest(It.IsAny<Request>())).Returns(Request.RequestId);
        
        var controller = new RequestsController(_RequestRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.createRequest(Request);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }

       
    [Fact]
    public async Task DeleteRequestById_Returns_True()
    {

        //Arrange
            var expectedTutor =  new Request
            {
                RequestId  = Guid.NewGuid(),
                TuteeId  = Guid.NewGuid(),
                TutorId  = Guid.NewGuid(),
                DateCreated ="20/04/2020",
                ModuleId=Guid.NewGuid()
            };
            
        _RequestRepositoryMock.Setup(repo => repo.deleteRequestById(It.IsAny<Guid>())).Returns(true);
        var controller = new  RequestsController(_RequestRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteRequest(expectedTutor.RequestId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
 
 
    
   
}