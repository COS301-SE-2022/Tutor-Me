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
    
   
}