using System.Reflection;
using Microsoft.EntityFrameworkCore;
using Moq;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Services;
using TutorMe.Models;


namespace Tests.UnitTests;

public class GroupMemberServicesUnitTests
{
    private readonly Mock<TutorMeContext> _GroupMemberRepositoryMock;
   

    public GroupMemberServicesUnitTests()
    {
        _GroupMemberRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllGroupMembers_ReturnsListOfGroupMembers()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var GroupMember = new GroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        
        var GroupMember2 = new GroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(GroupMember);
            ctx.Add(GroupMember2);
            ctx.SaveChanges();
        }

        IEnumerable<GroupMember> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupMemberServices(ctx1).GetAllGroupMembers();
            //ToDo: Must change all getALL FUNCTIONS to return a list of objects
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<GroupMember>>(result); 
        Assert.Equal(2, okResult.Count());
        var GroupMembers = Assert.IsType<List<GroupMember>>(okResult);
        Assert.Equal(GroupMember.GroupMemberId, GroupMembers[0].GroupMemberId);
        Assert.Equal(GroupMember2.GroupMemberId, GroupMembers[1].GroupMemberId);
       
    }
    
    [Fact]
    public void GetAllGroupMembers_Returns_Empty_ListOfGroupMembers()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<GroupMember> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupMemberServices(ctx1).GetAllGroupMembers();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<GroupMember>>(result); 
        Assert.Empty(okResult);

    }
    
        
    [Fact]
    public async  Task GetGroupMemberById_GroupMemberId_ReturnsGroupMember()
    {
        //arrange
        var GroupMember = new GroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(GroupMember);
            ctx.SaveChanges();
        }

        GroupMember result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupMemberServices(ctx1).GetGroupMemberById(GroupMember.GroupMemberId);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<GroupMember>(result);
        Assert.Equal(GroupMember.GroupMemberId, result.GroupMemberId);
        Assert.Equal(GroupMember.GroupMemberId, result.GroupMemberId);
        
    }
    
    [Fact]
    public async  Task GetGroupMemberById_GroupMemberId_Returns_GroupMember_not_found()
    {
        //arrange
        var GroupMember = new GroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        GroupMember result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new GroupMemberServices(ctx1).GetGroupMemberById(GroupMember.GroupMemberId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("GroupMember not found", e.Message);
        }
      
        
        
       
    }

    
    [Fact]
    public async  Task CreateGroupMember_GroupMember_Returns_GroupMemberId()
    {
        //arrange
        var GroupMember = new IGroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
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
            result =new GroupMemberServices(ctx1).createGroupMember(GroupMember);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
        Assert.Equal(GroupMember.GroupMemberId, result);
    }
    
    // test CreateGroupMember_Returns_createGroupMember()
    [Fact]
    public async  Task CreateGroupMember_Returns_Type_already_exists()
    {
        //arrange
        var GroupMember = new IGroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(GroupMember);
        }
        Guid result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new GroupMemberServices(ctx1).createGroupMember(GroupMember);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("This user type already exists, Please log in", e.Message);
        }

    }
    
    
    
    [Fact]
    public async Task DeleteGroupMemberById_Returns_true()
    {
        //arrange
        var GroupMember = new GroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(GroupMember);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new GroupMemberServices(ctx1).deleteGroupMemberById(GroupMember.GroupMemberId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteGroupMemberById_Returns_False()
    {
        //arrange
        var GroupMember = new GroupMember
        {
            GroupMemberId = Guid.NewGuid(),
            GroupId= Guid.NewGuid(),
            UserId= Guid.NewGuid(),
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
                result =new GroupMemberServices(ctx1).deleteGroupMemberById(GroupMember.GroupMemberId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("GroupMember not found", e.Message);
        }
    
    }
  
}