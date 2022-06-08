using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;


using FluentAssertions;
using Moq;
namespace ApiUnitTests;

public class TutteeUnitTests
{
      List<Tutee> _expectedTutees=new List <Tutee>{ createTutee(), createTutee(), createTutee(), createTutee() };

      //DTO
     private  static Tutee createTutee() 
    {
        return new()
        {
            Id = Guid.NewGuid(),
            FirstName = Guid.NewGuid().ToString(),
            LastName = Guid.NewGuid().ToString(),
            DateOfBirth = Guid.NewGuid().ToString(),
            Gender = Guid.NewGuid().ToString(),
            Institution = Guid.NewGuid().ToString(),
            Modules = Guid.NewGuid().ToString(),
            Email = Guid.NewGuid().ToString(),
            Password = Guid.NewGuid().ToString(),
            Location = Guid.NewGuid().ToString(),
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = Guid.NewGuid().ToString(),
            Connections = Guid.NewGuid().ToString(),
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
    public async Task GetTuteeAsync_WithExistingItem_ReturnsFound()
    {

        //Arranage
        var expectedTutee = createTutee();
    
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
        public async Task PutTutee_Update_with_UnExisting_Tutee_Returnns_Null()
        {
            //Arrange
            Tutee TuteeNew = createTutee();

            //Act
            var TuteeToUpdate = new Tutee
            {
                Id = Guid.NewGuid(),//Changed the id
                FirstName = TuteeNew.FirstName,
                LastName = TuteeNew.LastName,
                Age = TuteeNew.Age,
                Gender = TuteeNew.Gender,
                Institution = TuteeNew.Institution,
                Modules = TuteeNew.Modules,
                Email = TuteeNew.Email,
                Password = TuteeNew.Password,
                Location = TuteeNew.Location,
                TutorsCode = TuteeNew.TutorsCode,
                Bio = TuteeNew.Bio,
                Connections = TuteeNew.Connections
            };

            var Tutee = MockPutTutee(Guid.NewGuid(), TuteeNew);
            // Assert
            Assert.Null(Tutee);

        }
            [Fact]
        public Task PutTutee_Update_with_an_Existing_Tutor_Returnns_TuteeObject()
    {
        //Arrange
        Tutee ExistingTutee = createTutee();
            ExistingTutee.Id = _expectedTutees[0].Id;
            Guid ExistingTuteeID = ExistingTutee.Id;

            //Act
            var TuteeToUpdate = new Tutee
            {
                Id = Guid.NewGuid(),//change Bio
                FirstName = ExistingTutee.FirstName,
                LastName = ExistingTutee.LastName,
                Age = ExistingTutee.Age,
                Gender = ExistingTutee.Gender,
                Institution = ExistingTutee.Institution,
                Modules = ExistingTutee.Modules,
                Email = ExistingTutee.Email,
                Password = ExistingTutee.Password,
                Location = ExistingTutee.Location,
                TutorsCode = ExistingTutee.TutorsCode,
                Bio = "I love testing",
                Connections = ExistingTutee.Connections
            };

            var Tutee = MockPutTutee(ExistingTuteeID, TuteeToUpdate);
            // Assert
            bool status = Tutee.Bio == "I love testing";
            Assert.NotNull(Tutee);
            Assert.True(status);
        return Task.CompletedTask;
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
        Assert.Null(result.Value);
    }
    // Mock the DeleteTutee method  and return a null value 
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
     private bool MOckTuteeExists(Guid id)
    {
        return (_expectedTutees?.Any(e => e.Id == id)).GetValueOrDefault();
    }
    [Fact]
    public Task TuteeExists_Returns_True()
    {
        //Arranage
        var existingTutee = createTutee();
        _expectedTutees.Add(existingTutee);
        
        //Act
        bool status= MOckTuteeExists(existingTutee.Id);

        // Assert
        Assert.True(status);
        return Task.CompletedTask;
    }

    [Fact]
    public void TuteeExists_Returns_False()
    {
        //Arranage
        var UnexistingTutee = createTutee();

        //Act
        bool status = MOckTuteeExists(UnexistingTutee.Id);

        // Assert
        Assert.False((status));
    }
      [Fact]
    public Task GetTuteeByEmail_returns_the_correct_Tutee()
    {
        //Arranage
        var emailOfTutee = _expectedTutees[0].Email;
        var expectedTutee = _expectedTutees[0];

        //Act
        var result = MoqGetTuteeByEmail(emailOfTutee);
    
        //Assert     
        result.Should().BeEquivalentTo(expectedTutee,
            //Verifying all the DTO variables matches the expected Tutee 
            options => options.ComparingByMembers<Tutee>());
        return Task.CompletedTask;
    }

    [Fact]
    public Task GetTuteeByEmail_returns_not_found ()
    {
        //Arranage
        var Unexsisting_emailOfTutee = "u19027372@tuks.co.za";
        var expectedTutee = _expectedTutees[0];

        //Act
        var result = MoqGetTuteeByEmail(Unexsisting_emailOfTutee);
        
        //Assert     
        Assert.Null(result);
        return Task.CompletedTask;
    }

    public Tutee? MoqGetTuteeByEmail( string email, Guid id = default(Guid)){
        if (_expectedTutees== null)
        {
            return null;
        }

        var Tutee = _expectedTutees.Find(e => e.Email == email);
        
        if (Tutee == null)
        {

            return null;
        }

        return Tutee;
    }
      
    public Tutee MockPutTutee(Guid id,Tutee Tutee)
    {
        
        bool status=false;
        for (int i = 0; i < _expectedTutees.Count; i++)
        {
            if (id == _expectedTutees[i].Id)
            {
                status = true;
            }
        }

        if (status == false)
        {
            return null;// bad request
        }
   
        bool checkEmail = false;
        
        var TuteeToUpdate = new Tutee
        {
            Id = Tutee.Id,
            FirstName = Tutee.FirstName,
            LastName = Tutee.LastName,
            Age = Tutee.Age,
            Gender = Tutee.Gender,
            Institution = Tutee.Institution,
            Modules = Tutee.Modules,
            Email = Tutee.Email,
            Password = Tutee.Password,
            Location = Tutee.Location,
            TutorsCode = Tutee.TutorsCode,
            Bio = Tutee.Bio,
            Connections = Tutee.Connections
        };

        return TuteeToUpdate;
        
    }

    
}