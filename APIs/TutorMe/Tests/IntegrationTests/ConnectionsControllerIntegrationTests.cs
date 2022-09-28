using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;
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
    public class ConnectionControllerIntegrationTest : IClassFixture<WebAppFactory>
    {
        private string token;
        private HttpClient _httpClient;
        private ITestOutputHelper _testOutputHelper = null!;
        
        
        
        public ConnectionControllerIntegrationTest(ITestOutputHelper output)
        {   _testOutputHelper = output;
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

       

        private async Task InitializeToken()
        {
            var testUser = new User
            {
                FirstName = Guid.NewGuid().ToString(),
                LastName = Guid.NewGuid().ToString(),
                DateOfBirth = "02/04/2000",
                Status = true,
                Gender = "M",
                Email = Guid.NewGuid().ToString(),
                Password = Guid.NewGuid().ToString(),
                UserTypeId = new Guid("1fa85f64-5717-4562-b3fc-2c963f66afa6"), //Admin
                // ConnectionId = new Guid("ca16749a-1667-47a6-b945-8338f5c6a69c"),
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

            expectedUser.Email = testUser.Email;
            expectedUser.Password = testUser.Password;
            expectedUser.TypeId = new Guid("1fa85f64-5717-4562-b3fc-2c963f66afa6");

            var response =
                await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Account/AuthToken", expectedUser);
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


        }

        [Fact]
        public async Task GetAllConnection_NoConnection()
        {

            //Act
            await InitializeToken();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            var response = await _httpClient.GetAsync("https://localhost:7100/api/Connections");

            //Assert
            Assert.NotNull(response);
            Assert.Equal(200, (double)response.StatusCode);

            var Connection = await response.Content.ReadFromJsonAsync<List<Connection>>();

            Assert.Equal(0, Connection.Count());
        }
       
         // delete Connection return 404
        [Fact]
        public async Task deleteConnection_return_return_404()
        {
            //Arrange
            await InitializeToken();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var testConnection = new Connection()
            {
                ConnectionId = Guid.NewGuid(),
                TutorId = Guid.NewGuid(),
                TuteeId = Guid.NewGuid(),
                ModuleId = Guid.NewGuid(),

            };

             await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Connections", testConnection);

            //Act
            // var idReadAsStringAsync = responseMessage.Content.ReadAsStringAsync().Result;
            // var id= JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
            var id = Guid.NewGuid();
            var response = await _httpClient.DeleteAsync("https://localhost:7100/api/Connections/" + id);

            //Assert
            Assert.NotNull(response);
            Assert.Equal(404, (double)response.StatusCode);


        }

       

    }


}