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

public class UserTypeServicesUnitTests
{
    private readonly Mock<TutorMeContext> _UserTypeRepositoryMock;
   

    public UserTypeServicesUnitTests()
    {
        _UserTypeRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllUserTypes_ReturnsListOfUserTypes()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var userType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
        };
        
        var userType2 = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutee"
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(userType);
            ctx.Add(userType2);
            ctx.SaveChanges();
        }

        IEnumerable<UserType> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserTypeServices(ctx1).GetAllUserTypes();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<UserType>>(result); 
        Assert.Equal(2, okResult.Count());
        var userTypes = Assert.IsType<List<UserType>>(okResult);
        Assert.Equal(userType.Type, userTypes[0].Type);
        Assert.Equal(userType2.Type, userTypes[1].Type);
       
    }
    
    [Fact]
    public void GetAllUserTypes_Returns_Empty_ListOfUserTypes()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<UserType> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserTypeServices(ctx1).GetAllUserTypes();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<UserType>>(result); 
        Assert.Empty(okResult);
       
        
    }
    
    
    [Fact]
    public async  Task GetUserTypeById_UserTypeId_ReturnsUserType()
    {
        //arrange
        var userType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(userType);
            ctx.SaveChanges();
        }

        UserType result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserTypeServices(ctx1).GetUserTypeById(userType.UserTypeId);
        }
        
        
        //act
        Assert.NotNull(result);
        Assert.IsType<UserType>(result);
        Assert.Equal(userType.Type, result.Type);
        Assert.Equal(userType.UserTypeId, result.UserTypeId);
        
    }
    [Fact]
    public async  Task GetUserTypeById_UserTypeId_Returns_UserType_not_found()
    {
        //arrange
        var userType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        UserType result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new UserTypeServices(ctx1).GetUserTypeById(userType.UserTypeId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("UserType not found", e.Message);
        }
      
        
        
       
    }

    
    [Fact]
    public async  Task CreateUserType_UserType_Returns_UserTypeId()
    {
        //arrange
        var userType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
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
            result =new UserTypeServices(ctx1).createUserType(userType);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
        Assert.Equal(userType.UserTypeId, result);
    }
    
    // test CreateUserType_Returns_createUserType()
    [Fact]
    public async  Task CreateUserType_Returns_Type_already_exists()
    {
        //arrange
        var userType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(userType);
        }
        Guid result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new UserTypeServices(ctx1).createUserType(userType);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("This user type already exists, Please log in", e.Message);
        }

    }
    
    
    
    [Fact]
    public async Task DeleteUserTypeById_Returns_true()
    {
        //arrange
        var userType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(userType);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserTypeServices(ctx1).deleteUserTypeById(userType.UserTypeId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteUserTypeById_Returns_False()
    {
        //arrange
        var userType = new UserType
        {
            UserTypeId = Guid.NewGuid(),
            Type ="Tutor"
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
                result =new UserTypeServices(ctx1).deleteUserTypeById(userType.UserTypeId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("UserType not found", e.Message);
        }
    
    }
  
}