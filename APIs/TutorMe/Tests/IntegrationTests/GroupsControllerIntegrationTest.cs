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
    public class GroupsControllerIntegrationTest : IClassFixture<WebAppFactory>
    {
        private string token;
        private HttpClient _httpClient;
        private ITestOutputHelper _testOutputHelper = null!;
        
        
        
        public GroupsControllerIntegrationTest(ITestOutputHelper output)
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
                // GroupId = new Guid("ca16749a-1667-47a6-b945-8338f5c6a69c"),
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
        public async Task GetAllGroups_NoGroups()
        {

            //Act
            await InitializeToken();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            var response = await _httpClient.GetAsync("https://localhost:7100/api/Groups");

            //Assert
            Assert.NotNull(response);
            Assert.Equal(200, (double)response.StatusCode);

            var Groups = await response.Content.ReadFromJsonAsync<List<Group>>();

            Assert.Equal(0, Groups.Count());
        }
        
        [Fact]
        public async Task GetAllGroups_with_Groups()
        {
            //Arrange
            await InitializeToken();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    
            var testGroup = new Group()
            { GroupId = Guid.NewGuid(), 
                ModuleId  = Guid.NewGuid(),
                Description = "This is a group for students to learn about software development",
                UserId= Guid.NewGuid(),
                VideoId= Guid.NewGuid().ToString(),

            };
            var testGroup2 = new Group()
            {
                GroupId = Guid.NewGuid(), 
                ModuleId  = Guid.NewGuid(),
                Description = "This is a group for students to learn about Computer Networking",
                UserId= Guid.NewGuid(),
                VideoId= Guid.NewGuid().ToString(),

            };
            var testGroup3 = new Group()
            { GroupId = Guid.NewGuid(), 
                ModuleId  = Guid.NewGuid(), 
                Description = "This is a group for students to learn about Computer Networking",
                UserId= Guid.NewGuid(),
                VideoId= Guid.NewGuid().ToString()
                
            };

            var responseMessage11=await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup);
            Assert.Equal(200, (double)responseMessage11.StatusCode);
            var responseMessage22= await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup2);
            Assert.Equal(200, (double)responseMessage22.StatusCode);
            var responseMessage33=    await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup3);
            Assert.Equal(200, (double)responseMessage33.StatusCode);

            //Act
            var response = await _httpClient.GetAsync("http://localhost:7100/api/Groups");
            
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
            await InitializeToken();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            Guid id = Guid.NewGuid();
            var response = await _httpClient.GetAsync("https://localhost:7100/api/Groups/" + id);

            //Assert
            Assert.NotNull(response);
            Assert.Equal(404, (double)response.StatusCode);

        }
        
        // [Fact]
        // public async Task GetGroupById_GroupFound()
        // {
        //     //Arrange
        //     await InitializeToken();
        //     _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        //
        //     var testGroup = new Group()
        //     {
        //         ModuleId  = Guid.NewGuid(),
        //         Description = "This is a group for students to learn about software development",
        //         UserId= Guid.NewGuid(),
        //         VideoId= Guid.NewGuid().ToString(),
        //
        //     };
        //     var testGroup2 = new Group()
        //     {
        //
        //         ModuleId  = Guid.NewGuid(),
        //         Description = "This is a group for students to learn about Computer Networking",
        //         UserId= Guid.NewGuid(),
        //         VideoId= Guid.NewGuid().ToString(),
        //
        //     };
        //     var testGroup3 = new Group()
        //     {
        //         ModuleId  = Guid.NewGuid(), 
        //         Description = "This is a group for students to learn about Computer Networking",
        //         UserId= Guid.NewGuid(),
        //         VideoId= Guid.NewGuid().ToString(),
        //
        //         
        //     };
        //
        //     await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup);
        //     await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup2);
        //     var responseMessage =
        //         _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup3);
        //
        //     //Act
        //
        //     var idReadAsStringAsync = responseMessage.Result.Content.ReadAsStringAsync().Result;
        //     var id = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
        //     _testOutputHelper.WriteLine("the id is " + id);
        //     var response = await _httpClient.GetAsync("https://localhost:7100/api/Groups/" + id);
        //
        //     //Assert
        //     Assert.NotNull(response);
        //     Assert.Equal(200, (double)response.StatusCode);
        //
        //     var testGroup11 = await response.Content.ReadFromJsonAsync<Group>();
        //
        //     Assert.NotNull(testGroup11);
        //     if (testGroup11 != null)
        //     {
        //         Assert.Equal(testGroup11.ModuleId, testGroup11.ModuleId);
        //         Assert.Equal(testGroup11.Module, testGroup11.Module);
        //
        //     }
        // }
        //
        [Fact]
        public async Task GetGroupById_GroupNotFound()
        {
            //Arrange
            await InitializeToken();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var testGroup = new Group()
            {
                ModuleId  = Guid.NewGuid(),
                Description = "This is a group for students to learn about software development",
                UserId= Guid.NewGuid(),
                VideoId= Guid.NewGuid().ToString(),

            };
            var testGroup2 = new Group()
            {

                ModuleId  = Guid.NewGuid(),
                Description = "This is a group for students to learn about Computer Networking",
                UserId= Guid.NewGuid(),
                VideoId= Guid.NewGuid().ToString(),


            };
            var testGroup3 = new Group()
            {
                ModuleId  = Guid.NewGuid(), 
                Description = "This is a group for students to learn about Computer Networking",
                UserId= Guid.NewGuid(),
                VideoId= Guid.NewGuid().ToString(),
                
            };
            await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup);
            await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup2);
            await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup3);

            //Act
            var id = Guid.NewGuid(); //Group that does not exist
            var response = await _httpClient.GetAsync("https://localhost:7100/api/Groups/" + id);

            //Assert
            Assert.NotNull(response);
            Assert.Equal(404, (double)response.StatusCode);
        }
        
        //
        // [Fact]
        // public async Task AddGroup()
        // {
        //     var testInstitution = new Institution()
        //     {
        //         Name = Guid.NewGuid().ToString(),
        //         Location = "Hatfield"
        //
        //     };
        //     
        //     var responseMessage1 =
        //         await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Institutions", testInstitution);
        //     var idReadAsStringAsync1 = responseMessage1.Content.ReadAsStringAsync().Result;
        //     var testInstitutionId = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync1);
        //
        //     var response1 = await _httpClient.GetAsync("https://localhost:7100/api/Institutions/" + testInstitutionId);
        //
        //     //Assert
        //     Assert.NotNull(response1);
        //     Assert.Equal(200, (double)response1.StatusCode);
        //
        //     var institution = await response1.Content.ReadFromJsonAsync<Institution>();
        //
        //     Assert.NotNull(institution);
        //     if (institution != null)
        //     {
        //         Assert.Equal(testInstitution.Name, institution.Name);
        //         Assert.Equal(testInstitution.Location, institution.Location);
        //
        //     }
        //
        //     
        //     //Act
        //     var testGroup = new Group()
        //     {
        //         // GroupId = Guid.NewGuid(),
        //         ModuleId  = Guid.NewGuid(),
        //         Description = "This is a group for students to learn about software development",
        //         UserId= Guid.NewGuid(),
        //         VideoId= Guid.NewGuid().ToString(),
        //
        //     };
        //     await InitializeToken();
        //     _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        //
        //
        //     var responseMessage = await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup);
        //     var idReadAsStringAsync = responseMessage.Content.ReadAsStringAsync().Result;
        //     var id = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
        //     _testOutputHelper.WriteLine("the id is " + id);
        //     var response = await _httpClient.GetAsync("https://localhost:7100/api/Groups/" + id);
        //
        //     //Assert
        //     Assert.NotNull(response);
        //     _testOutputHelper.WriteLine("the response Group:  " + response);
        //     if (response != null && response.IsSuccessStatusCode == false)
        //     {
        //         var result = response.Content.ReadAsStringAsync().Result;
        //         _testOutputHelper.WriteLine("Http operation unsuccessful");
        //         _testOutputHelper.WriteLine(string.Format("Status: '{0}'", response.StatusCode));
        //         _testOutputHelper.WriteLine(string.Format("Reason: '{0}'", response.ReasonPhrase));
        //
        //         _testOutputHelper.WriteLine(result);
        //     }
        //     Assert.Equal(200, (double)response.StatusCode);
        //
        //     var Group = await response.Content.ReadFromJsonAsync<Group>();
        //
        //     Assert.NotNull(Group);
        //     
        //     if (Group != null)
        //     {
        //         Assert.Equal(testGroup.ModuleId, Group.ModuleId);
        //         Assert.Equal(testGroup.Description, Group.Description);
        //
        //     }
        // }
         // delete Group return 404
        // [Fact]
        // public async Task deleteGroup_return_return_404()
        // {
        //     //Arrange
        //     await InitializeToken();
        //     _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        //
        //     var testGroup = new Group()
        //     {
        //         ModuleId  = Guid.NewGuid(),
        //         Description = "This is a group for students to learn about software development",
        //         UserId= Guid.NewGuid(),
        //         VideoId= Guid.NewGuid().ToString(),
        //
        //     };
        //
        //      await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup);
        //
        //     //Act
        //     // var idReadAsStringAsync = responseMessage.Content.ReadAsStringAsync().Result;
        //     // var id= JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
        //     var id = Guid.NewGuid();
        //     var response = await _httpClient.DeleteAsync("https://localhost:7100/api/Groups/" + id);
        //
        //     //Assert
        //     Assert.NotNull(response);
        //     Assert.Equal(404, (double)response.StatusCode);
        //
        //
        // }

        // [Fact]
        // public async Task deleteGroup_return_return_200()
        // {
        //     //Arrange
        //     await InitializeToken();
        //     _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        //
        //     var testGroup = new Group()
        //     {
        //         ModuleId  = Guid.NewGuid(),
        //         Description = "This is a group for students to learn about software development",
        //         UserId= Guid.NewGuid(),
        //         VideoId= Guid.NewGuid().ToString(),
        //
        //     };
        //
        //     var responseMessage =
        //         await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Groups", testGroup);
        //
        //     //Act
        //     var idReadAsStringAsync = responseMessage.Content.ReadAsStringAsync().Result;
        //     var id = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
        //
        //     var response = await _httpClient.DeleteAsync("https://localhost:7100/api/Groups/" + id);
        //
        //     //Assert
        //     Assert.NotNull(response);
        //     Assert.Equal(200, (double)response.StatusCode);
        //
        //
        // }


    }


}