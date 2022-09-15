using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using NuGet.ContentModel;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Services;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class UserServicesUnitTests
{
    private readonly Mock<TutorMeContext> _UserRepositoryMock;
   

    public UserServicesUnitTests()
    {
        _UserRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllUsers_ReturnsListOfUsers()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        List<User> users = new List<User>
        {
            new User
            {
                UserId =new Guid(),
                FirstName ="Thabo",
                LastName ="Maduna",
                DateOfBirth ="02/04/2000",
                Status = true,
                Gender ="M",
                Email ="thaboMaduna527@gmail.com",
                Password ="24681012",
                UserTypeId =new Guid(),
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =new Guid(),
                FirstName ="Simphiwe",
                LastName ="Ndlovu",
                DateOfBirth ="02/04/1999",
                Status = true,
                Gender ="M",
                Email ="simphiwendlovu527@gmail.com",
                Password ="12345678",
                UserTypeId =new Guid(),
                InstitutionId =new Guid(),
                Location ="1166 Burnett St, Hatfield, Pretoria, 0028",
                Bio = "Naruto Fan",
                Year ="3",
                Rating =0
            },
            new User
            {
                UserId =new Guid(),
                FirstName ="Kuda",
                LastName ="Chivunga",
                DateOfBirth ="28/03/2000",
                Status = true,
                Gender ="F",
                Email ="kudaChivunga527@gmail.com",
                Password ="147258369",
                UserTypeId =new Guid(),
                InstitutionId =new Guid(),
                Location ="1166 TMN, 0028",
                Bio = "The boys",
                Year ="3",
                Rating =0
            }
        };

        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(users[0]);
            ctx.Add(users[1]);
            ctx.Add(users[2]);
            ctx.SaveChanges();
        }

        IEnumerable<User> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserServices(ctx1).GetAllUsers();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<User>>(result); 
        Assert.Equal(3, okResult.Count());
        var actualUsers = Assert.IsType<List<User>>(okResult);
        Assert.Equal(users[0].FirstName, actualUsers[0].FirstName);
        Assert.Equal(users[1].FirstName, actualUsers[1].FirstName);
        Assert.Equal(users[2].FirstName, actualUsers[2].FirstName);
    }
    
    [Fact]
    public void GetAllUsers_Returns_Empty_ListOfUsers()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<User> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserServices(ctx1).GetAllUsers();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<User>>(result); 
        Assert.Empty(okResult);
       
        
    }
    
    
    [Fact]
    public async  Task GetUserById_UserId_ReturnsUser()
    {
        //arrange
        var User = new User
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(User);
            ctx.SaveChanges();
        }

        User result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserServices(ctx1).GetUserById(User.UserId);
        }
        
        
        //act
        Assert.NotNull(result);
        Assert.IsType<User>(result);
        Assert.Equal(User.UserId, result.UserId);
        Assert.Equal(User.FirstName, result.FirstName);
        Assert.Equal(User.LastName, result.LastName);
        Assert.Equal(User.DateOfBirth, result.DateOfBirth);
        Assert.Equal(User.Status, result.Status);
        

        
    }
    [Fact]
    public async  Task GetUserById_UserId_Returns_User_not_found()
    {
        //arrange
        var User = new User
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        User result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new UserServices(ctx1).GetUserById(User.UserId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("User not found", e.Message);
        }
      
        
        
       
    }

    
    [Fact]
    public async  Task RegisterUser_Returns_UserId()
    {
        //arrange
        var User = new IUser
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
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
            result =new UserServices(ctx1).RegisterUser(User);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
        Assert.Equal(User.UserId, result);
    }
    
    // test CreateUser_Returns_createUser()
    // [Fact]
    // public async  Task RegisterUser_Returns_Type_already_exists()
    // {
    //     //arrange
    //     var iuser = new IUser
    //     {
    //         UserId =new Guid(),
    //         FirstName ="Thabo",
    //         LastName ="Maduna",
    //         DateOfBirth ="02/04/2000",
    //         Status = true,
    //         Gender ="M",
    //         Email ="thaboMaduna527@gmail.com",
    //         Password ="24681012",
    //         UserTypeId =new Guid(),
    //         InstitutionId =new Guid(),
    //         Location ="1166 TMN, 0028",
    //         Bio = "The boys",
    //         Year ="3",
    //         Rating =0
    //     };
    //     
    //     var User = new User
    //     {
    //         UserId =new Guid(),
    //         FirstName ="Thabo",
    //         LastName ="Maduna",
    //         DateOfBirth ="02/04/2000",
    //         Status = true,
    //         Gender ="M",
    //         Email ="thaboMaduna527@gmail.com",
    //         Password ="24681012",
    //         UserTypeId =new Guid(),
    //         InstitutionId =new Guid(),
    //         Location ="1166 TMN, 0028",
    //         Bio = "The boys",
    //         Year ="3",
    //         Rating =0
    //     };
    //     
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         ctx.Add(User);
    //     }
    //     Guid result;
    //     try
    //     {
    //         using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //         {
    //             result =new UserServices(ctx1).RegisterUser(iuser);
    //         }
    //     }
    //     catch (Exception e)
    //     {
    //         Assert.Equal("This User already exists, Please log in", e.Message);
    //     }
    //
    // }
    //
    
    
    [Fact]
    public async Task DeleteUserById_Returns_true()
    {
        //arrange
        var User = new User
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(User);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new UserServices(ctx1).DeleteUserById(User.UserId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteUserById_Returns_False()
    {
        //arrange
        var User = new User
        {
            UserId =new Guid(),
            FirstName ="Thabo",
            LastName ="Maduna",
            DateOfBirth ="02/04/2000",
            Status = true,
            Gender ="M",
            Email ="thaboMaduna527@gmail.com",
            Password ="24681012",
            UserTypeId =new Guid(),
            InstitutionId =new Guid(),
            Location ="1166 TMN, 0028",
            Bio = "The boys",
            Year ="3",
            Rating =0
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
                result =new UserServices(ctx1).DeleteUserById(User.UserId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("User not found", e.Message);
        }
    
    }
    
    //
    // [Fact]
    // public async Task UpdateUser_()
    // {
    //     //arrange
    //     var IUser = new IUser
    //     {
    //         UserId =new Guid(),
    //         FirstName ="Thabo",
    //         LastName ="Maduna",
    //         DateOfBirth ="02/04/2000",
    //         Status = true,
    //         Gender ="M",
    //         Email ="thaboMaduna527@gmail.com",
    //         Password ="24681012",
    //         UserTypeId =new Guid(),
    //         InstitutionId =new Guid(),
    //         Location ="1166 TMN, 0028",
    //         Bio = "The boys",
    //         Year ="3",
    //         Rating =0
    //     };
    //     
    //     var User = new User
    //     {
    //         UserId =IUser.UserId,
    //         FirstName ="Thabo",
    //         LastName ="Maduna",
    //         DateOfBirth ="02/04/2000",
    //         Status = true,
    //         Gender ="M",
    //         Email ="thaboMaduna527@gmail.com",
    //         Password ="24681012",
    //         UserTypeId =new Guid(),
    //         InstitutionId =new Guid(),
    //         Location ="1166 TMN, 0028",
    //         Bio = "The boys",
    //         Year ="3",
    //         Rating =0
    //     };
    //     
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //     
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         ctx.Add(User);
    //         ctx.SaveChanges();
    //     }
    //     
    //     //Change Bio
    //     User.Bio = "OverSimplified";
    //     User result;
    //      using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //      {
    //             result =new UserServices(ctx1).UpdateUser(IUser);
    //      }
    //     // Assert
    //     Assert.NotNull(result);
    //     Assert.IsType<User>(result);
    //     Assert.Equal(User.UserId, result.UserId);
    //     Assert.Equal("OverSimplified", result.Bio);
    //      
    // }
    //
    // [Fact]
    // public async Task UpdateUser_ThrowsAnException()
    // {
    //     //arrange
    //     var User = new IUser
    //     {
    //         UserId =new Guid(),
    //         FirstName ="Thabo",
    //         LastName ="Maduna",
    //         DateOfBirth ="02/04/2000",
    //         Status = true,
    //         Gender ="M",
    //         Email ="thaboMaduna527@gmail.com",
    //         Password ="24681012",
    //         UserTypeId =new Guid(),
    //         InstitutionId =new Guid(),
    //         Location ="1166 TMN, 0028",
    //         Bio = "The boys",
    //         Year ="3",
    //         Rating =0,
    //         
    //     };
    //     
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //     
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         ctx.Add(User);
    //         ctx.SaveChanges();
    //     }
    //     
    //     //Change Bio
    //     User.Bio = "OverSimplified";
    //     User result;
    //     using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //     {
    //         result =new UserServices(ctx1).UpdateUser(User);
    //     }
    //     // Assert
    //     Assert.NotNull(result);
    //     Assert.IsType<User>(result);
    //     Assert.Equal(User.UserId, result.UserId);
    //     //Assert.Equal("OverSimplified", result.Bio);
    //      
    // }

    // [Fact]
    // public async Task UpdateUser_Returns_User_not_found()
    // {
    //     //arrange
    //     var User = new IUser
    //     {
    //         UserId =new Guid(),
    //         FirstName ="Thabo",
    //         LastName ="Maduna",
    //         DateOfBirth ="02/04/2000",
    //         Status = true,
    //         Gender ="M",
    //         Email ="thaboMaduna527@gmail.com",
    //         Password ="24681012",
    //         UserTypeId =new Guid(),
    //         InstitutionId =new Guid(),
    //         Location ="1166 TMN, 0028",
    //         Bio = "The boys",
    //         Year ="3",
    //         Rating =0
    //     };
    //     
    //     DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
    //     var databaseName = MethodBase.GetCurrentMethod()?.Name;
    //     if (databaseName != null)
    //         optionsBuilder.UseInMemoryDatabase(databaseName);
    //     
    //     using (TutorMeContext ctx = new(optionsBuilder.Options))
    //     {
    //         //Empty TutorMeContext
    //     }
    //
    //     User result;
    //     try
    //     {
    //         using (TutorMeContext ctx1 = new(optionsBuilder.Options))
    //         {
    //             result =new UserServices(ctx1).UpdateUser(User);
    //         }
    //     }
    //     catch (Exception e)
    //     {
    //         Assert.Equal("User not found", e.Message);
    //     }
    //
    // }

    
  
}