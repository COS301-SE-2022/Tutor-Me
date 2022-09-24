//using System.Reflection;
//using AutoMapper;
//using Microsoft.AspNetCore.Mvc;
//using Microsoft.EntityFrameworkCore;
//using Moq;
//using NuGet.Versioning;
//using TutorMe.Controllers;
//using TutorMe.Data;
//using TutorMe.Entities;
//using TutorMe.Models;
//using TutorMe.Services;

//namespace Tests.UnitTests;

//public class GroupControllerUnitTests
//{
//    private readonly Mock<IGroupService> groupRepositoryMock;
//    private static Mock<IMapper> _mapper;

//    public GroupControllerUnitTests()
//    {
//        groupRepositoryMock = new Mock<IGroupService>();
//        _mapper = new Mock<IMapper>();
//    }
    
//    [Fact]
//    public async Task  GetAllGroups_ListOfGroups_ReturnsListOfGroups()
//    {
    
//        //arrange
//        List<Group> groups = new List<Group>
//        {
//            new Group
//            {
//                GroupId = Guid.NewGuid(), 
//                ModuleId  = Guid.NewGuid(),
//                Description = "This is a group for students to learn about software development",

//            },
//            new Group
//            {
//                GroupId = Guid.NewGuid(), 
//                ModuleId  = Guid.NewGuid(),
//                Description = "This is a group for students to learn about Computer Networking",

//            },
//            new Group
//            {
//                GroupId = Guid.NewGuid(), 
//                ModuleId  = Guid.NewGuid(),
//                Description = "This is a group for students to learn about Computer Security",

//            }
//        };
        
        
//        groupRepositoryMock.Setup(u => u.GetAllGroups()).Returns(groups);

//        var controller = new GroupsController(groupRepositoryMock.Object, _mapper.Object);
//        var result = controller.GetAllGroups();


//        Assert.NotNull(result);
//        Assert.IsType<OkObjectResult>(result);
            
//        var actual = (result as OkObjectResult).Value;
//        Assert.IsType<List<Group>>(actual);
//        Assert.Equal(3, (actual as List<Group>).Count);

//    }
    
//    [Fact]
//    public async  Task GetGroupById_GroupId_ReturnsGroupOfId()
//    {
//        //arrange
//        var group = new Group
//        {
//            GroupId = Guid.NewGuid(), 
//            ModuleId  = Guid.NewGuid(),
//            Description = "This is a group for students to learn about software development",

//        };
        
//        groupRepositoryMock.Setup(u => u.GetGroupById(group.GroupId)).Returns(group);
        
//        var controller = new GroupsController(groupRepositoryMock.Object,_mapper.Object);
        
//        //act
//        var result = controller.GetGroupById(group.GroupId);
        
//        Assert.NotNull(result);
//        Assert.IsType<OkObjectResult>(result);

//        var actual = (result as OkObjectResult).Value;
//        Assert.IsType<Group>(actual);
//    }
    
//    [Fact]
//    public async  Task AddGroup_Group_ReturnsGroup()
//    {
//        //arrange
//        var group = new IGroup
//        {
//            GroupId = Guid.NewGuid(), 
//            ModuleId  = Guid.NewGuid(),
//            Description = "This is a group for students to learn about software development",

//        };
//        groupRepositoryMock.Setup(u => u. createGroup(It.IsAny<IGroup>())).Returns(group.GroupId);
        
//        var controller = new GroupsController(groupRepositoryMock.Object,_mapper.Object);
        
//        //act
//        var result =  controller.createGroup(group);
        
//        Assert.NotNull(result);
//        Assert.IsType<OkObjectResult>(result);
        
//        var actual = (result as OkObjectResult).Value;
//        Assert.IsType<System.Guid>(actual);
//    }
    
 
    
//    [Fact]
//    public async Task DeleteGroupById_Returns_true()
//    {

//        //Arrange
//        var expectedTutor =  new Group
//        {
//            GroupId = Guid.NewGuid(), 
//            ModuleId  = Guid.NewGuid(),
//            Description = "This is a group for students to learn about software development",

//        };
            
//        groupRepositoryMock.Setup(repo => repo.deleteGroupById(It.IsAny<Guid>())).Returns(true);
//        var controller = new  GroupsController(groupRepositoryMock.Object,_mapper.Object);

//        //Act
//        var result = controller.DeleteGroup(expectedTutor.GroupId);
//        // Assert
//        Assert.NotNull(result);
//        Assert.IsType<OkObjectResult>(result);
//        var actual = (result as OkObjectResult).Value;
//        Assert.IsType<Boolean>(actual);
//        Assert.Equal(true, actual);

//    }
    
//    [Fact]
//    public async Task DeleteGroupById_Returns_False()
//    {

//        //Arrange
//        var expectedTutor =  new Group
//        {
//            GroupId = Guid.NewGuid(), 
//            ModuleId  = Guid.NewGuid(),
//            Description = "This is a group for students to learn about software development",

//        };
            
//        groupRepositoryMock.Setup(repo => repo.deleteGroupById(It.IsAny<Guid>())).Returns(false);
//        var controller = new  GroupsController(groupRepositoryMock.Object,_mapper.Object);

//        //Act
//        var result = controller.DeleteGroup(expectedTutor.GroupId);
//        // Assert
//        Assert.NotNull(result);
//        Assert.IsType<OkObjectResult>(result);
//        var actual = (result as OkObjectResult).Value;
//        Assert.IsType<Boolean>(actual);
//        Assert.Equal(false, actual);

//    }
  
//}