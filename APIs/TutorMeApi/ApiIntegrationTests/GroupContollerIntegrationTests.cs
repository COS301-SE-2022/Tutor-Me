using System.Net.Http.Json;
using System.Text;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NuGet.Protocol;


namespace IntegrationTests;

public class GroupControllerIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _httpClient;
    
    public GroupControllerIntegrationTests()
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
    public async Task GetAllGroups_NoGroups()
    {
        //Act
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Groups");
    
        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);
    
        var Groups = await response.Content.ReadFromJsonAsync<List<Group>>();// ReadAsAsync<List<Group>>();
    
        Assert.Equal(0, Groups.Count());
    }
    
    [Fact]
    public async Task GetAllGroups_Groups()
    {
        //Arrange
        var testGroup = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Software engineering 301",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
        };
        var testGroup2 = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Computer Networks 332",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
        };
        var testGroup3 = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Computer Security 330",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
    
        };
    
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup3);
    
        //Act
        var response = await _httpClient.GetAsync("http://localhost:7062/api/Groups");
    
        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);
    
        var Groups = await response.Content.ReadFromJsonAsync<List<Group>>();
        Assert.NotNull(Groups);
        Assert.Equal(3, Groups.Count());
    }
    
    [Fact]
    public async Task GetGroupById_NoGroup()
    {
        //Act
        Guid id = Guid.NewGuid();
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Groups/"+id);
    
        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    [Fact]
    public async Task GetGroupById_GroupFound()
    {
        //Arrange
        var testGroup = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Software engineering 301",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
    
        };
        var testGroup2 = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Computer Networks 332",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
        };
        var testGroup3 = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Computer Security 330",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
    
        };
    
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup3);
    
        //Act
        var id = testGroup.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Groups/"+id);
    
        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);
    
        var Group = await response.Content.ReadFromJsonAsync<Group>();
    
        Assert.NotNull(Group);
        if (Group != null)
        {
            Assert.Equal(testGroup.Id, Group.Id);
            Assert.Equal(testGroup.ModuleCode, Group.ModuleCode);
            Assert.Equal(testGroup.ModuleName, Group.ModuleName);
            Assert.Equal(testGroup.Tutees, Group.Tutees);
            Assert.Equal(testGroup.TutorId, Group.TutorId);
            Assert.Equal(testGroup.Description, Group.Description);
            
        }
    }
    
    [Fact]
    public async Task GetGroupById_GroupNotFound() 
    {
        //Arrange
        var testGroup = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Software engineering 301",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
    
        };
        var testGroup2 = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Computer Networks 332",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
        };
        var testGroup3 = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Computer Security 330",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
    
        };
    
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup3);
    
        //Act
        var id = Guid.NewGuid();//Group that does not exist
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Groups/"+id);
        
        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    
    [Fact]
    public async Task ModifiesGroupFromDatabase()
    {
        //Arrange
        var testGroup = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Software engineering 301",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
    
        };
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup);
        
        //Act
        
        //Modify the Groups Description
        testGroup.Description = "Software Engineering stuff only";

        var stringContent =new StringContent(testGroup.ToJson(), Encoding.UTF8, "application/json");
        var response1= await _httpClient.PutAsync("https://localhost:7062/api/Groups/" + testGroup.Id,stringContent );
        //Assert
        Assert.NotNull(response1);
        Assert.Equal(204, (double)response1.StatusCode); 
    
        
        //Now checking if the Description was actually Modified on the database 
        var id = testGroup.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Groups/"+id);
    
        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);
    
        var Group = await response.Content.ReadFromJsonAsync<Group>();
    
        Assert.NotNull(Group);
        if (Group != null)
        {
            Assert.Equal(testGroup.Id, Group.Id);
           
            Assert.Equal("Software Engineering stuff only",Group.Description);
        }
    
    }
    [Fact]
    public async Task AddGroup()
    {
        var testGroup = new Group()
        {
            Id =Guid.NewGuid(),
            ModuleCode =Guid.NewGuid().ToString(),
            ModuleName ="Software engineering 301",
            Tutees =Guid.NewGuid().ToString(),
            TutorId =Guid.NewGuid().ToString(),
            Description="Software Engineers",
    
        };
    
        //Act
        var id = testGroup.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Groups", testGroup);
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Groups/"+id);
    
        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);
    
        var Group = await response.Content.ReadFromJsonAsync<Group>();
    
        Assert.NotNull(Group);
        if (Group != null)
        {
            Assert.Equal(testGroup.Id, Group.Id);
            Assert.Equal(testGroup.ModuleCode, Group.ModuleCode);
            Assert.Equal(testGroup.ModuleName, Group.ModuleName);
            Assert.Equal(testGroup.Tutees, Group.Tutees);
            Assert.Equal(testGroup.TutorId, Group.TutorId);
            Assert.Equal(testGroup.Description, Group.Description);
        }
    }

}