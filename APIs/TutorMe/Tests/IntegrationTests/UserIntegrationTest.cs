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
        private HttpClient _httpClient;
        private ITestOutputHelper _testOutputHelper = null!;
     
        

        public UserIntegrationTest(WebAppFactory factory, ITestOutputHelper output)
        {
            _testOutputHelper = output;
            _httpClient = factory.CreateClient();
          
        }

        private async Task InitializeToken()
        {
              var testUser = new User
            {
                FirstName = "Thabo",
                LastName = "Maduna",
                DateOfBirth = "02/04/2000",
                Status = true,
                Gender = "M",
                Email = "thaboMaduna527@gmail.com",
                Password = "24681012",
                UserTypeId = new Guid("1fa85f64-5717-4562-b3fc-2c963f66afa6"), //Admin
                // InstitutionId = new Guid("ca16749a-1667-47a6-b945-8338f5c6a69c"),
                Location = "1166 TMN, 0028",
                Bio = "The boys",
                Year = "3",
                Rating = 0,
                NumberOfReviews = 0
            };

            //Act
            var response1 = await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Users", testUser);

            //Assert
            Assert.NotNull(response1);
            Assert.Equal(200, (double)response1.StatusCode);


            //Arrange


            //Log in
            var expectedUser = new UserLogIn();

            expectedUser.Email = "thaboMaduna527@gmail.com";
            expectedUser.Password = "24681012";
            expectedUser.TypeId = new Guid("1fa85f64-5717-4562-b3fc-2c963f66afa6");

            var response = await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Account/AuthToken", expectedUser);
            _testOutputHelper.WriteLine("the body login " + response);
            response.EnsureSuccessStatusCode();
            Assert.NotNull(response);
            if (response != null && response.IsSuccessStatusCode == false)
            {
                var result = response.Content.ReadAsStringAsync().Result;
                _testOutputHelper.WriteLine("Http operation unsuccessful");
                _testOutputHelper.WriteLine(string.Format("Status: '{0}'", response.StatusCode));
                _testOutputHelper.WriteLine(string.Format("Reason: '{0}'", response.ReasonPhrase));

                _testOutputHelper.WriteLine(result);
            }

            Assert.Equal(200, (double)response.StatusCode);

            var responseObj = await response.Content.ReadAsStringAsync();
            var theObj = JsonConvert.DeserializeObject(responseObj);
            var myJsonString = JsonConvert.DeserializeObject(responseObj).ToString();
            var jo = JObject.Parse(myJsonString);
             token = jo["token"].ToString();
            _testOutputHelper.WriteLine("GetToken funct " + token);
            
            
        }
      
        [Fact]
        public async Task GetAllUsers_NoUsers()
        {
            //Act
             await InitializeToken();
            _testOutputHelper.WriteLine("the token is " + token);
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            var response = await _httpClient.GetAsync("https://localhost:7100/api/Users");

            //Assert
            Assert.NotNull(response);
            _testOutputHelper.WriteLine("the body: " +response);
            if (response != null && response.IsSuccessStatusCode == false)
            {
                var result = response.Content.ReadAsStringAsync().Result;
                _testOutputHelper.WriteLine("Http operation unsuccessful");
                _testOutputHelper.WriteLine(string.Format("Status: '{0}'", response.StatusCode));
                _testOutputHelper.WriteLine(string.Format("Reason: '{0}'", response.ReasonPhrase));

                _testOutputHelper.WriteLine(result);
            }
            Assert.Equal(200, (double)response.StatusCode);

            var users = await response.Content.ReadFromJsonAsync<List<User>>();

            Assert.Equal(1, users.Count()); //User that just registered 
            
            
            //Now Testing with Users
           // await GetAllUsers_With_Exsistng_Users();
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