using System.Net.Http.Json;
using System.Text;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NuGet.Protocol;


namespace IntegrationTests;

public class RequestControllerIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _httpClient;
   
    public RequestControllerIntegrationTests()
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
    //Accepting a request process
    [Fact]
    public async Task Accepting_a_request()
    {
        //Act 
        
        //Create a tutor and a tutee and a Module
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
        
        var testModule = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "Software engineering cos 301",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };
        
        //Add tutor to the InMemoryDatabase
        var tutorId = testTutor.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutors", testTutor);
        var tutorResponse = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/"+tutorId);
        Assert.NotNull(tutorResponse);
        Assert.Equal(200, (double)tutorResponse.StatusCode);
        
        //Add tutee to the InMemoryDatabase
        var tuteeId = testTutee.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee);
        var tuteeResponse = await _httpClient.GetAsync("https://localhost:7062/api/Tutees/"+tuteeId);
        Assert.NotNull(tuteeResponse);
        Assert.Equal(200, (double)tuteeResponse.StatusCode);
        
        //Add Module to the InMemoryDatabase    
        var moduleId = testModule.Code;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule);
        var moduleResponse = await _httpClient.GetAsync("https://localhost:7062/api/Modules/"+moduleId);
        Assert.NotNull(moduleResponse);
        Assert.Equal(200, (double)moduleResponse.StatusCode);
        
        //Add module (Software engineering cos 301) to the tutor
        testTutor.Modules = testModule.Code;
        // Updating Tutor
        var updateTutorStringContent =new StringContent(testTutor.ToJson(), Encoding.UTF8, "application/json");
        var updateTutorResponse1= await _httpClient.PutAsync("https://localhost:7062/api/Tutors/" + testTutor.Id,updateTutorStringContent );
        Assert.NotNull(updateTutorResponse1);
        Assert.Equal(204, (double)updateTutorResponse1.StatusCode); 
        
        
        
        //Request for a specific tutor ( tutee request for a tutor)  ## Tutee side
        var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =tuteeId.ToString(),
            ReceiverId =tutorId.ToString(),
            DateCreated ="29/07/2022",
            ModuleCode =testModule.Code
        };
        var requestId = testRequest.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        var requestResponse = await _httpClient.GetAsync("https://localhost:7062/api/Requests/"+requestId);
        Assert.NotNull(requestResponse);
        Assert.Equal(200, (double)requestResponse.StatusCode);
        
        
        // Accept by  adding connections on both tutor and tutee side
        
        //GetRequestsByTutorId  (Get the reuest)  ## Tutor side
        var response = await _httpClient.GetAsync("http://localhost:7062/api/Requests/Tutor/"+testTutor.Id);
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);
        var request = await response.Content.ReadFromJsonAsync<List<Request>>();
        Assert.NotNull(request);
        Assert.Equal(1, request.Count());
        
        //Find a request for a specific tutor
        Assert.Equal(request[0].ReceiverId,testTutor.Id.ToString());
        
        
        //Now adding connections on both sides by updating the (Tutor and Tutee )
        
        // Updating Tutor
        testTutor.TuteesCode = testTutee.Id.ToString();
        var updateTutorStringContent2 =new StringContent(testTutor.ToJson(), Encoding.UTF8, "application/json");
        var updateTutorResponse2= await _httpClient.PutAsync("https://localhost:7062/api/Tutors/" + testTutor.Id,updateTutorStringContent2 );
        Assert.NotNull(updateTutorResponse2);
        Assert.Equal(204, (double)updateTutorResponse2.StatusCode); 
        
        // Updating Tutee
        testTutee.TutorsCode = testTutor.Id.ToString();
        var updateStringContent =new StringContent(testTutee.ToJson(), Encoding.UTF8, "application/json");
        var updateResponse1= await _httpClient.PutAsync("https://localhost:7062/api/Tutees/" + testTutee.Id,updateStringContent );
        Assert.NotNull(updateResponse1);
        Assert.Equal(204, (double)updateResponse1.StatusCode); 
        
        
        //Checking if tutor and tutee are connected
        var id =testTutor.Id;
        
        var checkConnectionResponse = await _httpClient.GetAsync("https://localhost:7062/api/Tutors/"+id);
        Assert.NotNull(checkConnectionResponse);
        Assert.Equal(200, (double)checkConnectionResponse.StatusCode);
        var tutor = await checkConnectionResponse.Content.ReadFromJsonAsync<Tutor>();
        Assert.NotNull(tutor);
        if (tutor != null)
        {
            Assert.Equal(testTutee.Id.ToString(), tutor.TuteesCode);
        }
        
        
        var tuteeId1 = testTutee.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Tutees", testTutee);
        var updateTuteeResponse = await _httpClient.GetAsync("https://localhost:7062/api/Tutees/"+tuteeId1);
        Assert.NotNull(updateTuteeResponse);
        Assert.Equal(200, (double)updateTuteeResponse.StatusCode);

        var Tutee = await updateTuteeResponse.Content.ReadFromJsonAsync<Tutee>();

        Assert.NotNull(Tutee);
        if (Tutee != null)
        { Assert.Equal(testTutor.Id.ToString(), Tutee.TutorsCode);
        }

        
    }
    

    [Fact]
    public async Task GetAllRequests_NoRequests()
    {
        //Act
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Requests");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var requests = await response.Content.ReadFromJsonAsync<List<Request>>();

        Assert.Equal(0, requests.Count());
    }
    
    [Fact]
    public async Task GetAllRequests_Requests()
    {
        //Arrange
        var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            ModuleCode =Guid.NewGuid().ToString()

        };
        var testRequest2 = new Request()
        {

            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="25 April 2020",
            ModuleCode =Guid.NewGuid().ToString()

        };
        var testRequest3 = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="30 April 2022",
            ModuleCode =Guid.NewGuid().ToString()

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest3);

        //Act
        var response = await _httpClient.GetAsync("http://localhost:7062/api/Requests");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var requests = await response.Content.ReadFromJsonAsync<List<Request>>();
        Assert.NotNull(requests);
        Assert.Equal(3, requests.Count());
    }
    
    [Fact]
    public async Task GetRequestById_NoRequest()
    {
        //Act
        Guid id = Guid.NewGuid();
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Requests/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    [Fact]
    public async Task GetRequestById_RequestFound()
    {
        //Arrange
        var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            ModuleCode =Guid.NewGuid().ToString()

        };
        var testRequest2 = new Request()
        {

            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="25 April 2020",
            ModuleCode =Guid.NewGuid().ToString()

        };
        var testRequest3 = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="30 April 2022",
            ModuleCode =Guid.NewGuid().ToString()

        };
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest3);

        //Act
        var id = testRequest.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Requests/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var request = await response.Content.ReadFromJsonAsync<Request>();

        Assert.NotNull(request);
        if (request != null)
        {
            Assert.Equal(testRequest.Id, request.Id);
            Assert.Equal(testRequest.ReceiverId, request.ReceiverId);
            Assert.Equal(testRequest.RequesterId, request.RequesterId);
            Assert.Equal(testRequest.DateCreated, request.DateCreated);
            Assert.Equal(testRequest.ModuleCode, request.ModuleCode);
           
        }
    }
    
    [Fact]
    public async Task GetRequestById_RequestNotFound() 
    {
        //Arrange
        var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            ModuleCode =Guid.NewGuid().ToString()

        };
        var testRequest2 = new Request()
        {

            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="25 April 2020",
            ModuleCode =Guid.NewGuid().ToString()

        };
        var testRequest3 = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="30 April 2022",
            ModuleCode =Guid.NewGuid().ToString()

        };
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest3);

        //Act
        var id = Guid.NewGuid();//Request that does not exist
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Requests/"+id);
        
        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    
    [Fact]
    public async Task ModifiesRequestFromDatabase()
    {
        //Arrange
        var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            ModuleCode =Guid.NewGuid().ToString()

        };
      
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        
        //Act
        
        //Modify the Requests Date
        testRequest.DateCreated = "28 April 2020";

        var stringContent =new StringContent(testRequest.ToJson(), Encoding.UTF8, "application/json");
        var response1= await _httpClient.PutAsync("https://localhost:7062/api/Requests/" + testRequest.Id,stringContent );
        //Assert
        Assert.NotNull(response1);
        Assert.Equal(204, (double)response1.StatusCode); 

        
        //Now checking if the Date was actually Modified on the database 
        var id = testRequest.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Requests/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var request = await response.Content.ReadFromJsonAsync<Request>();

        Assert.NotNull(request);
        if (request != null)
        {
            Assert.Equal(testRequest.Id, request.Id);
            Assert.Equal(testRequest.DateCreated, request.DateCreated);
      
        }

    }

    [Fact]
    public async Task GetTutorsRequestById()
    { var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            ModuleCode =Guid.NewGuid().ToString()

        };

        //Act
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        
        var getTutorRequest = await _httpClient.GetAsync("https://localhost:7062/api/Requests/Tutor/"+testRequest.ReceiverId);
        Assert.NotNull(getTutorRequest);
        Assert.Equal(200, (double)getTutorRequest.StatusCode);
        
        var requests11 = await getTutorRequest.Content.ReadFromJsonAsync<List<Request>>();
        Assert.NotNull(requests11);
        Assert.Equal(1,requests11.Count);
    
    
    }
    [Fact]
    public async Task GetTuteesRequestById()
    { var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            ModuleCode =Guid.NewGuid().ToString()

        };

        //Act
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        
        var getTutorRequest = await _httpClient.GetAsync("https://localhost:7062/api/Requests/Tutee/"+testRequest.RequesterId);
        Assert.NotNull(getTutorRequest);
        Assert.Equal(200, (double)getTutorRequest.StatusCode);
        
        var requests11 = await getTutorRequest.Content.ReadFromJsonAsync<List<Request>>();
        Assert.NotNull(requests11);
        Assert.Equal(1,requests11.Count);
    
    
    }
    [Fact]
    public async Task AddRequest()
    {
        var testRequest = new Request()
        {
            Id =Guid.NewGuid(),
            RequesterId =Guid.NewGuid().ToString(),
            ReceiverId =Guid.NewGuid().ToString(),
            DateCreated ="26 April 1999",
            ModuleCode =Guid.NewGuid().ToString()

        };

        //Act
        var id = testRequest.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Requests", testRequest);
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Requests/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var request = await response.Content.ReadFromJsonAsync<Request>();

        Assert.NotNull(request);
        if (request != null)
        {
            Assert.Equal(testRequest.Id, request.Id);
            Assert.Equal(testRequest.ReceiverId, request.ReceiverId);
            Assert.Equal(testRequest.RequesterId, request.RequesterId);
            Assert.Equal(testRequest.DateCreated, request.DateCreated);
            Assert.Equal(testRequest.ModuleCode, request.ModuleCode);
            
        }
    }
    

}
