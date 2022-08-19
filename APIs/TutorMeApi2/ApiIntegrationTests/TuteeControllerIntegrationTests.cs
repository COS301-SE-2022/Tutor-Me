using System.Net.Http.Json;
using System.Text;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NuGet.Protocol;


namespace IntegrationTests;

public class TuteeControllerIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _httpClient;
   
    public TuteeControllerIntegrationTests()
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
    public async Task GetAllTutees_NoTutees()
    {
        //Act
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutees");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var Tutees = await response.Content.ReadFromJsonAsync<List<Tutee>>();// ReadAsAsync<List<Tutee>>();

        Assert.Equal(0, Tutees.Count());
    }
    
    [Fact]
    public async Task GetAllTutees_Tutees()
    {
        //Arrange
        var testTutee = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        var testTutee2 = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "Stranger things fan",
            Connections = "1",
            Year= "3",
            GroupIds="no groups"

        };
        var testTutee3 = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "2",
            Year= "3",
            GroupIds="no groups"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee3);

        //Act
        var response = await _httpClient.GetAsync("http://localhost:7062/api/Tutees");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var Tutees = await response.Content.ReadFromJsonAsync<List<Tutee>>();
        Assert.NotNull(Tutees);
        Assert.Equal(3, Tutees.Count());
    }
    
    [Fact]
    public async Task GetTuteeById_NoTutee()
    {
        //Act
        Guid id = Guid.NewGuid();
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutees/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    [Fact]
    public async Task GetTuteeById_TuteeFound()
    {
        //Arrange
        var testTutee = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        var testTutee2 = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "Stranger things fan",
            Connections = "1",
            Year= "3",
            GroupIds="no groups"

        };
        var testTutee3 = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "2",
            Year= "3",
            GroupIds="no groups"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee3);

        //Act
        var id = testTutee.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutees/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var Tutee = await response.Content.ReadFromJsonAsync<Tutee>();

        Assert.NotNull(Tutee);
        if (Tutee != null)
        {
            Assert.Equal(testTutee.Id, Tutee.Id);
            Assert.Equal(testTutee.FirstName, Tutee.FirstName);
            Assert.Equal(testTutee.LastName, Tutee.LastName);
            Assert.Equal(testTutee.DateOfBirth, Tutee.DateOfBirth);
            Assert.Equal(testTutee.Gender, Tutee.Gender);
            Assert.Equal(testTutee.Status, Tutee.Status);
            Assert.Equal(testTutee.Faculty, Tutee.Faculty);
            Assert.Equal(testTutee.Course, Tutee.Course);
            Assert.Equal(testTutee.Institution, Tutee.Institution);
            Assert.Equal(testTutee.Modules, Tutee.Modules);
            Assert.Equal(testTutee.Email, Tutee.Email);
            Assert.Equal(testTutee.Password, Tutee.Password);
            Assert.Equal(testTutee.Location, Tutee.Location);
            Assert.Equal(testTutee.TutorsCode, Tutee.TutorsCode);
            Assert.Equal(testTutee.Bio, Tutee.Bio);
            Assert.Equal(testTutee.Connections, Tutee.Connections);
            Assert.Equal(testTutee.Year, Tutee.Year);
            Assert.Equal(testTutee.GroupIds, Tutee.GroupIds);
        }
    }
    
    [Fact]
    public async Task GetTuteeById_TuteeNotFound() 
    {
        //Arrange
       var testTutee = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        var testTutee2 = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "Stranger things fan",
            Connections = "1",
            Year= "3",
            GroupIds="no groups"

        };
        var testTutee3 = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections = "2",
            Year= "3",
            GroupIds="no groups"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee3);

        //Act
        var id = Guid.NewGuid();//Tutee that does not exist
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutees/"+id);
        
        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    
    [Fact]
    public async Task ModifiesTuteeFromDatabase()
    {
        //Arrange
        var testTutee = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"

        };
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee);
        
        //Act
        
        //Modify the Tutees Bio
        testTutee.Bio = "Naruto fan";
        testTutee.FirstName = "Thabo";
        
        var stringContent =new StringContent(testTutee.ToJson(), Encoding.UTF8, "application/json");
        var response1= await _httpClient.PutAsync("https://localhost:7062/api/Tutees/" + testTutee.Id,stringContent );
        //Assert
        Assert.NotNull(response1);
        Assert.Equal(204, (double)response1.StatusCode); 

        
        //Now checking if the Bio was actually Modified on the database 
        var id = testTutee.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutees/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var tutee = await response.Content.ReadFromJsonAsync<Tutee>();

        Assert.NotNull(tutee);
        if (tutee != null)
        {
            Assert.Equal(testTutee.Id, tutee.Id);
            Assert.Equal(testTutee.FirstName, tutee.FirstName);
            Assert.Equal("Naruto fan",tutee.Bio);
        }

    }
    [Fact]
    public async Task AddTutee()
    {
        var testTutee = new Tutee()
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
            TutorsCode = Guid.NewGuid().ToString(),
            Bio = "OnePiece fan",
            Connections =Guid.NewGuid().ToString(),
            Year= "3",
            GroupIds="no groups"
        };

        //Act
        var id = testTutee.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee);
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Tutees/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var Tutee = await response.Content.ReadFromJsonAsync<Tutee>();

        Assert.NotNull(Tutee);
        if (Tutee != null)
        {
            Assert.Equal(testTutee.Id, Tutee.Id);
            Assert.Equal(testTutee.FirstName, Tutee.FirstName);
            Assert.Equal(testTutee.LastName, Tutee.LastName);
            Assert.Equal(testTutee.DateOfBirth, Tutee.DateOfBirth);
            Assert.Equal(testTutee.Gender, Tutee.Gender);
            Assert.Equal(testTutee.Status, Tutee.Status);
            Assert.Equal(testTutee.Faculty, Tutee.Faculty);
            Assert.Equal(testTutee.Course, Tutee.Course);
            Assert.Equal(testTutee.Institution, Tutee.Institution);
            Assert.Equal(testTutee.Modules, Tutee.Modules);
            Assert.Equal(testTutee.Email, Tutee.Email);
            Assert.Equal(testTutee.Password, Tutee.Password);
            Assert.Equal(testTutee.Location, Tutee.Location);
            Assert.Equal(testTutee.TutorsCode, Tutee.TutorsCode);
            Assert.Equal(testTutee.Bio, Tutee.Bio);
            Assert.Equal(testTutee.Connections, Tutee.Connections);
            Assert.Equal(testTutee.Year, Tutee.Year);
            Assert.Equal(testTutee.GroupIds, Tutee.GroupIds);
            
        }
    }

}
