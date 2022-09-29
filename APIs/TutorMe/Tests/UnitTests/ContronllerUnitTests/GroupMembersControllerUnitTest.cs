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

public class GroupMembersControllerUnitTests
{
    private readonly Mock<IGroupMemberService> _GroupMemberRepositoryMock;
    private static Mock<IMapper> _mapper;

    public GroupMembersControllerUnitTests()
    {
        _GroupMemberRepositoryMock = new Mock<IGroupMemberService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllGroupMembers_ListOfGroupMembers_ReturnsListOfGroupMembers()
    {
    
        //arrange
        List<GroupMember> GroupMembers = new List<GroupMember>
        {
            new GroupMember
            {
                GroupMemberId = Guid.NewGuid(),
                GroupId= Guid.NewGuid(),
                UserId= Guid.NewGuid(),

            },
            new GroupMember
            {
                GroupMemberId = Guid.NewGuid(),
                GroupId= Guid.NewGuid(),
                UserId= Guid.NewGuid(),
            },
            new GroupMember
            {
                GroupMemberId = Guid.NewGuid(),
                GroupId= Guid.NewGuid(),
                UserId= Guid.NewGuid(),
            }
        };
        
        
        _GroupMemberRepositoryMock.Setup(u => u.GetAllGroupMembers()).Returns(GroupMembers);

        var controller = new GroupMembersController(_GroupMemberRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllGroupMembers();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<GroupMember>>(actual);
        Assert.Equal(3, (actual as List<GroupMember>).Count);

    }
    
    [Fact]
    public async  Task GetGroupMemberById_GroupMemberId_ReturnsGroupMemberOfId()
    {
        //arrange
        var GroupMember = new GroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        
        _GroupMemberRepositoryMock.Setup(u => u.GetGroupMemberById(GroupMember.GroupMemberId)).Returns(GroupMember);
        
        var controller = new GroupMembersController(_GroupMemberRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetGroupMemberById(GroupMember.GroupMemberId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<GroupMember>(actual);
    }
    
    [Fact]
    public async  Task AddGroupMember_GroupMember_ReturnsGroupMember()
    {
        //arrange
        var GroupMember = new IGroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        _GroupMemberRepositoryMock.Setup(u => u. createGroupMember(It.IsAny<IGroupMember>())).Returns(GroupMember.GroupMemberId);
        
        var controller = new GroupMembersController(_GroupMemberRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.createGroupMember(GroupMember);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }
    
 
    
    [Fact]
    public async Task DeleteGroupMemberById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new IGroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
            
        _GroupMemberRepositoryMock.Setup(repo => repo.deleteGroupMemberById(It.IsAny<Guid>())).Returns(true);
        var controller = new  GroupMembersController(_GroupMemberRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteGroupMember(expectedTutor.GroupMemberId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
    [Fact]
    public async Task DeleteGroupMemberById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new IGroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
            
        _GroupMemberRepositoryMock.Setup(repo => repo.deleteGroupMemberById(It.IsAny<Guid>())).Returns(false);
        var controller = new  GroupMembersController(_GroupMemberRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteGroupMember(expectedTutor.GroupMemberId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(false, actual);

    }
  
}