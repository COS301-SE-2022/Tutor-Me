using System.Net.Http.Headers;
using System.Net.Http.Json;

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
                FirstName = Guid.NewGuid().ToString(),
                LastName = Guid.NewGuid().ToString(),
                DateOfBirth = "02/04/2000",
                Status = true,
                Gender = "M",
                Email = Guid.NewGuid().ToString(),
                Password = Guid.NewGuid().ToString(),
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

            expectedUser.Email = testUser.Email;
            expectedUser.Password =testUser.Password;
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


        }
      
        [Fact]
        public async Task aGetAllUsers_NoUsers()
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
           // await GetAllUsers_With_Exsisting_Users();
        }
        [Fact]
        public async Task GetAllUsers_With_Exsisting_Users()
        { 
            //Arrange
            await InitializeToken();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            var testUser = new User()
            {
                FirstName = "Simphiwe",
                LastName = "Ndlovu",
                DateOfBirth = "02/04/1999",
                Status = true,
                Gender = "M",
                Email = "simphiwendlovu527@gmail.com",
                Password = "24681012",
                UserTypeId = new Guid("3fa85f64-5717-4562-b3fc-2c963f66afa6"), //Tutor
                InstitutionId = new Guid("ca16749a-1667-47a6-b945-8338f5c6a69c"),
                Location = "1166 Burnet, 0028",
                Bio = "One Piece",
                Year = "3",
                Rating = 0,
                NumberOfReviews = 0

            };
            var testUser2 = new User()
            {
                
                FirstName = "Musa",
                LastName = "Mabasa",
                DateOfBirth = "02/04/2000",
                Status = true,
                Gender = "M",
                Email = "MusaMabasa@gmail.com",
                Password = "24681012",
                UserTypeId =  new Guid("2fa85f64-5717-4562-b3fc-2c963f66afa6"), //Tutee
                InstitutionId = new Guid("ca16749a-1667-47a6-b945-8338f5c6a69c"),
                Location = "1166 Burnet, 0028",
                Bio = "One Piece",
                Year = "3",
                Rating = 0,
                NumberOfReviews = 0

            };
            var testUser3 = new User()
            {
                FirstName = "Farai",
                LastName = "Chivunga",
                DateOfBirth = "02/04/2000",
                Status = true,
                Gender = "M",
                Email = "FaraiChivunga@gmail.com",
                Password = "24681012",
                UserTypeId = new Guid("2fa85f64-5717-4562-b3fc-2c963f66afa6"), //Tutee
                InstitutionId = new Guid("ca16749a-1667-47a6-b945-8338f5c6a69c"),
                Location = "1166 erodit, 0028",
                Bio = "foot ball",
                Year = "3",
                Rating = 0,
                NumberOfReviews = 0

            };

            await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Users", testUser);
            await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Users", testUser2);
            await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Users", testUser3);

            //Act
            var response = await _httpClient.GetAsync("http://localhost:7100/api/Users");

            //Assert
            Assert.NotNull(response);
            Assert.Equal(200, (double)response.StatusCode);

            var users = await response.Content.ReadFromJsonAsync<List<User>>();
            Assert.NotNull(users);
            Assert.Equal(5, users.Count());//4+1
           
    }

      
    }



   
   
    
}