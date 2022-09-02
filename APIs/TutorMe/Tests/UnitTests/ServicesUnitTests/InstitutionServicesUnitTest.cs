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

public class InstitutionServicesUnitTests
{
    private readonly Mock<TutorMeContext> _InstitutionRepositoryMock;
   

    public InstitutionServicesUnitTests()
    {
        _InstitutionRepositoryMock = new Mock<TutorMeContext>();
     
    }
    
    [Fact]
    public void GetAllInstitutions_ReturnsListOfInstitutions()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var Institution = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
        
        var Institution2 = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Johannesburg",
            // Faculty 
            Location ="Johannesburg"
        };
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Institution);
            ctx.Add(Institution2);
            ctx.SaveChanges();
        }

        IEnumerable<Institution> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new InstitutionServices(ctx1).GetAllInstitutions();
            //ToDo: Must change all getALL FUNCTIONS to return a list of objects
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Institution>>(result); 
        Assert.Equal(2, okResult.Count());
        var Institutions = Assert.IsType<List<Institution>>(okResult);
        Assert.Equal(Institution.InstitutionId, Institutions[0].InstitutionId);
        Assert.Equal(Institution2.InstitutionId, Institutions[1].InstitutionId);
       
    }
    
    [Fact]
    public void GetAllInstitutions_Returns_Empty_ListOfInstitutions()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }

        IEnumerable<Institution> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new InstitutionServices(ctx1).GetAllInstitutions();
        }
        
        Assert.NotNull(result);
        var okResult = Assert.IsType< List<Institution>>(result); 
        Assert.Empty(okResult);

    }
    
        
    [Fact]
    public async  Task GetInstitutionById_InstitutionId_ReturnsInstitution()
    {
        //arrange
        var Institution = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

      
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Institution);
            ctx.SaveChanges();
        }

        Institution result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new InstitutionServices(ctx1).GetInstitutionById(Institution.InstitutionId);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Institution>(result);
        Assert.Equal(Institution.InstitutionId, result.InstitutionId);
        Assert.Equal(Institution.InstitutionId, result.InstitutionId);
        
    }
    
    [Fact]
    public async  Task GetInstitutionById_InstitutionId_Returns_Institution_not_found()
    {
        //arrange
        var Institution = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            //Empty TutorMeContext
        }
        Institution result = null;
        try
        {
           
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new InstitutionServices(ctx1).GetInstitutionById(Institution.InstitutionId);
            }

        }
        catch (Exception e)
        {
            Assert.Equal("Institution not found", e.Message);
        }
      
        
        
       
    }

    
    [Fact]
    public async  Task CreateInstitution_Institution_Returns_InstitutionId()
    {
        //arrange
        var Institution = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
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
            result =new InstitutionServices(ctx1).createInstitution(Institution);
        }
        
        //act
        Assert.NotNull(result);
        Assert.IsType<Guid>(result);
        Assert.Equal(Institution.InstitutionId, result);
    }
    
    // test CreateInstitution_Returns_createInstitution()
    [Fact]
    public async  Task CreateInstitution_Returns_Type_already_exists()
    {
        //arrange
        var Institution = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Institution);
        }
        Guid result;
        try
        {
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new InstitutionServices(ctx1).createInstitution(Institution);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("This user type already exists, Please log in", e.Message);
        }

    }
    
    
    
    [Fact]
    public async Task DeleteInstitutionById_Returns_true()
    {
        //arrange
        var Institution = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
        
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
        
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(Institution);
            ctx.SaveChanges();
        }

        bool result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new InstitutionServices(ctx1).deleteInstitutionById(Institution.InstitutionId);
        }

        // Assert
        Assert.NotNull(result);
        Assert.IsType<Boolean>(result);
        Assert.Equal(true, result);
    
    }
    [Fact]
    public async Task DeleteInstitutionById_Returns_False()
    {
        //arrange
        var Institution = new Institution
        {
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
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
                result =new InstitutionServices(ctx1).deleteInstitutionById(Institution.InstitutionId);
            }
        }
        catch (Exception e)
        {
            Assert.Equal("Institution not found", e.Message);
        }
    
    }
  
}