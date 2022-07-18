using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace ApiUnitTests;

using FluentAssertions;
using Moq;
public class GroupUnitTests
{
    //DTO
    private static Group CreateGroup()
    {
        return new()
        { 
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName =Guid.NewGuid().ToString(),
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description=Guid.NewGuid().ToString(),
        };
    }

    [Fact]
    public async Task GetGroupAsync_WithUnExistingGroup_ReturnsNotFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Type>())).ReturnsAsync((Group)null);
        var controller = new GroupsController(repositoryStub.Object);

        //Act
        var result = await controller.GetGroup(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetGroupAsync_WithUnExistingDb_ReturnsFound()
    {
        //Arrange
        var expectedGroup = CreateGroup();
       
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedGroup));
        var controller = new GroupsController(repositoryStub.Object);

        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetGroup(yourGuid);

        //Assert 
        result.Value.Should().BeEquivalentTo(expectedGroup,
              //Verifying all the DTO variables matches the expected Group 
              options => options.ComparingByMembers<Group>());

    }

    [Fact]
    public async Task GetGroupAsync_WithAnEmptyDb()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group).Returns((DbSet<Group>)null);

        //Act
        var controller = new GroupsController(repositoryStub.Object);

        var result = await controller.GetGroup(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetGroupsAsync_WithExistingItem_ReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new GroupsController(repositoryStub.Object);


        //Act
        var result = await controller.GetGroups();

        //Assert     
        Assert.Null(result.Value);

    }

    [Fact]
    public async Task GetGroupsAsync_WithExistingItemReturnsFound()
    {
        //Arrange
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Group).Returns((DbSet<Group>)null);

        //Act
        var controller = new GroupsController(repositoryStub.Object);

        var result = await controller.GetGroups();

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
   

}