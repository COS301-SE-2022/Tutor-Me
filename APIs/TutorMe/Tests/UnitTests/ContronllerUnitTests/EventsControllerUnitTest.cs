using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using NuGet.Versioning;
using TutorMe.Controllers;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class EventsControllerUnitTest
{
    private readonly Mock<IEventService> _EventRepositoryMock;
    private readonly TutorMeContext _TutorMeContextMock;
    private static Mock<IMapper> _mapper;

    public EventsControllerUnitTest()
    {
        // _TutorMeContextMock = new Mock<TutorMeContext>();
        _EventRepositoryMock = new Mock<IEventService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllEvents_ListOfEvents_ReturnsListOfEvents()
    {
       

            //arrange
        List<Event> Events = new List<Event>
        {
            new Event
            { 
                     
                EventId =Guid.NewGuid(),
                GroupId = Guid.NewGuid(),
                OwnerId = Guid.NewGuid(),
                UserId = Guid.NewGuid(),
                DateOfEvent = Guid.NewGuid().ToString(),
                VideoLink = Guid.NewGuid().ToString(),
                TimeOfEvent = Guid.NewGuid().ToString(),
                Title = "Test",
                Description = "Test",

            },
            new Event
            {
                EventId =Guid.NewGuid(),
                GroupId = Guid.NewGuid(),
                OwnerId = Guid.NewGuid(),
                UserId = Guid.NewGuid(),
                DateOfEvent = Guid.NewGuid().ToString(),
                VideoLink = Guid.NewGuid().ToString(),
                TimeOfEvent = Guid.NewGuid().ToString(),
                Title = "Test",
                Description = "Test",

            },
            new Event
            {
                EventId =Guid.NewGuid(),
                GroupId = Guid.NewGuid(),
                OwnerId = Guid.NewGuid(),
                UserId = Guid.NewGuid(),
                DateOfEvent = Guid.NewGuid().ToString(),
                VideoLink = Guid.NewGuid().ToString(),
                TimeOfEvent = Guid.NewGuid().ToString(),
                Title = "Test",
                Description = "Test",

            }
        };
        
        
        _EventRepositoryMock.Setup(u => u.GetUserEvents( (It.IsAny<Guid>()))).Returns(Events);

        var controller = new EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
        Guid id = Guid.NewGuid();
        var result = controller.GetAllUserEvent(id);


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Event>>(actual);
        Assert.Equal(3, (actual as List<Event>).Count);

    }
    
   
    

    [Fact]
    public async  Task AddEvent_Event_ReturnsEvent()
    {
        //arrange
        var Event = new IEvent
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
        _EventRepositoryMock.Setup(u => u. CreateUserEvent(It.IsAny<IEvent>())).Returns(true);
        
        var controller = new EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
        
        //act
        var result =  controller.CreateUserEvent(Event);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
    }
    
 
    
    [Fact]
    public async Task DeleteEventById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.DeleteUserEvent(It.IsAny<Guid>())).Returns(true);
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
    
        //Act
        var result = controller.DeleteEventById(expectedTutor.EventId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
        var actual = (result as OkResult);
        Assert.Equal(200, actual.StatusCode);
      
    

    }
    
    [Fact]
    public async Task DeleteEventById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.DeleteUserEvent(It.IsAny<Guid>())).Throws(new KeyNotFoundException("Event not found"));
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.DeleteEventById(expectedTutor.EventId);
        }
        catch (Exception e)
        {
            Assert.Equal("Event not found", e.Message);
        }
        

    }
    // Test UpdateEventDate returns true
    [Fact]
    public async Task UpdateEventDate_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.UpdateEventDate(It.IsAny<Guid>(), It.IsAny<string>())).Returns(true);
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
    
        //Act
        var result = controller.UpdateEventDate(expectedTutor.EventId, expectedTutor.DateOfEvent);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
        var actual = (result as OkResult);
        Assert.Equal(200, actual.StatusCode);

    }
    // Test UpdateEventDate returns false
    [Fact]
    public async Task UpdateEventDate_Returns_False()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.UpdateEventDate(It.IsAny<Guid>(), It.IsAny<string>())).Returns(false);
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);

        //Act
        var result = controller.UpdateEventDate(expectedTutor.EventId, expectedTutor.DateOfEvent);
       
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);


    }
  
    // UpdateEventTime returns false
    [Fact]
    public async Task UpdateEventTime_Returns_False()
    {

        //Arrange
        var expectedTutor = new Event
        {
            EventId = Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",
        };

        _EventRepositoryMock.Setup(repo => repo.UpdateEventTime(It.IsAny<Guid>(), It.IsAny<string>())).Returns(false);
        var controller = new EventsController(_TutorMeContextMock, _EventRepositoryMock.Object);

        //Act
        var result = controller.UpdateEventTime(expectedTutor.EventId, expectedTutor.TimeOfEvent);

        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
    }
    // UpdateEventTime returns true
    [Fact]
    public async Task UpdateEventVideoLink_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.UpdateEventVideoLink(It.IsAny<Guid>(), It.IsAny<string>())).Returns(true);
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
    
        //Act
        var result = controller.UpdateEventVideoLink(expectedTutor.EventId, expectedTutor.VideoLink);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
        var actual = (result as OkResult);
        Assert.Equal(200, actual.StatusCode);

    }
    
    // UpdateEventVideoLink returns false
    [Fact]
public async Task UpdateEventVideoLink_Returns_False()
    {

        //Arrange
        var expectedTutor = new Event
        {
            EventId = Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",
        };

        _EventRepositoryMock.Setup(repo => repo.UpdateEventVideoLink(It.IsAny<Guid>(), It.IsAny<string>())).Returns(false);
        var controller = new EventsController(_TutorMeContextMock, _EventRepositoryMock.Object);

        //Act
        var result = controller.UpdateEventVideoLink(expectedTutor.EventId, expectedTutor.VideoLink);

        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
    }

    // UpdateEventTitle returns true
    [Fact]
    public async Task UpdateEventTitle_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.UpdateEventTitle(It.IsAny<Guid>(), It.IsAny<string>())).Returns(true);
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
    
        //Act
        var result = controller.UpdateEventTitle(expectedTutor.EventId, expectedTutor.Title);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
        var actual = (result as OkResult);
        Assert.Equal(200, actual.StatusCode);

    }
    // UpdateEventTitle returns false
    [Fact]
    public async Task UpdateEventTitle_Returns_False()
    {

        //Arrange
        var expectedTutor = new Event
        {
            EventId = Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",
        };

        _EventRepositoryMock.Setup(repo => repo.UpdateEventTitle(It.IsAny<Guid>(), It.IsAny<string>())).Returns(false);
        var controller = new EventsController(_TutorMeContextMock, _EventRepositoryMock.Object);

        //Act
        var result = controller.UpdateEventTitle(expectedTutor.EventId, expectedTutor.Title);

        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
    }
    // UpdateEventDescription returns true
    [Fact]
    public async Task UpdateEventDescription_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.UpdateEventDescription(It.IsAny<Guid>(), It.IsAny<string>())).Returns(true);
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
    
        //Act
        var result = controller.UpdateEventDescription(expectedTutor.EventId, expectedTutor.Description);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
        var actual = (result as OkResult);
        Assert.Equal(200, actual.StatusCode);

    }
    // UpdateEventDescription returns false
    [Fact]
    public async Task UpdateEventDescription_Returns_False()
    {

        //Arrange
        var expectedTutor = new Event
        {
            EventId = Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",
        };

        _EventRepositoryMock.Setup(repo => repo.UpdateEventDescription(It.IsAny<Guid>(), It.IsAny<string>())).Returns(false);
        var controller = new EventsController(_TutorMeContextMock, _EventRepositoryMock.Object);

        //Act
        var result = controller.UpdateEventDescription(expectedTutor.EventId, expectedTutor.Description);

        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
    }
    // UpdateEventTime returns true
    [Fact]
    public async Task UpdateEventTime_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Event
        {
            EventId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            OwnerId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            DateOfEvent = Guid.NewGuid().ToString(),
            VideoLink = Guid.NewGuid().ToString(),
            TimeOfEvent = Guid.NewGuid().ToString(),
            Title = "Test",
            Description = "Test",

        };
            
        _EventRepositoryMock.Setup(repo => repo.UpdateEventTime(It.IsAny<Guid>(), It.IsAny<string>())).Returns(true);
        var controller = new  EventsController(_TutorMeContextMock,_EventRepositoryMock.Object);
    
        //Act
        var result = controller.UpdateEventTime(expectedTutor.EventId, expectedTutor.TimeOfEvent);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
        var actual = (result as OkResult);
        Assert.Equal(200, actual.StatusCode);

    }
}