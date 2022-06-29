using System.Data.Common;
using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;


namespace ApiUnitTests;

using FluentAssertions;
using Moq;
public class TuteeUnitTests
{
     List<Tutee> _expectedTutees=new List <Tutee>{ createTutee(), createTutee(), createTutee(), createTutee() };

      //DTO
     private  static Tutee createTutee() 
    {
        return new()
        { 
            Id =Guid.NewGuid(),
            FirstName =Guid.NewGuid().ToString(),
            LastName =Guid.NewGuid().ToString(),
            DateOfBirth =Guid.NewGuid().ToString(),
            Gender =Guid.NewGuid().ToString(),
            Status =Guid.NewGuid().ToString(),
            Faculty =Guid.NewGuid().ToString(),
            Course =Guid.NewGuid().ToString(),
            Institution=Guid.NewGuid().ToString(),
            Modules =Guid.NewGuid().ToString(),
            Email =Guid.NewGuid().ToString(),
            Password =Guid.NewGuid().ToString(),
            Location =Guid.NewGuid().ToString(),
            TutorsCode= Guid.NewGuid().ToString(),
            Bio =Guid.NewGuid().ToString(),
            Connections =Guid.NewGuid().ToString()
         
        };
    }
    [Fact]
    public async Task GetTuteeAsync_WithUnexistingTutee_ReturnsNotFound()
    {
        //Arranage
        
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Type>())).ReturnsAsync((Tutee)null);
        var controller = new TuteesController(repositoryStub.Object);
        
        //Act
        var result = await controller.GetTutee(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetTuteeAsync_WithUnExistingDb_ReturnsFound()
    {   
        //Arranage
        var expectedTutee = createTutee();
        // id = Guid.NewGuid();
        
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutee));
        var controller = new TuteesController(repositoryStub.Object);
        
        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetTutee(yourGuid);
    
        //Assert 
        result.Value.Should().BeEquivalentTo(expectedTutee,
            //Verifying all the DTO variables matches the expected Tutee 
              options => options.ComparingByMembers<Tutee>());
        
    }
    [Fact]
    public async Task GetTuteeAsync_WithanEmpyDb()
    {       
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);
        
        //Act
        var controller = new TuteesController(repositoryStub.Object);
       
        var result = await controller.GetTutee(new Guid());
    
        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //  GetTutees
    [Fact]
    public async Task GetTuteesAsync_WithExistingItem_ReturnsFound()
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        var controller = new TuteesController(repositoryStub.Object);

          
        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetTutees();
    
        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetTutee Method to return a list of Tutees
    [Fact]
    public async Task GetTuteesAsync_WithExistingItemReturnsFound()
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);
        
        //Act
        var controller = new TuteesController(repositoryStub.Object);
       
        var result = await controller.GetTutees();
    
        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    // [Fact]
    // public async Task GetTuteeByEmail_WithExistingEmailReturnsFound()
    // {
    //     //Arranage
    //     var repositoryStub = new Mock<TutorMeContext>();
    //     //setup repositorystub to null
    //     repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);
    //     
    //     //Act
    //     var controller = new TuteesController(repositoryStub.Object);
    //    var id= Guid.NewGuid();
    //    var email= Guid.NewGuid().ToString();
    //     var result = await controller.GetTuteeByEmail(email,id);
    //
    //     //Assert     
    //     Assert.IsType<NotFoundResult>(result.Result);
    // }
    
    //Test the PutTutee Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task PutTutee_With_differentIds_BadRequestResult()
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        var expectedTutee = createTutee();
         //Act
        var controller = new TuteesController(repositoryStub.Object);
        var id= Guid.NewGuid();
        var email= Guid.NewGuid().ToString();
        var result = await controller.PutTutee(id,expectedTutee);

        //Assert     
        Assert.IsType< BadRequestResult>(result);
    }
   
    [Fact]
    public async Task PutTutee_With_same_Id_but_UnExisting_Tutor_returns_NullReferenceException()//####
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        var expectedTutee = createTutee();
        //repositoryStub.Setup(repo => repo.Tutees.Find(expectedTutee.Id).Equals(expectedTutee.Id)).Returns(false);
       repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);
        //Act
        var controller = new TuteesController(repositoryStub.Object);
        var id= Guid.NewGuid();
        var email= Guid.NewGuid().ToString();
        try
        {
            var result = await controller.PutTutee(expectedTutee.Id,expectedTutee);
        }
        //Assert   
        catch(Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }
    [Fact]
    public async Task  PutTutee_WithUnExistingId_NotFound()
    {
        //Arranage
        var repositoryStub = new Mock<TutorMeContext>();
        //setup repositorystub to null
        var expectedTutee = createTutee();
        //Act
        var controller = new TuteesController(repositoryStub.Object);
        var id= Guid.NewGuid();
        var email= Guid.NewGuid().ToString();
        var result = await controller.PutTutee(id,expectedTutee);

        //Assert     
        Assert.IsType< BadRequestResult>(result);
    }

 


    [Fact]
    public async Task PostTutee_and_returns_a_type_of_Action_Result_returns_null()
    {
         
        //Arranage
        var expectedTutee = createTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutee));
        var controller = new TuteesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.PostTutee(expectedTutee);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Tutee>>(result);
      
    }
    [Fact]
     public async Task PostTutee_and_returns_a_type_of_Action()
    {
         
        //Arranage
        var expectedTutee = createTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutee)null);
        var controller = new TuteesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.PostTutee(expectedTutee);
        // Assert
       // Assert.IsType<ActionResult<Api.Models.Tutee>>(result);
       Assert.Null(result.Value);
    }
     [Fact]
     public async Task PostTutee_and_returns_ObjectResult()
     {
         
         //Arranage
         var expectedTutee = createTutee();

         var repositoryStub = new Mock<TutorMeContext>();
         repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);

         var controller = new TuteesController(repositoryStub.Object);
        
         //Act
        
         var result = await controller.PostTutee(expectedTutee);
         // Assert
         // Assert.IsType<ActionResult<Api.Models.Tutee>>(result);
         Assert.IsType<ObjectResult>(result.Result);
     }
     [Fact]
     public async Task PostTutee_and_returns_CreatedAtActionResult()
     {
         
         //Arranage
         var expectedTutee = createTutee();

         var repositoryStub = new Mock<TutorMeContext>();
         repositoryStub.Setup(repo => repo.Tutees.Add(expectedTutee)).Returns((Func<EntityEntry<Tutee>>)null);

         var controller = new TuteesController(repositoryStub.Object);
        
         //Act
        
         var result = await controller.PostTutee(expectedTutee);
         // Assert
         // Assert.IsType<ActionResult<Api.Models.Tutee>>(result);
         Assert.IsType<CreatedAtActionResult>(result.Result);
     }
     [Fact]
     public async Task PostTutee_and_returns_TuteeExists_DbUpdateException()
     {
         
         //Arranage
         var expectedTutee = createTutee();

         var repositoryStub = new Mock<TutorMeContext>();
         repositoryStub.Setup(repo => repo.Tutees.Add(expectedTutee)).Throws<DbUpdateException>();

         //repositoryStub.Setup(repo => repo.Tutees.Update(expectedTutee)).Throws< DbUpdateException>();

         var controller = new TuteesController(repositoryStub.Object);
        
         //Act
         try
         {
             var result = await controller.PostTutee(expectedTutee);
         }
         // Assert
         catch(Exception e)
         {
             Assert.IsType<DbUpdateException>(e);
         }
         
     }
  
    [Fact]  
    public async Task DeleteTutee_and_returns_a_type_of_NotFoundResult()
    {
         
        //Arranage
        var expectedTutee = createTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutee)null);
        var controller = new TuteesController(repositoryStub.Object);
        
        //Act
        var result = await controller.DeleteTutee(expectedTutee.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
     // Mock the DeleteTutee method  and return a Value 
    [Fact]
    public async Task DeleteTutee_and_returns_a_type_of_NoContentResult()
    {
         
        //Arranage
        var expectedTutee = createTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedTutee);
        var controller = new TuteesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.DeleteTutee(expectedTutee.Id);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
    [Fact]
    public async Task DeleteTutee_and_returns_a_type_of_NotFound()
    {
         
        //Arranage
        var expectedTutee = createTutee();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutees).Returns((DbSet<Tutee>)null);
        var controller = new TuteesController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.DeleteTutee(expectedTutee.Id);
        // Assert
        Assert.IsType< NotFoundResult>(result);
    }
    



}

