using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using NuGet.ContentModel;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Models;
using TutorMe.Services;


namespace Tests.UnitTests;

public class GroupServicesUnitTests
{
    private readonly Mock<TutorMeContext> _GroupRepositoryMock;
   

    public GroupServicesUnitTests()
    {
        _GroupRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllGroups_ReturnsListOfGroups()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",
        };
        
        var Group2 = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about Computer Networking",
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Group);
            ctx.Add(Group2);
            ctx.SaveChanges();
        }

        IEnumerable<Group> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupServices(ctx1).GetAllGroups();
            //ToDo: Must change all getALL FUNCTIONS to return a list of objects
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Group>>(result); 
        Assert.Equal(2, okResult.Count());
        var Groups = Assert.IsType<List<Group>>(okResult);
        Assert.Equal(Group.GroupId, Groups[0].GroupId);
        Assert.Equal(Group2.GroupId, Groups[1].GroupId);
       
    }

   
       [Fact]
    public void GetAllGroups_Returns_Empty_ListOfGroups()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<Group> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupServices(ctx1).GetAllGroups();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Group>>(result); 
        Assert.Empty(okResult);

    }
    
        
    [Fact]
    public async  Task GetGroupById_GroupId_ReturnsGroup()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Group);
            ctx.SaveChanges();
        }

        Group result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupServices(ctx1).GetGroupById(Group.GroupId);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Group>(result);
        Assert.Equal(Group.GroupId, result.GroupId);
        Assert.Equal(Group.GroupId, result.GroupId);
        
    }
    
    
  [Fact]
    public async  Task GetGroupById_Returns_Group_not_found()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        Group result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new GroupServices(ctx1).GetGroupById(Group.GroupId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("Group not found", e.Message);
        }
      
        
        
       
    }

    
    [Fact]
    public async  Task CreateGroup_Group_Returns_GroupId()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",
        };

        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        Guid result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupServices(ctx1).createGroup(Group);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
        Assert.Equal(Group.GroupId, result);
    }
    
      // test CreateGroup_Returns_createGroup()
    [Fact]
    public async  Task CreateGroup_Returns_Type_already_exists()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Group);
        }
        Guid result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new GroupServices(ctx1).createGroup(Group);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("This user type already exists, Please log in", e.Message);
        }

    }
    
    
    
    [Fact]
    public async Task DeleteGroupById_Returns_true()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Group);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupServices(ctx1).deleteGroupById(Group.GroupId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
  
    [Fact]
    public async Task DeleteGroupById_Returns_False()
    {
        //arrange
        var Group = new Group
        {
            GroupId = Guid.NewGuid(), 
            ModuleId  = Guid.NewGuid(),
            Description = "This is a group for students to learn about software development",
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
           //Empty TutorMeContext
        }

        bool result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new GroupServices(ctx1).deleteGroupById(Group.GroupId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("Group not found", e.Message);
        }
    
    }
}