using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;
using Xunit.Abstractions;

namespace Tests.IntegrationTests
{
    public class UserIntegrationTest : IClassFixture<WebAppFactory>
    {
         static string token;
        private HttpClient _httpClient = null!;
        private ITestOutputHelper _testOutputHelper = null!;
     
        

        public UserIntegrationTest(WebAppFactory factory, ITestOutputHelper output)
        {
            _testOutputHelper = output;
            _httpClient = factory.CreateClient();
          
        }

        

      
     
}

public class WebAppFactory : WebApplicationFactory<Program>
    {

        protected override void ConfigureWebHost(IWebHostBuilder builder)
        {
            builder.ConfigureTestServices(services =>
            {
                var descriptor = services.SingleOrDefault(
                    d => d.ServiceType == typeof(DbContextOptions<TutorMeContext>));
                            
                if (descriptor != null)
                {
                    services.Remove(descriptor);
                }
                
                services.AddDbContext<TutorMeContext>(options =>
                {
                    options.UseInMemoryDatabase("InMemoryDb");
                });
               
            });
            
        }
    }

   
   
    
}