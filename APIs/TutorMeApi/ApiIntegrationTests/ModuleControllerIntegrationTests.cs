using System.Net.Http.Json;
using System.Text;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NuGet.Protocol;


namespace IntegrationTests;

public class ModuleControllerIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _httpClient;
   
    public ModuleControllerIntegrationTests()
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
    public async Task GetAllModules_NoModules()
    {
        //Act
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Modules");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var modules = await response.Content.ReadFromJsonAsync<List<Module>>();

        Assert.Equal(0, modules.Count());
    }
    
    [Fact]
    public async Task GetAllModules_Modules()
    {
        //Arrange
        var testModule = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "Software engineering 301",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };
        var testModule2 = new Module()
        {

            Code =Guid.NewGuid().ToString(),
            ModuleName = "COS 212",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="2"

        };
        var testModule3 = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "COS 332",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule3);

        //Act
        var response = await _httpClient.GetAsync("http://localhost:7062/api/Modules");

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var modules = await response.Content.ReadFromJsonAsync<List<Module>>();
        Assert.NotNull(modules);
        Assert.Equal(3, modules.Count());
    }
    
    [Fact]
    public async Task GetModuleById_NoModule()
    {
        //Act
        Guid id = Guid.NewGuid();
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Modules/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    [Fact]
    public async Task GetModuleById_ModuleFound()
    {
        //Arrange
        var testModule = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "Software engineering 301",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };
        var testModule2 = new Module()
        {

            Code =Guid.NewGuid().ToString(),
            ModuleName = "COS 212",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="2"

        };
        var testModule3 = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "COS 332",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule3);

        //Act
        var id = testModule.Code;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Modules/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var module = await response.Content.ReadFromJsonAsync<Module>();

        Assert.NotNull(module);
        if (module != null)
        {
            Assert.Equal(testModule.Code, module.Code);
            Assert.Equal(testModule.ModuleName, module.ModuleName);
            Assert.Equal(testModule.Institution, module.Institution);
            Assert.Equal(testModule.Faculty, module.Faculty);
            Assert.Equal(testModule.Year, module.Year);
           
        }
    }
    
    [Fact]
    public async Task GetModuleById_ModuleNotFound() 
    {
        //Arrange
        var testModule = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "Software engineering 301",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };
        var testModule2 = new Module()
        {

            Code =Guid.NewGuid().ToString(),
            ModuleName = "COS 212",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="2"

        };
        var testModule3 = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "COS 332",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };

        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule2);
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule3);

        //Act
        var id = Guid.NewGuid();//Module that does not exist
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Modules/"+id);
        
        //Assert
        Assert.NotNull(response);
        Assert.Equal(404, (double)response.StatusCode);
    }
    
    [Fact]
    public async Task ModifiesModuleFromDatabase()
    {
        //Arrange
        var testModule = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "Software engineering 301",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };
      
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule);
        
        //Act
        
        //Modify the Modules Name and year
        testModule.ModuleName = "COS 132";
        testModule.Year = "1";

        var stringContent =new StringContent(testModule.ToJson(), Encoding.UTF8, "application/json");
        var response1= await _httpClient.PutAsync("https://localhost:7062/api/Modules/" + testModule.Code,stringContent );
        //Assert
        Assert.NotNull(response1);
        Assert.Equal(204, (double)response1.StatusCode); 

        
        //Now checking if the Name and year was actually Modified on the database 
        var id = testModule.Code;
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Modules/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var module = await response.Content.ReadFromJsonAsync<Module>();

        Assert.NotNull(module);
        if (module != null)
        {
            Assert.Equal(testModule.Code, module.Code);
            Assert.Equal(testModule.Year, module.Year);
            Assert.Equal(testModule.ModuleName, module.ModuleName);
        }

    }
    [Fact]
    public async Task AddModule()
    {
        var testModule = new Module()
        {
            Code =Guid.NewGuid().ToString(),
            ModuleName = "Software engineering 301",
            Institution ="University Of Pretoria",
            Faculty = "Faculty of Engineering, Built Environment and IT",
            Year="3"

        };

        //Act
        var id = testModule.Code;
        await _httpClient.PostAsJsonAsync("https://localhost:7062/api/Modules", testModule);
        var response = await _httpClient.GetAsync("https://localhost:7062/api/Modules/"+id);

        //Assert
        Assert.NotNull(response);
        Assert.Equal(200, (double)response.StatusCode);

        var module = await response.Content.ReadFromJsonAsync<Module>();

        Assert.NotNull(module);
        if (module != null)
        {
            Assert.Equal(testModule.Code, module.Code);
            Assert.Equal(testModule.ModuleName, module.ModuleName);
            Assert.Equal(testModule.Institution, module.Institution);
            Assert.Equal(testModule.Faculty, module.Faculty);
            Assert.Equal(testModule.Year, module.Year);
            
        }
    }

}
