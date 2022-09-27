using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NuGet.Protocol;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;
using Xunit.Abstractions;

namespace Tests.IntegrationTests
{
    public class AuthorizationIntegrationTest : IClassFixture<WebAppFactory>
    {
         static string token;
        private HttpClient _httpClient;
        private ITestOutputHelper _testOutputHelper = null!;
        private static Guid testUsersId;
        
        public AuthorizationIntegrationTest(WebAppFactory factory, ITestOutputHelper output)
        {
            _testOutputHelper = output;
            _httpClient = factory.CreateClient();
          
        }

        [Fact]
        public async Task Register_A_User_testing_the_protected_endpoint_with_an_incorrect_token()
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
             testUsersId = jo["user"]["userId"].ToObject<Guid>();
             
             // Now testing the protected endpoint with an incorrect  token
            
             //Act
            
             _testOutputHelper.WriteLine("the token is " + token);
             _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "incorrect token");
            
            
             var bio="Naruto fan";
             var stringContent =new StringContent(bio.ToJson(), Encoding.UTF8, "application/json");
             var response2= await _httpClient.PutAsync("https://localhost:7100/api/users/" + testUsersId,stringContent );
            
          
             //Assert
             Assert.NotNull(response2);
             _testOutputHelper.WriteLine("the body: " +response2);
             if (response2 != null && response2.IsSuccessStatusCode == false)
             {
                 var result = response2.Content.ReadAsStringAsync().Result;
                 _testOutputHelper.WriteLine("Http operation unsuccessful");
                 _testOutputHelper.WriteLine(string.Format("Status: '{0}'", response2.StatusCode));
                 _testOutputHelper.WriteLine(string.Format("Reason: '{0}'", response2.ReasonPhrase));

                 _testOutputHelper.WriteLine(result);
             }
             Assert.Equal(401, (double)response2.StatusCode);

          

        }

      
        [Fact]
        public async Task Register_A_User_testing_the_protected_endpoint_with_a_correct_token()
        {
              var testUser = new User
            {
                FirstName = "Thabo",
                LastName = "Maduna",
                DateOfBirth = "02/04/2000",
                Status = true,
                Gender = "M",
                Email = "thaboMaduna@gmail.com",
                Password = "12345678",
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

            expectedUser.Email = "thaboMaduna@gmail.com";
            expectedUser.Password = "12345678";
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
             testUsersId = jo["user"]["userId"].ToObject<Guid>();
             
                 
             
             // Now testing the protected endpoint with a correct token
             //Act
            
             _testOutputHelper.WriteLine("the token is " + token);
             _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            
            
             var bio="Naruto fan";
             // var stringContent =new StringContent(bio.ToJson(), Encoding.UTF8, "application/json");
             var response2= await _httpClient.PutAsync("https://localhost:7001/api/users/Bio/" + testUsersId+"?Bio="+bio,null );
            
          
             //Assert
             Assert.NotNull(response2);
             _testOutputHelper.WriteLine("the body: " +response2);
             if (response2 != null && response2.IsSuccessStatusCode == false)
             {
                 var result = response2.Content.ReadAsStringAsync().Result;
                 _testOutputHelper.WriteLine("Http operation unsuccessful");
                 _testOutputHelper.WriteLine(string.Format("Status: '{0}'", response2.StatusCode));
                 _testOutputHelper.WriteLine(string.Format("Reason: '{0}'", response2.ReasonPhrase));

                 _testOutputHelper.WriteLine(result);
             }
             Assert.Equal(200, (double)response2.StatusCode);

             var valid = await response2.Content.ReadFromJsonAsync<bool>();

             Assert.Equal(true, valid); 


        }
        

      
    }



}