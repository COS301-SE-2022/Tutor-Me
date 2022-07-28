using System.Net.Http.Json;
using System.Text;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NuGet.Protocol;


namespace IntegrationTests;

public class AdminIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _httpClient;
   
    public AdminIntegrationTests()
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
    public async Task GetAllAdmins_NoAdmins()
    {
        //Act
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Admins");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var admins = await response.Content.ReadFromJsonAsync<List<Admin>>();

        Assert.Equal(0, admins.Count());
    }
    
    [Fact]
    public async Task GetAllAdmins_Admins()
    {
        //Arrange
        var testAdmin = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Farai",
            Email ="FaraiChivunga@gmail.com",
            Password ="12345@adminFarai"

        };
        var testAdmin2 = new Admin()
        {

            Id =Guid.NewGuid(),
            Name ="Musa",
            Email ="MusaMabasa@gmail.com",
            Password ="12345@adminMusa"

        };
        var testAdmin3 = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Simphiwe",
            Email ="SimphiweNdlvou@gmail.com",
            Password ="12345@adminSimphiwe"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin3);

        //Act
        var response = await _httpClient.GetAsync("http://localhost:7062/api/Admins");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var admins = await response.Content.ReadFromJsonAsync<List<Admin>>();
        Assert.NotNull(admins);
        Assert.Equal(3, admins.Count());
    }
    
    [Fact]
    public async Task GetAdminById_NoAdmin()
    {
        //Act
        Guid id = Guid.NewGuid();
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Admins/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    [Fact]
    public async Task GetAdminById_AdminFound()
    {
        //Arrange
        var testAdmin = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Farai",
            Email ="FaraiChivunga@gmail.com",
            Password ="12345@adminFarai"

        };
        var testAdmin2 = new Admin()
        {

            Id =Guid.NewGuid(),
            Name ="Musa",
            Email ="MusaMabasa@gmail.com",
            Password ="12345@adminMusa"

        };
        var testAdmin3 = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Simphiwe",
            Email ="SimphiweNdlvou@gmail.com",
            Password ="12345@adminSimphiwe"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin3);

        //Act
        var id = testAdmin.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Admins/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var admin = await response.Content.ReadFromJsonAsync<Admin>();

        Assert.NotNull(admin);
        if (admin != null)
        {
            Assert.Equal(testAdmin.Id, admin.Id);
            Assert.Equal(testAdmin.Name, admin.Name);
            Assert.Equal(testAdmin.Email, admin.Email);
            Assert.Equal(testAdmin.Password, admin.Password);
        }
    }
    
    [Fact]
    public async Task GetAdminById_AdminNotFound() 
    {
        //Arrange
        var testAdmin = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Farai",
            Email ="FaraiChivunga@gmail.com",
            Password ="12345@adminFarai"

        };
        var testAdmin2 = new Admin()
        {

            Id =Guid.NewGuid(),
            Name ="Musa",
            Email ="MusaMabasa@gmail.com",
            Password ="12345@adminMusa"

        };
        var testAdmin3 = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Simphiwe",
            Email ="SimphiweNdlvou@gmail.com",
            Password ="12345@adminSimphiwe"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin3);

        //Act
        var id = Guid.NewGuid();//Admin that does not exist
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Admins/"+id);
        
        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    
    [Fact]
    public async Task ModifiesAdminFromDatabase()
    {
        //Arrange
        var testAdmin = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Farai",
            Email ="FaraiChivunga@gmail.com",
            Password ="12345@adminFarai"

        };
      
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin);
        
        //Act
        
        //Modify the Admins Name and email
        testAdmin.Name = "Kuda";
        testAdmin.Email = "kudaChivunga@gmail.com";

        var stringContent =new StringContent(testAdmin.ToJson(), Encoding.UTF8, "application/json");
        var response1= await _httpClient.PutAsync("https://localhost:7062/api/Admins/" + testAdmin.Id,stringContent );
        //Assert
        Assert.NotNull(response1);
        Assert.Equal(204, (double)response1.StatusCode); 

        
        //Now checking if the Name and email was actually Modified on the database 
        var id = testAdmin.Id;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Admins/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var admin = await response.Content.ReadFromJsonAsync<Admin>();

        Assert.NotNull(admin);
        if (admin != null)
        {
            Assert.Equal(testAdmin.Id, admin.Id);
            Assert.Equal(testAdmin.Name, admin.Name);
            Assert.Equal(testAdmin.Email, admin.Email);
            Assert.Equal(testAdmin.Password, admin.Password);
        }

    }
    [Fact]
    public async Task AddAdmin()
    {
        var testAdmin = new Admin()
        {
            Id =Guid.NewGuid(),
            Name ="Farai",
            Email ="FaraiChivunga@gmail.com",
            Password ="12345@adminFarai"

        };

        //Act
        var id = testAdmin.Id;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Admins", testAdmin);
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Admins/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var admin = await response.Content.ReadFromJsonAsync<Admin>();

        Assert.NotNull(admin);
        if (admin != null)
        {
            Assert.Equal(testAdmin.Id, admin.Id);
            Assert.Equal(testAdmin.Name, admin.Name);
            Assert.Equal(testAdmin.Email, admin.Email);
            Assert.Equal(testAdmin.Password, admin.Password);
            
        }
    }

}