using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;


namespace ApiUnitTests;

using FluentAssertions;
using Moq;
public class TutorUnitTests
{
     List<Tutor> _expectedTutors=new List <Tutor>{ createTutor(), createTutor(), createTutor(), createTutor() };

      //DTO
     private  static Tutor createTutor() 
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
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = Guid.NewGuid().ToString(),
            Connections = Guid.NewGuid().ToString(),
        };
    }
    [Fact]
    public async Task GetTutorAsync_WithUnexistingTutor_ReturnsNotFound()
    {
        //Arranage
      
        
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Type>())).ReturnsAsync((Tutor)null);
        var controller = new TutorsController(repositoryStub.Object);
        
        //Act
        var result = await controller.GetTutor(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetTutorAsync_WithExistingItem_ReturnsFound()
    {

        //Arranage
        var expectedTutor = createTutor();
        // id = Guid.NewGuid();
        
        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutor));
        var controller = new TutorsController(repositoryStub.Object);
        
        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetTutor(yourGuid);
    
        //Assert     
      
    
             result.Value.Should().BeEquivalentTo(expectedTutor,
            //Verifying all the DTO variables matches the expected Tutor 
              options => options.ComparingByMembers<Tutor>());
        
    }


      [Fact]
        public async Task PutTutor_Update_with_UnExisting_Tutor_Returnns_Null()
        {
            //Arrange
            Tutor tutorNew = createTutor();

            //Act
            var tutorToUpdate = new Tutor
            {
                Id = Guid.NewGuid(),//Changed the id
                FirstName = tutorNew.FirstName,
                LastName = tutorNew.LastName,
                Age = tutorNew.Age,
                Gender = tutorNew.Gender,
                Institution = tutorNew.Institution,
                Modules = tutorNew.Modules,
                Email = tutorNew.Email,
                Password = tutorNew.Password,
                Location = tutorNew.Location,
                TuteesCode = tutorNew.TuteesCode,
                Bio = tutorNew.Bio,
                Connections = tutorNew.Connections
            };

            var tutor = MockPutTutor(Guid.NewGuid(), tutorNew);
            // Assert
            Assert.Null(tutor);

        }
            [Fact]
        public Task PutTutor_Update_with_an_Existing_Tutor_Returnns_tutorObject()
    {
        //Arrange
        Tutor Existingtutor = createTutor();
            Existingtutor.Id = _expectedTutors[0].Id;
            Guid ExistingtutorID = Existingtutor.Id;

            //Act
            var tutorToUpdate = new Tutor
            {
                Id = Guid.NewGuid(),//change Bio
                FirstName = Existingtutor.FirstName,
                LastName = Existingtutor.LastName,
                Age = Existingtutor.Age,
                Gender = Existingtutor.Gender,
                Institution = Existingtutor.Institution,
                Modules = Existingtutor.Modules,
                Email = Existingtutor.Email,
                Password = Existingtutor.Password,
                Location = Existingtutor.Location,
                TuteesCode = Existingtutor.TuteesCode,
                Bio = "I love testing",
                Connections = Existingtutor.Connections
            };

            var tutor = MockPutTutor(ExistingtutorID, tutorToUpdate);
            // Assert
            bool status = tutor.Bio == "I love testing";
            Assert.NotNull(tutor);
            Assert.True(status);
        return Task.CompletedTask;
    }

    [Fact]
    public async Task PostTutor_and_returns_a_type_of_Action_Result_returns_null()
    {
         
        //Arranage
        var expectedTutor = createTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutor));
        var controller = new TutorsController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.PostTutor(expectedTutor);
        // Assert
        Assert.IsType<ActionResult<Api.Models.Tutor>>(result);
      
    }
    [Fact]
     public async Task PostTutor_and_returns_a_type_of_Action()
    {
         
        //Arranage
        var expectedTutor = createTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutor)null);
        var controller = new TutorsController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.PostTutor(expectedTutor);
        // Assert
       // Assert.IsType<ActionResult<Api.Models.Tutor>>(result);
       Assert.Null(result.Value);
    }
    // Mock the DeleteTutor method  and return a null value 
    [Fact]  
    public async Task DeleteTutor_and_returns_a_type_of_NotFoundResult()
    {
         
        //Arranage
        var expectedTutor = createTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync((Tutor)null);
        var controller = new TutorsController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.DeleteTutor(expectedTutor.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
     // Mock the DeleteTutor method  and return a Value 
    [Fact]
    public async Task DeleteTutor_and_returns_a_type_of_NoContentResult()
    {
         
        //Arranage
        var expectedTutor = createTutor();

        var repositoryStub = new Mock<TutorMeContext>();
        repositoryStub.Setup(repo => repo.Tutors.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedTutor);
        var controller = new TutorsController(repositoryStub.Object);
        
        //Act
        
        var result = await controller.DeleteTutor(expectedTutor.Id);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
     private bool MOckTutorExists(Guid id)
    {
        return (_expectedTutors?.Any(e => e.Id == id)).GetValueOrDefault();
    }
    [Fact]
    public Task TutorExists_Returns_True()
    {
        //Arranage
        var existingTutor = createTutor();
        _expectedTutors.Add(existingTutor);
        
        //Act
        bool status= MOckTutorExists(existingTutor.Id);

        // Assert
        Assert.True(status);
        return Task.CompletedTask;
    }

    [Fact]
    public void TutorExists_Returns_False()
    {
        //Arranage
        var UnexistingTutor = createTutor();
        // _expectedTutors.Add(existingTutor);

        //Act
        bool status = MOckTutorExists(UnexistingTutor.Id);

        // Assert
        Assert.False((status));
    }
      [Fact]
    public Task GetTutorByEmail_returns_the_correct_tutor()
    {
        //Arranage
        var emailOftutor = _expectedTutors[0].Email;
        var expectedTutor = _expectedTutors[0];

        //Act
        var result = MoqGetTutorByEmail(emailOftutor);
    
        //Assert     
        result.Should().BeEquivalentTo(expectedTutor,
            //Verifying all the DTO variables matches the expected Tutor 
            options => options.ComparingByMembers<Tutor>());
        return Task.CompletedTask;
    }

    [Fact]
    public Task GetTutorByEmail_returns_not_found ()
    {
        //Arranage
        var Unexsisting_emailOftutor = "u19027372@tuks.co.za";
        var expectedTutor = _expectedTutors[0];

        //Act
        var result = MoqGetTutorByEmail(Unexsisting_emailOftutor);
        
        //Assert     
        Assert.Null(result);
        return Task.CompletedTask;
    }

    public Tutor? MoqGetTutorByEmail( string email, Guid id = default(Guid)){
        if (_expectedTutors== null)
        {
            return null;
        }

        var tutor = _expectedTutors.Find(e => e.Email == email);
        
        if (tutor == null)
        {

            return null;
        }

        return tutor;
    }
      
    public Tutor? MockPutTutor(Guid id,Tutor tutor)
    {
        
        bool status=false;
        for (int i = 0; i < _expectedTutors.Count; i++)
        {
            if (id == _expectedTutors[i].Id)
            {
                status = true;
            }
        }

        if (status == false)
        {
            return null;// bad request
        }
        
        var tutorToUpdate = new Tutor
        {
            Id = tutor.Id,
            FirstName = tutor.FirstName,
            LastName = tutor.LastName,
            Age = tutor.Age,
            Gender = tutor.Gender,
            Institution = tutor.Institution,
            Modules = tutor.Modules,
            Email = tutor.Email,
            Password = tutor.Password,
            Location = tutor.Location,
            TuteesCode = tutor.TuteesCode,
            Bio = tutor.Bio,
            Connections = tutor.Connections
        };

        return tutorToUpdate;
        
    }

    
  
}

