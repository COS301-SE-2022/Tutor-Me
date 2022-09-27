using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using TutorMe.Data;

namespace Tests.IntegrationTests;

public class WebAppFactory: WebApplicationFactory<Program>
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