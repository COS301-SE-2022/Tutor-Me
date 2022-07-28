using System.Net.Http.Json;
using System.Text;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NuGet.Protocol;


namespace IntegrationTests;

public class TutorControllerIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _httpClient;
   
    public TutorControllerIntegrationTests()
    {
        var dbname = Guid.NewGuid().ToString();
        var appFactory = new WebApplicationFactory<Program>()
            .WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(
                    services =>
                    {
                        var descriptor = services.SingleOrDefault(
                            d => d.ServiceType == typeof(DbContextOptions<TutorMeContext>));

                        if (descriptor != null)
                        {
                            services.Remove(descriptor);
                        }
                        services.AddDbContext<TutorMeContext>(
                            options =>
                            {
                                options.UseInMemoryDatabase(dbname);
                            });
                    });
            });

        _httpClient = appFactory.CreateClient();
    }
    
    [Fact]
    public async Task GetAllTutors_NoTutors()
    {
        //Act
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var tutors = await response.Content.ReadFromJsonAsync<List<Tutor>>();// ReadAsAsync<List<Tutor>>();

        Assert.Equal(0, tutors.Count());
    }
    
    [Fact]
    public async Task GetAllTutors_Tutors()
    {
        //Arrange
        var testTutor = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Simphiwe",
            LastName = "Ndlovu",
            DateOfBirth = "26 April 1999",
            Gender = "M",
            Status = "T",
            Faculty =  "No faculty added",
            Course = "Bsc Computer Science",
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u19027372@tuks.co.za",
            Password = "12345678",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "No connections added",
            Rating = "0,0",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        var testTutor2 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Musa",
            LastName = "Mabasa",
            DateOfBirth = "14 August 2000",
            Gender = "M",
            Status = Guid.NewGuid().ToString(),
            Faculty = "No faculty added",
            Course = Guid.NewGuid().ToString(),
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u12345678@tuks.co.za",
            Password = "2468101214",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "Stranger things fan",
            Connections = "1",
            Rating = "0.5",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="No Groups"

        };
        var testTutor3 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Farai",
            LastName = "Chivunga",
            DateOfBirth = "30 March 2001",
            Gender = "M",
            Status = "T",
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
            Year= Guid.NewGuid().ToString(),
            GroupIds=Guid.NewGuid().ToString()

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor3);

        //Act
        var response = await _httpClient.GetAsync("http://localhost:7062/api/Tutors");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var tutors = await response.Content.ReadFromJsonAsync<List<Tutor>>();
        Assert.NotNull(tutors);
        Assert.Equal(3, tutors.Count());
    }
    
    [Fact]
    public async Task GetTutorById_NoTutor()
    {
        //Act
        Guid id = Guid.NewGuid();
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    [Fact]
    public async Task GetTutorById_TutorFound()
    { 
        //Arrange
       var testTutor = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Simphiwe",
            LastName = "Ndlovu",
            DateOfBirth = "26 April 1999",
            Gender = "M",
            Status = "T",
            Faculty =  "No faculty added",
            Course = "Bsc Computer Science",
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u19027372@tuks.co.za",
            Password = "12345678",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "No connections added",
            Rating = "0,0",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        var testTutor2 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Musa",
            LastName = "Mabasa",
            DateOfBirth = "14 August 2000",
            Gender = "M",
            Status = Guid.NewGuid().ToString(),
            Faculty = "No faculty added",
            Course = Guid.NewGuid().ToString(),
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u12345678@tuks.co.za",
            Password = "2468101214",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "Stranger things fan",
            Connections = "1",
            Rating = "0.5",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="No Groups"

        };
        var testTutor3 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Farai",
            LastName = "Chivunga",
            DateOfBirth = "30 March 2001",
            Gender = "M",
            Status = "T",
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
            Year= Guid.NewGuid().ToString(),
            GroupIds=Guid.NewGuid().ToString()

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor3);

        //Act
        var id = testTutor.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var tutor = await response.Content.ReadFromJsonAsync<Tutor>();

        Assert.NotNull(tutor);
        if (tutor != null)
        {
            Assert.Equal(testTutor.Id, tutor.Id);
            Assert.Equal(testTutor.FirstName, tutor.FirstName);
            Assert.Equal(testTutor.LastName, tutor.LastName);
            Assert.Equal(testTutor.DateOfBirth, tutor.DateOfBirth);
            Assert.Equal(testTutor.Gender, tutor.Gender);
            Assert.Equal(testTutor.Status, tutor.Status);
            Assert.Equal(testTutor.Faculty, tutor.Faculty);
            Assert.Equal(testTutor.Course, tutor.Course);
            Assert.Equal(testTutor.Institution, tutor.Institution);
            Assert.Equal(testTutor.Modules, tutor.Modules);
            Assert.Equal(testTutor.Email, tutor.Email);
            Assert.Equal(testTutor.Password, tutor.Password);
            Assert.Equal(testTutor.Location, tutor.Location);
            Assert.Equal(testTutor.TuteesCode, tutor.TuteesCode);
            Assert.Equal(testTutor.Bio, tutor.Bio);
            Assert.Equal(testTutor.Connections, tutor.Connections);
            Assert.Equal(testTutor.Rating, tutor.Rating);
            Assert.Equal(testTutor.Requests, tutor.Requests);
            Assert.Equal(testTutor.Year, tutor.Year);
            Assert.Equal(testTutor.Year, tutor.Year);
            Assert.Equal(testTutor.GroupIds, tutor.GroupIds);
            
        }
    }
    
    [Fact]
    public async Task GetTutorById_TutorNotFound() 
    {
        //Arrange
       var testTutor = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Simphiwe",
            LastName = "Ndlovu",
            DateOfBirth = "26 April 1999",
            Gender = "M",
            Status = "T",
            Faculty =  "No faculty added",
            Course = "Bsc Computer Science",
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u19027372@tuks.co.za",
            Password = "12345678",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "No connections added",
            Rating = "0,0",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        var testTutor2 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Musa",
            LastName = "Mabasa",
            DateOfBirth = "14 August 2000",
            Gender = "M",
            Status = Guid.NewGuid().ToString(),
            Faculty = "No faculty added",
            Course = Guid.NewGuid().ToString(),
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u12345678@tuks.co.za",
            Password = "2468101214",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "Stranger things fan",
            Connections = "1",
            Rating = "0.5",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="No Groups"

        };
        var testTutor3 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Farai",
            LastName = "Chivunga",
            DateOfBirth = "30 March 2001",
            Gender = "M",
            Status = "T",
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
            Year= Guid.NewGuid().ToString(),
            GroupIds=Guid.NewGuid().ToString()

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor3);

        //Act
        var id = Guid.NewGuid();//Tutor that does not exist
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/"+id);
        
        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    [Fact]
    public async Task GetTutorByEmail_NoTutor()
    {
        //Act
        Guid id = Guid.NewGuid();
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/email/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    
       [Fact]
    public async Task GetTutorByEmail_TutorFound()
    {
        //Arrange
       var testTutor = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Simphiwe",
            LastName = "Ndlovu",
            DateOfBirth = "26 April 1999",
            Gender = "M",
            Status = "T",
            Faculty =  "No faculty added",
            Course = "Bsc Computer Science",
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u19027372@tuks.co.za",
            Password = "12345678",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "No connections added",
            Rating = "0,0",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        var testTutor2 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Musa",
            LastName = "Mabasa",
            DateOfBirth = "14 August 2000",
            Gender = "M",
            Status = Guid.NewGuid().ToString(),
            Faculty = "No faculty added",
            Course = Guid.NewGuid().ToString(),
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u12345678@tuks.co.za",
            Password = "2468101214",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "Stranger things fan",
            Connections = "1",
            Rating = "0.5",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="No Groups"

        };
        var testTutor3 = new Tutor()
        {

            Id = Guid.NewGuid(),
            FirstName = "Farai",
            LastName = "Chivunga",
            DateOfBirth = "30 March 2001",
            Gender = "M",
            Status = "T",
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
            Year= Guid.NewGuid().ToString(),
            GroupIds=Guid.NewGuid().ToString()

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor3);

        //Act
        var testEmail = testTutor.Email;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/email/"+testEmail);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var tutor = await response.Content.ReadFromJsonAsync<Tutor>();

        Assert.NotNull(tutor);
        if (tutor != null)
        {
            Assert.Equal(testTutor.Id, tutor.Id);
            Assert.Equal(testTutor.FirstName, tutor.FirstName);
            Assert.Equal(testTutor.LastName, tutor.LastName);
            Assert.Equal(testTutor.DateOfBirth, tutor.DateOfBirth);
            Assert.Equal(testTutor.Gender, tutor.Gender);
            Assert.Equal(testTutor.Status, tutor.Status);
            Assert.Equal(testTutor.Faculty, tutor.Faculty);
            Assert.Equal(testTutor.Course, tutor.Course);
            Assert.Equal(testTutor.Institution, tutor.Institution);
            Assert.Equal(testTutor.Modules, tutor.Modules);
            Assert.Equal(testTutor.Email, tutor.Email);
            Assert.Equal(testTutor.Password, tutor.Password);
            Assert.Equal(testTutor.Location, tutor.Location);
            Assert.Equal(testTutor.TuteesCode, tutor.TuteesCode);
            Assert.Equal(testTutor.Bio, tutor.Bio);
            Assert.Equal(testTutor.Connections, tutor.Connections);
            Assert.Equal(testTutor.Rating, tutor.Rating);
            Assert.Equal(testTutor.Requests, tutor.Requests);
            Assert.Equal(testTutor.Year, tutor.Year);
            Assert.Equal(testTutor.Year, tutor.Year);
            Assert.Equal(testTutor.GroupIds, tutor.GroupIds);
            
        }
    }
      [Fact]
    public async Task ModifiesTutorFromDatabase()
    {
        //Arrange
        var testTutor = new Tutor()
        {
            Id = Guid.NewGuid(),
            FirstName = "Simphiwe",
            LastName = "Ndlovu",
            DateOfBirth = "26 April 1999",
            Gender = "M",
            Status = "T",
            Faculty =  "No faculty added",
            Course = "Bsc Computer Science",
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u19027372@tuks.co.za",
            Password = "12345678",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "No connections added",
            Rating = "0,0",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"


        };
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor);
        
        //Act
        
        //Modify the Tutees Bio
        testTutor.Bio = "Naruto fan";
        testTutor.FirstName = "Thabo";
        
        var stringContent =new StringContent(testTutor.ToJson(), Encoding.UTF8, "application/json");
        var response1= await _httpClient.PutAsync("https://localhost:7062/api/Tutors/" + testTutor.Id,stringContent );
        //Assert
        Assert.NotNull(response1);
        Assert.Equal(204, (double)response1.StatusCode); 

        
        //Now checking if the Bio was actually Modified on the database 
        var id = testTutor.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var tutee = await response.Content.ReadFromJsonAsync<Tutee>();

        Assert.NotNull(tutee);
        if (tutee != null)
        {
            Assert.Equal(testTutor.Id, tutee.Id);
            Assert.Equal(testTutor.FirstName, tutee.FirstName);
            Assert.Equal("Naruto fan",tutee.Bio);
        }

    }
    [Fact]
    public async Task AddTutor()
    {
        var testTutor = new Tutor()
        {
            Id = Guid.NewGuid(),
            FirstName = "Simphiwe",
            LastName = "Ndlovu",
            DateOfBirth = "26 April 1999",
            Gender = "M",
            Status = "T",
            Faculty =  "No faculty added",
            Course = "Bsc Computer Science",
            Institution = "University Of Pretoria",
            Modules =Guid.NewGuid().ToString(),
            Email = "u19027372@tuks.co.za",
            Password = "12345678",
            Location = Guid.NewGuid().ToString(),
            TuteesCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "No connections added",
            Rating = "0,0",
            Requests =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"
        };

        //Act
        var id = testTutor.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor);
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var tutor = await response.Content.ReadFromJsonAsync<Tutor>();

        Assert.NotNull(tutor);
        if (tutor != null)
        {
            Assert.Equal(testTutor.Id, tutor.Id);
            Assert.Equal(testTutor.FirstName, tutor.FirstName);
            Assert.Equal(testTutor.LastName, tutor.LastName);
            Assert.Equal(testTutor.DateOfBirth, tutor.DateOfBirth);
            Assert.Equal(testTutor.Gender, tutor.Gender);
            Assert.Equal(testTutor.Status, tutor.Status);
            Assert.Equal(testTutor.Faculty, tutor.Faculty);
            Assert.Equal(testTutor.Course, tutor.Course);
            Assert.Equal(testTutor.Institution, tutor.Institution);
            Assert.Equal(testTutor.Modules, tutor.Modules);
            Assert.Equal(testTutor.Email, tutor.Email);
            Assert.Equal(testTutor.Password, tutor.Password);
            Assert.Equal(testTutor.Location, tutor.Location);
            Assert.Equal(testTutor.TuteesCode, tutor.TuteesCode);
            Assert.Equal(testTutor.Bio, tutor.Bio);
            Assert.Equal(testTutor.Connections, tutor.Connections);
            Assert.Equal(testTutor.Rating, tutor.Rating);
            Assert.Equal(testTutor.Requests, tutor.Requests);
            Assert.Equal(testTutor.Year, tutor.Year);
            Assert.Equal(testTutor.Year, tutor.Year);
            Assert.Equal(testTutor.GroupIds, tutor.GroupIds);
            
        }
    }
    

}