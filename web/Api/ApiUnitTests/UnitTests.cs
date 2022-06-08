using Api.Controllers;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;

namespace ApiUnitTests;

using FluentAssertions;
using Moq;
public class UnitTests
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
            Age = Guid.NewGuid().ToString(),
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
        public async Task PutTutor_Update_with_an_Existing_Tutor_Returnns_tutorObject()
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
            Assert.True((status));
        }
   
    //Mock the PutTutor method
       public Tutor MockPutTutor(Guid id,Tutor tutor)
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
   
        bool checkEmail = false;
        
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

