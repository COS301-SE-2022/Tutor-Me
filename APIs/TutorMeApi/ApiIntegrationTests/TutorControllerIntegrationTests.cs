using System.Reflection;
using Api.Controllers;
using Api.Data;
using Api.Models;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace IntegrationTests;

public class TutorControllerIntegrationTests
{
    //DTO
    private static Tutor CreateTutor()
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
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "2",
            Rating = "4",
            Requests =Guid.NewGuid().ToString(),
            Year= Guid.NewGuid().ToString()
        };
    }
    [Fact]
    public void ListsTutorsFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutor = CreateTutor();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutor);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<IEnumerable<Tutor>>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new TutorsController(ctx1).GetTutors();
            }
            
            
            var okResult = Assert.IsType<ActionResult<IEnumerable<Tutor >>>(result.Result);

            var tutors = Assert.IsType<List<Tutor>>(okResult.Value);
            var tutor = Assert.Single(tutors);
            Assert.NotNull(tutor);
            Assert.Equal("Simphiwe", tutor.FirstName);
            Assert.Equal("Ndlovu", tutor.LastName);
            Assert.Equal("26 April 1999", tutor.DateOfBirth);
            Assert.Equal("u19027372@tuks.co.za",tutor.Email);
            Assert.Equal("University Of Pretoria",tutor.Institution);
            tutor.Should().BeEquivalentTo(newTutor,
                //Verifying all the DTO variables matches the expected Tutor (newTutor)
                options => options.ComparingByMembers<Tutor>());
    }
    
    [Fact]
    public void GetsTutorFromDatabaseById()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutor = CreateTutor();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutor);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<Tutor>> result;
            using (TutorMeContext ctx1 = new(optionsBuilder.Options))
            {
                result =new TutorsController(ctx1).GetTutor(newTutor.Id);
            }
            
  
            var okResult = Assert.IsType<ActionResult<Tutor >>(result.Result);
            var tutor = Assert.IsType<Tutor>(okResult.Value);
            
           
            Assert.NotNull(tutor);
            Assert.Equal("Simphiwe", tutor.FirstName);
            Assert.Equal("Ndlovu", tutor.LastName);
            Assert.Equal("26 April 1999", tutor.DateOfBirth);
            Assert.Equal("u19027372@tuks.co.za",tutor.Email);
            Assert.Equal("University Of Pretoria",tutor.Institution);
            tutor.Should().BeEquivalentTo(newTutor,
                //Verifying all the DTO variables matches the expected Tutor (newTutor)
                options => options.ComparingByMembers<Tutor>());
    }
        
    [Fact]
    public void GetsTutorFromDatabaseByEmail()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutor = CreateTutor();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutor);
            ctx.SaveChangesAsync();
        }

        Task<ActionResult<Tutor>> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TutorsController(ctx1).GetTutorByEmail(newTutor.Email);
        }

        var okResult = Assert.IsType<ActionResult<Tutor >>(result.Result);
        var tutor = Assert.IsType<Tutor>(okResult.Value);
           
        Assert.NotNull(tutor);
        Assert.Equal("Simphiwe", tutor.FirstName);
        Assert.Equal("Ndlovu", tutor.LastName);
        Assert.Equal("26 April 1999", tutor.DateOfBirth);
        Assert.Equal("u19027372@tuks.co.za",tutor.Email);
        Assert.Equal("University Of Pretoria",tutor.Institution);
        tutor.Should().BeEquivalentTo(newTutor,
            //Verifying all the DTO variables matches the expected Tutor (newTutor)
            options => options.ComparingByMembers<Tutor>());
    }


    [Fact]
    public void ModifiesTutorFromDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutor = CreateTutor();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutor);
            ctx.SaveChangesAsync();
        }

        //Modify the tutors Bio
        newTutor.Bio = "Naruto fan";
        
        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TutorsController(ctx1).PutTutor(newTutor.Id,newTutor);
        }

        // result should be of type NoContentResult
        Assert.IsType<NoContentResult>(result.Result);
        
        //Now checking if the Bio was actually Modified on the database 
        Task<ActionResult<Tutor>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new TutorsController(ctx1).GetTutor(newTutor.Id);
        }

        var okResult = Assert.IsType<ActionResult<Tutor >>(resultCheck.Result);
        var tutor = Assert.IsType<Tutor>(okResult.Value);
           
        Assert.NotNull(tutor);
        Assert.Equal("Naruto fan",tutor.Bio);
        Assert.Equal("Simphiwe", tutor.FirstName);
        Assert.Equal("Ndlovu", tutor.LastName);
        Assert.Equal("26 April 1999", tutor.DateOfBirth);
        Assert.Equal("u19027372@tuks.co.za",tutor.Email);
        Assert.Equal("University Of Pretoria",tutor.Institution);
        tutor.Should().BeEquivalentTo(newTutor,
            //Verifying all the DTO variables matches the expected Tutor (newTutor)
            options => options.ComparingByMembers<Tutor>());
    }
    
    [Fact]
    public void AddsTutorToDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutor = CreateTutor();

        Task<ActionResult<Tutor>> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TutorsController(ctx1).PostTutor(newTutor);
        }

        Assert.IsType<ActionResult<Tutor >>(result.Result);
        
        //Now checking if the tutor was actually added to the database 
        Task<ActionResult<Tutor>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new TutorsController(ctx1).GetTutor(newTutor.Id);
        }

        var okResult = Assert.IsType<ActionResult<Tutor >>(resultCheck.Result);
        var tutor = Assert.IsType<Tutor>(okResult.Value);
           
        Assert.NotNull(tutor);
      
        Assert.Equal("Simphiwe", tutor.FirstName);
        Assert.Equal("Ndlovu", tutor.LastName);
        Assert.Equal("26 April 1999", tutor.DateOfBirth);
        Assert.Equal("u19027372@tuks.co.za",tutor.Email);
        Assert.Equal("University Of Pretoria",tutor.Institution);
        tutor.Should().BeEquivalentTo(newTutor,
            //Verifying all the DTO variables matches the expected Tutor (newTutor)
            options => options.ComparingByMembers<Tutor>());
    }
    
    [Fact]
    public void DeletesTutorOnDatabase()
    {
        DbContextOptionsBuilder<TutorMeContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);

        var newTutor = CreateTutor();
        using (TutorMeContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTutor);
            ctx.SaveChangesAsync();
        }
        

        Task<IActionResult> result;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TutorsController(ctx1).DeleteTutor(newTutor.Id);
        }

        Assert.IsType< NoContentResult>(result.Result);
        
        //Now checking if the tutor was actually deleted to the database 
        Task<ActionResult<Tutor>> resultCheck;
        using (TutorMeContext ctx1 = new(optionsBuilder.Options))
        {
            resultCheck =new TutorsController(ctx1).GetTutor(newTutor.Id);
        }

        var notFoundResult = Assert.IsType<ActionResult<Tutor >>(resultCheck.Result);
        var tutor = Assert.IsType<NotFoundResult>(notFoundResult.Result);
        Assert.NotNull(tutor);
        Assert.Equal(404, tutor.StatusCode);
        
    }

    }