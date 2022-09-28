// using System.Net.Http.Headers;
// using System.Net.Http.Json;
// using Microsoft.AspNetCore.Mvc.Testing;
// using Microsoft.EntityFrameworkCore;
// using Microsoft.Extensions.DependencyInjection;
// using Newtonsoft.Json;
// using Newtonsoft.Json.Linq;
// using TutorMe.Data;
// using TutorMe.Entities;
// using TutorMe.Models;
// using Xunit.Abstractions;
//
// namespace Tests.IntegrationTests
// {
//     public class ModulesControllerIntegrationTest : IClassFixture<WebAppFactory>
//     {
//         private string token;
//         private HttpClient _httpClient;
//         private ITestOutputHelper _testOutputHelper = null!;
//
//        
//    
//         public ModulesControllerIntegrationTest(ITestOutputHelper output)
//         {   _testOutputHelper = output;
//             var dbname = Guid.NewGuid().ToString();
//             var appFactory = new WebApplicationFactory<Program>()
//                 .WithWebHostBuilder(builder =>
//                 {
//                     builder.ConfigureServices(
//                         services =>
//                         {
//                             var descriptor = services.SingleOrDefault(
//                                 d => d.ServiceType == typeof(DbContextOptions<TutorMeContext>));
//
//                             if (descriptor != null)
//                             {
//                                 services.Remove(descriptor);
//                             }
//                             services.AddDbContext<TutorMeContext>(
//                                 options =>
//                                 {
//                                     options.UseInMemoryDatabase(dbname);
//                                 });
//                         });
//                 });
//
//             _httpClient = appFactory.CreateClient();
//         }
//
//        
//
//         private async Task InitializeToken()
//         {
//             var testModule = new User()
//             {
//                 FirstName = Guid.NewGuid().ToString(),
//                 LastName = Guid.NewGuid().ToString(),
//                 DateOfBirth = "02/04/2000",
//                 Status = true,
//                 Gender = "M",
//                 Email = Guid.NewGuid().ToString(),
//                 Password = Guid.NewGuid().ToString(),
//                 UserTypeId =  new Guid("1fa85f64-5717-4562-b3fc-2c963f66afa6"), //Admin
//                 // ModuleId = new Guid("ca16749a-1667-47a6-b945-8338f5c6a69c"),
//                 Location = "1166 TMN, 0028",
//                 Bio = "The boys",
//                 Year = "3",
//                 Rating = 0,
//                 NumberOfReviews = 0
//             };
//
//             //Act
//             var response1 = await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Users", testModule);
//
//             //Assert
//             Assert.NotNull(response1);
//             Assert.Equal(200, (double)response1.StatusCode);
//
//
//             //Arrange
//
//
//             //Log in
//             var expectedModule = new UserLogIn();
//
//             expectedModule.Email = testModule.Email;
//             expectedModule.Password = testModule.Password;
//             expectedModule.TypeId = new Guid("1fa85f64-5717-4562-b3fc-2c963f66afa6");
//
//             var response =
//                 await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Account/AuthToken", expectedModule);
//             _testOutputHelper.WriteLine("the body login " + response);
//             response.EnsureSuccessStatusCode();
//             Assert.NotNull(response);
//             if (response != null && response.IsSuccessStatusCode == false)
//             {
//                 var result = response.Content.ReadAsStringAsync().Result;
//                 _testOutputHelper.WriteLine("Http operation unsuccessful");
//                 _testOutputHelper.WriteLine(string.Format("Status: '{0}'", response.StatusCode));
//                 _testOutputHelper.WriteLine(string.Format("Reason: '{0}'", response.ReasonPhrase));
//
//                 _testOutputHelper.WriteLine(result);
//             }
//
//             Assert.Equal(200, (double)response.StatusCode);
//
//             var responseObj = await response.Content.ReadAsStringAsync();
//             var theObj = JsonConvert.DeserializeObject(responseObj);
//             var myJsonString = JsonConvert.DeserializeObject(responseObj).ToString();
//             var jo = JObject.Parse(myJsonString);
//             token = jo["token"].ToString();
//
//
//         }
//
//         [Fact]
//         public async Task GetAllModules_NoModules()
//         {
//
//             //Act
//             await InitializeToken();
//             _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//             var response = await _httpClient.GetAsync("https://localhost:7100/api/Modules");
//
//             //Assert
//             Assert.NotNull(response);
//             Assert.Equal(200, (double)response.StatusCode);
//
//             var Modules = await response.Content.ReadFromJsonAsync<List<Module>>();
//
//             Assert.Equal(0, Modules.Count());
//         }
//         
//         [Fact]
//         public async Task GetAllModules_with_Modules()
//         {
//             //Arrange
//             await InitializeToken();
//             _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//
//             var testModule = new Module()
//             {
//                 Code  = "COS 301",
//                 ModuleName ="Software Engineering",
//                 InstitutionId = Guid.NewGuid(),
//                 Faculty ="Faculty of Engineering and Built Environment",
//                 Year = "3",
//
//             };
//             var testModule2 = new Module()
//             {
//                 
//                 Code  = "COS 332",
//                 ModuleName ="Computer Networks",
//                 InstitutionId = Guid.NewGuid(),
//                 Faculty ="Faculty of Engineering and Built Environment",
//                 Year = "2",
//             };
//             var testModule3 = new Module()
//             {
//                 Code  = "COS 333",
//                 ModuleName ="Computer Systems",
//                 InstitutionId = Guid.NewGuid(),
//                 Faculty ="Faculty of Engineering and Built Environment",
//                 Year = "2",
//
//             };
//
//             await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule);
//             await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule2);
//             await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule3);
//
//             //Act
//             var response = await _httpClient.GetAsync("http://localhost:7100/api/Modules");
//
//             //Assert
//             Assert.NotNull(response);
//             Assert.Equal(200, (double)response.StatusCode);
//
//             var Modules = await response.Content.ReadFromJsonAsync<List<Module>>();
//             Assert.NotNull(Modules);
//             Assert.Equal(3, Modules.Count());
//         }
//         [Fact]
//         public async Task GetModuleById_NoModule()
//         {
//             //Act
//             await InitializeToken();
//             _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//
//             Guid id = Guid.NewGuid();
//             var response = await _httpClient.GetAsync("https://localhost:7100/api/Modules/" + id);
//
//             //Assert
//             Assert.NotNull(response);
//             Assert.Equal(404, (double)response.StatusCode);
//
//         }
//         //
//         // [Fact]
//         // public async Task GetModuleById_ModuleFound()
//         // {
//         //     //Arrange
//         //     await InitializeToken();
//         //     _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//         //
//         //     
//         //     var testModule = new Module()
//         //     {
//         //         ModuleId  = Guid.NewGuid(),
//         //         Code  = "COS 301",
//         //         ModuleName ="Software Engineering",
//         //         InstitutionId = Guid.NewGuid(),
//         //         Faculty ="Faculty of Engineering and Built Environment",
//         //         Year = "3",
//         //
//         //     };
//         //     var testModule2 = new Module()
//         //     {
//         //         ModuleId  = Guid.NewGuid(),
//         //         Code  = "COS 332",
//         //         ModuleName ="Computer Networks",
//         //         InstitutionId = Guid.NewGuid(),
//         //         Faculty ="Faculty of Engineering and Built Environment",
//         //         Year = "2",
//         //     };
//         //     var testModule3 = new Module()
//         //     {
//         //         ModuleId  = Guid.NewGuid(),
//         //         Code  = "COS 333",
//         //         ModuleName ="Computer Systems",
//         //         InstitutionId = Guid.NewGuid(),
//         //         Faculty ="Faculty of Engineering and Built Environment",
//         //         Year = "2",
//         //
//         //     };
//         //
//         //     await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule);
//         //     
//         //     await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule2);
//         //     
//         //     var responseMessage = _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule3);
//         //     
//         //     Assert.Equal(200, (double)responseMessage.Result.StatusCode);
//         //     
//         //     //Act
//         //     var idReadAsStringAsync = responseMessage.Result.Content.ReadAsStringAsync().Result;
//         //     var id = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
//         //     _testOutputHelper.WriteLine("the id is " + id);
//         //   
//         //     
//         //     var response = await _httpClient.GetAsync("https://localhost:7100/api/Modules/" + id);
//         //
//         //     //Assert
//         //     Assert.NotNull(response);
//         //     Assert.Equal(200, (double)response.StatusCode);
//         //
//         //     var testModule11 = await response.Content.ReadFromJsonAsync<Module>();
//         //
//         //     Assert.NotNull(testModule11);
//         //     if (testModule11 != null)
//         //     {
//         //         Assert.Equal(testModule11.Code, testModule11.Code);
//         //         Assert.Equal(testModule11.ModuleName, testModule11.ModuleName);
//         //         Assert.Equal(testModule11.InstitutionId, testModule11.InstitutionId);
//         //         Assert.Equal(testModule11.Faculty, testModule11.Faculty);
//         //         Assert.Equal(testModule11.Year, testModule11.Year);
//         //     }
//         // }
//         
//         [Fact]
//         public async Task GetModuleById_ModuleNotFound()
//         {
//             //Arrange
//             await InitializeToken();
//             _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//
//            
//             var testModule = new Module()
//             {
//                 Code  = "COS 301",
//                 ModuleName ="Software Engineering",
//                 InstitutionId = Guid.NewGuid(),
//                 Faculty ="Faculty of Engineering and Built Environment",
//                 Year = "3",
//
//             };
//             var testModule2 = new Module()
//             {
//
//                 ModuleId  = Guid.NewGuid(),
//                 Code  = "COS 332",
//                 ModuleName ="Computer Networks",
//                 InstitutionId = Guid.NewGuid(),
//                 Faculty ="Faculty of Engineering and Built Environment",
//                 Year = "2",
//             };
//             var testModule3 = new Module()
//             {
//                 ModuleId  = Guid.NewGuid(),
//                 Code  = "COS 333",
//                 ModuleName ="Computer Systems",
//                 InstitutionId = Guid.NewGuid(),
//                 Faculty ="Faculty of Engineering and Built Environment",
//                 Year = "2",
//
//             };
//             await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule);
//             await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule2);
//             await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule3);
//
//             //Act
//             var id = Guid.NewGuid(); //Module that does not exist
//             var response = await _httpClient.GetAsync("https://localhost:7100/api/Modules/" + id);
//
//             //Assert
//             Assert.NotNull(response);
//             Assert.Equal(404, (double)response.StatusCode);
//         }
//         
//         
//         // [Fact]
//         // public async Task AddModule()
//         // {
//         //     await InitializeToken();
//         //     _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//         //
//         //
//         //     var testInstitution = new Institution()
//         //     {
//         //         Name = Guid.NewGuid().ToString(),
//         //         Location = "Hatfield"
//         //
//         //     };
//         //     
//         //     var responseMessage1 =
//         //         await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Institutions", testInstitution);
//         //     var idReadAsStringAsync1 = responseMessage1.Content.ReadAsStringAsync().Result;
//         //     var testInstitutionId = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync1);
//         //     _testOutputHelper.WriteLine("TEST INSTITUTION ID IS " + testInstitutionId);
//         //     var response1 = await _httpClient.GetAsync("https://localhost:7100/api/Institutions/" + testInstitutionId);
//         //
//         //     //Assert
//         //     Assert.NotNull(response1);
//         //     Assert.Equal(200, (double)response1.StatusCode);
//         //
//         //     var institution = await response1.Content.ReadFromJsonAsync<Institution>();
//         //
//         //     Assert.NotNull(institution);
//         //     if (institution != null)
//         //     {
//         //         Assert.Equal(testInstitution.Name, institution.Name);
//         //         Assert.Equal(testInstitution.Location, institution.Location);
//         //     }
//         //
//         //     //Act
//         //     var testModule = new Module()
//         //     {
//         //         ModuleId = Guid.NewGuid(),
//         //         Code  = "COS 301",
//         //         ModuleName ="Software Engineering",
//         //         InstitutionId = testInstitutionId,
//         //         Faculty ="Faculty of Engineering and Built Environment",
//         //         Year = "3",
//         //
//         //     };
//         //    
//         //
//         //     var responseMessage =
//         //         await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule);
//         //     var idReadAsStringAsync = responseMessage.Content.ReadAsStringAsync().Result;
//         //     var id = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
//         //
//         //     var response = await _httpClient.GetAsync("https://localhost:7100/api/Modules/" + id);
//         //
//         //     //Assert
//         //     Assert.NotNull(response);
//         //     Assert.Equal(200, (double)response.StatusCode);
//         //
//         //     var Module = await response.Content.ReadFromJsonAsync<Module>();
//         //
//         //     Assert.NotNull(Module);
//         //     if (Module != null)
//         //     {
//         //         Assert.Equal(testModule.Code, Module.Code);
//         //         Assert.Equal(testModule.ModuleName, Module.ModuleName);
//         //         Assert.Equal(testModule.InstitutionId, Module.InstitutionId);
//         //         Assert.Equal(testModule.Faculty, Module.Faculty);
//         //         Assert.Equal(testModule.Year, Module.Year);
//         //
//         //     }
//         // }
//          // delete Module return 404
//         [Fact]
//         public async Task deleteModule_return_return_404()
//         {
//             //Arrange
//             await InitializeToken();
//             _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//
//             var testModule = new Module()
//             {
//                 Code  = "COS 301",
//                 ModuleName ="Software Engineering",
//                 InstitutionId = Guid.NewGuid(),
//                 Faculty ="Faculty of Engineering and Built Environment",
//                 Year = "3",
//
//             };
//
//              await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule);
//
//             //Act
//             // var idReadAsStringAsync = responseMessage.Content.ReadAsStringAsync().Result;
//             // var id= JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
//             var id = Guid.NewGuid();
//             var response = await _httpClient.DeleteAsync("https://localhost:7100/api/Modules/" + id);
//
//             //Assert
//             Assert.NotNull(response);
//             Assert.Equal(404, (double)response.StatusCode);
//
//
//         }
//         //
//         // [Fact]
//         // public async Task deleteModule_return_return_200()
//         // {
//         //     //Arrange
//         //     await InitializeToken();
//         //     _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
//         //     var testModule = new Module()
//         //     {   ModuleId = Guid.NewGuid(),
//         //         Code  = "COS 301",
//         //         ModuleName ="Software Engineering",
//         //         InstitutionId = Guid.NewGuid(),
//         //         Faculty ="Faculty of Engineering and Built Environment",
//         //         Year = "3",
//         //
//         //     };
//         //
//         //     var responseMessage = await _httpClient.PostAsJsonAsync("https://localhost:7100/api/Modules", testModule);
//         //
//         //     //Act
//         //     var idReadAsStringAsync = responseMessage.Content.ReadAsStringAsync().Result;
//         //     var id = JsonConvert.DeserializeObject<Guid>(idReadAsStringAsync);
//         //     _testOutputHelper.WriteLine("response m: "+responseMessage);
//         //     _testOutputHelper.WriteLine(" id:: " + id);
//         //     
//         //     var response = await _httpClient.DeleteAsync("https://localhost:7100/api/Modules/" + id.ToString(
//         //         ));
//         //
//         //     //Assert
//         //     Assert.NotNull(response);
//         //     Assert.Equal(200, (double)response.StatusCode);
//         // }
//
//
//     }
//
//
// }