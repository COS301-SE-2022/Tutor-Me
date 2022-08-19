using System.Reflection;
using Api.Controllers;
using Api.Data;
using Api.Models;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace IntegrationTests;

public class TuteeControllerIntegrationTests
{
    //DTO
    private static Tutee CreateTutee()
    {
        return new()
        {
            Id = Guid.NewGuid(),
            FirstName = "Simphiwe",
            LastName = "Ndlovu",
            DateOfBirth = "26 April 1999",
            Gender = "M",
            Status = Guid.NewGuid().ToString(),
            Faculty = Guid.NewGuid().ToString(),
            Course = Guid.NewGuid().ToString(),
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u19027372@tuks.co.za",
            Password = Guid.NewGuid().ToString(),
            Location = Guid.NewGuid().ToString(),
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "2",
            Year = Guid.NewGuid().ToString(),
            GroupIds=Guid.NewGuid().ToString()
        };
    }
    [Fact]
    public void ListsTuteesFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutee = CreateTutee();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutee);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<IEnumerable<Tutee>>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new TuteesController(ctx1).GetTutees();
            }
            
            
            var okResult = Assert.IsType<ActionResult<IEnumerable<Tutee >>>(result.Result);

            var Tutees = Assert.IsType<List<Tutee>>(okResult.Value);
            var Tutee = Assert.Single(Tutees);
            Assert.NotNull(Tutee);
            Assert.Equal("Simphiwe", Tutee.FirstName);
            Assert.Equal("Ndlovu", Tutee.LastName);
            Assert.Equal("26 April 1999", Tutee.DateOfBirth);
            Assert.Equal("u19027372@tuks.co.za",Tutee.Email);
            Assert.Equal("University Of Pretoria",Tutee.Institution);
            Tutee.Should().BeEquivalentTo(newTutee,
                //Verifying all the DTO variables matches the expected Tutee (newTutee)
                options => options.ComparingByMembers<Tutee>());
    }
    
    [Fact]
    public void GetsTuteeFromDatabaseById()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutee = CreateTutee();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutee);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<Tutee>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new TuteesController(ctx1).GetTutee(newTutee.Id);
            }
            
  
            var okResult = Assert.IsType<ActionResult<Tutee >>(result.Result);
            var Tutee = Assert.IsType<Tutee>(okResult.Value);
            
           
            Assert.NotNull(Tutee);
            Assert.Equal("Simphiwe", Tutee.FirstName);
            Assert.Equal("Ndlovu", Tutee.LastName);
            Assert.Equal("26 April 1999", Tutee.DateOfBirth);
            Assert.Equal("u19027372@tuks.co.za",Tutee.Email);
            Assert.Equal("University Of Pretoria",Tutee.Institution);
            Tutee.Should().BeEquivalentTo(newTutee,
                //Verifying all the DTO variables matches the expected Tutee (newTutee)
                options => options.ComparingByMembers<Tutee>());
    }


    [Fact]
    public void ModifiesTuteeFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutee = CreateTutee();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutee);
            ctx.SaveChangesAsync();
        }

        //Modify the Tutees Bio
        newTutee.Bio = "Naruto fan";
        
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TuteesController(ctx1).PutTutee(newTutee.Id,newTutee);
        }

        // result should be of type NoContentResult
        Assert.IsType<NoContentResult>(result.Result);
        
        //Now checking if the Bio was actually Modified on the database 
        Task<ActionResult<Tutee>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new TuteesController(ctx1).GetTutee(newTutee.Id);
        }

        var okResult = Assert.IsType<ActionResult<Tutee >>(resultCheck.Result);
        var Tutee = Assert.IsType<Tutee>(okResult.Value);
           
        Assert.NotNull(Tutee);
        Assert.Equal("Naruto fan",Tutee.Bio);
        Assert.Equal("Simphiwe", Tutee.FirstName);
        Assert.Equal("Ndlovu", Tutee.LastName);
        Assert.Equal("26 April 1999", Tutee.DateOfBirth);
        Assert.Equal("u19027372@tuks.co.za",Tutee.Email);
        Assert.Equal("University Of Pretoria",Tutee.Institution);
        Tutee.Should().BeEquivalentTo(newTutee,
            //Verifying all the DTO variables matches the expected Tutee (newTutee)
            options => options.ComparingByMembers<Tutee>());
    }
    
    [Fact]
    public void AddsTuteeToDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutee = CreateTutee();

        Task<ActionResult<Tutee>> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TuteesController(ctx1).PostTutee(newTutee);
        }

        Assert.IsType<ActionResult<Tutee >>(result.Result);
        
        //Now checking if the Tutee was actually added to the database 
        Task<ActionResult<Tutee>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new TuteesController(ctx1).GetTutee(newTutee.Id);
        }

        var okResult = Assert.IsType<ActionResult<Tutee >>(resultCheck.Result);
        var Tutee = Assert.IsType<Tutee>(okResult.Value);
           
        Assert.NotNull(Tutee);
      
        Assert.Equal("Simphiwe", Tutee.FirstName);
        Assert.Equal("Ndlovu", Tutee.LastName);
        Assert.Equal("26 April 1999", Tutee.DateOfBirth);
        Assert.Equal("u19027372@tuks.co.za",Tutee.Email);
        Assert.Equal("University Of Pretoria",Tutee.Institution);
        Tutee.Should().BeEquivalentTo(newTutee,
            //Verifying all the DTO variables matches the expected Tutee (newTutee)
            options => options.ComparingByMembers<Tutee>());
    }
    
    [Fact]
    public void DeletesTuteeOnDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutee = CreateTutee();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutee);
            ctx.SaveChangesAsync();
        }
        

        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TuteesController(ctx1).DeleteTutee(newTutee.Id);
        }

        Assert.IsType< NoContentResult>(result.Result);
        
        //Now checking if the Tutee was actually deleted to the database 
        Task<ActionResult<Tutee>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new TuteesController(ctx1).GetTutee(newTutee.Id);
        }

        var notFoundResult = Assert.IsType<ActionResult<Tutee >>(resultCheck.Result);
        var Tutee = Assert.IsType<NotFoundResult>(notFoundResult.Result);
        Assert.NotNull(Tutee);
        Assert.Equal(404, Tutee.StatusCode);
        
    }

    }