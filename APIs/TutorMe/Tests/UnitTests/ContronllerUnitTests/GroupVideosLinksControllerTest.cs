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

public class GroupVideosLinksControllerTest
{
    private readonly Mock<IGroupVideosLinkService> _GroupVideosLinkRepositoryMock;
    private readonly TutorMeContext _TutorMeContextMock;
    private static Mock<IMapper> _mapper;

    public GroupVideosLinksControllerTest()
    {
        // _TutorMeContextMock = new Mock<TutorMeContext>();
        _GroupVideosLinkRepositoryMock = new Mock<IGroupVideosLinkService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllGroupVideosLinks_ListOfGroupVideosLinks_ReturnsListOfGroupVideosLinks()
    {
        
            //arrange
        List<GroupVideosLink> GroupVideosLinks = new List<GroupVideosLink>
        {
            new GroupVideosLink
            { 
                     
                GroupVideoLinkId =Guid.NewGuid(),
                GroupId = Guid.NewGuid(),
                VideoLink="https://www.youtube.com/watch?v=1",
            },
            new GroupVideosLink
            {
                GroupVideoLinkId =Guid.NewGuid(),
                GroupId = Guid.NewGuid(),
                VideoLink="https://www.youtube.com/watch?v=1",

            },
            new GroupVideosLink
            {
                GroupVideoLinkId =Guid.NewGuid(),
                GroupId = Guid.NewGuid(),
                VideoLink="https://www.youtube.com/watch?v=1",

            }
        };
        
        
        _GroupVideosLinkRepositoryMock.Setup(u => u.GetAllGroupVideosLinksByGroupId( (It.IsAny<Guid>()))).Returns(GroupVideosLinks);

        var controller = new GroupVideosLinksController(_TutorMeContextMock,_GroupVideosLinkRepositoryMock.Object);
        Guid id = Guid.NewGuid();
        var result = controller.GetAllGroupVideosLinksByGroupId(id);


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<GroupVideosLink>>(actual);
        Assert.Equal(3, (actual as List<GroupVideosLink>).Count);

    }
    

    [Fact]
    public async  Task AddGroupVideosLink_GroupVideosLink_ReturnsGroupVideosLink()
    {
        //arrange
        var GroupVideosLink = new IGroupVideosLink
        {
            GroupVideoLinkId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            VideoLink="https://www.youtube.com/watch?v=1",

        };
        _GroupVideosLinkRepositoryMock.Setup(u => u. CreateGroupVideosLink(It.IsAny<IGroupVideosLink>())).Returns(GroupVideosLink.GroupId);
        
        var controller = new GroupVideosLinksController(_TutorMeContextMock,_GroupVideosLinkRepositoryMock.Object);
        
        //act
        var result =  controller.CreateGroupVideosLink(GroupVideosLink);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Guid>(actual);
    }
    
 
    
    [Fact]
    public async Task DeleteGroupVideosLinkById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new GroupVideosLink
        {
            GroupVideoLinkId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            VideoLink="https://www.youtube.com/watch?v=1",

        };
            
        _GroupVideosLinkRepositoryMock.Setup(repo => repo.DeleteGroupVideosLinkById(It.IsAny<Guid>())).Returns(true);
        var controller = new  GroupVideosLinksController(_TutorMeContextMock,_GroupVideosLinkRepositoryMock.Object);
    
        //Act
        var result = controller.DeleteGroupVideosLinkById(expectedTutor.GroupVideoLinkId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkResult>(result);
        var actual = (result as OkResult);
        Assert.Equal(200, actual.StatusCode);
      
    

    }
    
    [Fact]
    public async Task DeleteGroupVideosLinkById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new GroupVideosLink
        {
            GroupVideoLinkId =Guid.NewGuid(),
            GroupId = Guid.NewGuid(),
            VideoLink="https://www.youtube.com/watch?v=1",

        };
            
        _GroupVideosLinkRepositoryMock.Setup(repo => repo.DeleteGroupVideosLinkById(It.IsAny<Guid>())).Throws(new KeyNotFoundException("GroupVideosLink not found"));
        var controller = new  GroupVideosLinksController(_TutorMeContextMock,_GroupVideosLinkRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.DeleteGroupVideosLinkById(expectedTutor.GroupVideoLinkId);
        }
        catch (Exception e)
        {
            Assert.Equal("GroupVideosLink not found", e.Message);
        }
        

    }
   
}