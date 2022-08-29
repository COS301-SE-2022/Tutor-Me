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

public class GroupControllerUnitTests
{
    private readonly Mock<IGroupService> _GroupRepositoryMock;
    private static Mock<IMapper> _mapper;

    public GroupControllerUnitTests()
    {
        _GroupRepositoryMock = new Mock<IGroupService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllGroups_ListOfGroups_ReturnsListOfGroups()
    {
    
        //arrange
        List<Group> Groups = new List<Group>
        {
            new Group
            {
                GroupId = Guid.NewGuid(), 
                ModuleId  = Guid.NewGuid(),
                Description = "This is a group for students to learn about software development",

            },
            new Group
            {
                GroupId = Guid.NewGuid(), 
                ModuleId  = Guid.NewGuid(),
                Description = "This is a group for students to learn about Computer Networking",

            },
            new Group
            {
                GroupId = Guid.NewGuid(), 
                ModuleId  = Guid.NewGuid(),
                Description = "This is a group for students to learn about Computer Security",

            }
        };
        
        
        _GroupRepositoryMock.Setup(u => u.GetAllGroups()).Returns(Groups);

        var controller = new GroupsController(_GroupRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllGroups();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Group>>(actual);
        Assert.Equal(3, (actual as List<Group>).Count);

    }
    
    [Fact]
    public async  Task GetGroupById_GroupId_ReturnsGroupOfId()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",

        };
        
        _GroupRepositoryMock.Setup(u => u.GetGroupById(Group.GroupId)).Returns(Group);
        
        var controller = new GroupsController(_GroupRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetGroupById(Group.GroupId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Group>(actual);
    }
    
    [Fact]
    public async  Task AddGroup_Group_ReturnsGroup()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",

        };
        _GroupRepositoryMock.Setup(u => u. createGroup(It.IsAny<Group>())).Returns(Group.GroupId);
        
        var controller = new GroupsController(_GroupRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.createGroup(Group);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }
    
 
    
    [Fact]
    public async Task DeleteGroupById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",

        };
            
        _GroupRepositoryMock.Setup(repo => repo.deleteGroupById(It.IsAny<Guid>())).Returns(true);
        var controller = new  GroupsController(_GroupRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteGroup(expectedTutor.GroupId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
    [Fact]
    public async Task DeleteGroupById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",

        };
            
        _GroupRepositoryMock.Setup(repo => repo.deleteGroupById(It.IsAny<Guid>())).Returns(false);
        var controller = new  GroupsController(_GroupRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteGroup(expectedTutor.GroupId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(false, actual);

    }
  
}