using System.Net.Http.Json;
using System.Text;
using FileSystem.Data;
using FileSystem.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestPlatform.TestHost;
using NuGet.Protocol;
using HttpClient = System.Net.Http.HttpClient;

namespace FileSystemIntegrationTests;

public class TuteeFileFilesIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    // private readonly HttpClient _httpClient;
    //
    // public TuteeFileFilesIntegrationTests()
    // {
    //     var dbname = Guid.NewGuid().ToString();
    //     var appFactory = new WebApplicationFactory<Program>()
    //         .WithWebHostBuilder(builder =>
    //         {
    //             builder.ConfigureServices(
    //                 services =>
    //                 {
    //                     var descriptor = services.SingleOrDefault(
    //                         d => d.ServiceType == typeof(DbContextOptions<FilesContext>));
    //
    //                     if (descriptor != null)
    //                     {
    //                         services.Remove(descriptor);
    //                     }
    //                     services.AddDbContext<FilesContext>(
    //                         options =>
    //                         {
    //                             options.UseInMemoryDatabase(dbname);
    //                         });
    //                 });
    //         });
    //
    //     _httpClient = appFactory.CreateClient();
    // }
    //
    // [Fact]
    // public async Task GetAllTuteeFiles_NoTuteeFiles()
    // {
    //     //Act
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TuteeFiles");
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TuteeFiles = await response.Content.ReadFromJsonAsync<List<TuteeFile>>();// ReadAsAsync<List<TuteeFile>>();
    //
    //     Assert.Equal(0, TuteeFiles.Count());
    // }
    //
    // [Fact]
    // public async Task GetAllTuteeFiles_TuteeFiles()
    // {
    //     //Arrange
    //     var testTuteeFile = new TuteeFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTuteeFile2 = new TuteeFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTuteeFile3 = new TuteeFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile2);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile3);
    //
    //     //Act
    //     var response = await _httpClient.GetAsync("http://localhost:7062/api/TuteeFiles");
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TuteeFiles = await response.Content.ReadFromJsonAsync<List<TuteeFile>>();
    //     Assert.NotNull(TuteeFiles);
    //     Assert.Equal(3, TuteeFiles.Count());
    // }
    //
    // [Fact]
    // public async Task GetTuteeFileById_NoTuteeFile()
    // {
    //     //Act
    //     Guid id = Guid.NewGuid();
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TuteeFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(404, (double)response.StatusCode);
    // }
    // [Fact]
    // public async Task GetTuteeFileById_TuteeFileFound()
    // { 
    //     //Arrange
    //     var testTuteeFile = new TuteeFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTuteeFile2 = new TuteeFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTuteeFile3 = new TuteeFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile2);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile3);
    //
    //     //Act
    //     var id = testTuteeFile.Id;
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TuteeFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TuteeFile = await response.Content.ReadFromJsonAsync<TuteeFile>();
    //
    //     Assert.NotNull(TuteeFile);
    //     if (TuteeFile != null)
    //     {
    //         Assert.Equal(testTuteeFile.Id, TuteeFile.Id);
    //         Assert.Equal(testTuteeFile.TuteeImage, TuteeFile.TuteeImage);
    //         Assert.Equal(testTuteeFile.TuteeTranscript, TuteeFile.TuteeTranscript);
    //        
    //     }
    // }
    //
    // [Fact]
    // public async Task GetTuteeFileById_TuteeFileNotFound() 
    // {
    //     //Arrange
    //     var testTuteeFile = new TuteeFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTuteeFile2 = new TuteeFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTuteeFile3 = new TuteeFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile2);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile3);
    //
    //     //Act
    //     var id = Guid.NewGuid();//TuteeFile that does not exist
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TuteeFiles/"+id);
    //     
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(404, (double)response.StatusCode);
    // }
    // [Fact]
    // public async Task GetTuteeFileByEmail_NoTuteeFile()
    // {
    //     //Act
    //     Guid id = Guid.NewGuid();
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TuteeFiles/email/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(404, (double)response.StatusCode);
    // }
    //
    //
    //   [Fact]
    // public async Task ModifiesTuteeFileFromDatabase()
    // {
    //     //Arrange
    //     var testTuteeFile = new TuteeFile()
    //     {
    //        
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //         
    //     };
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile);
    //     
    //     //Act
    //     
    //     //Modify the Tutees Image
    //     testTuteeFile.TuteeImage =Guid.NewGuid().ToByteArray();
    //     
    //     
    //     var stringContent =new StringContent(testTuteeFile.ToJson(), Encoding.UTF8, "application/json");
    //     var response1= await _httpClient.PutAsync("https://localhost:7062/api/TuteeFiles/" + testTuteeFile.Id,stringContent );
    //     //Assert
    //     Assert.NotNull(response1);
    //     Assert.Equal(204, (double)response1.StatusCode); 
    //
    //     
    //     //Now checking if the Image was actually Modified on the database 
    //     var id = testTuteeFile.Id;
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TuteeFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TuteeFile = await response.Content.ReadFromJsonAsync<TuteeFile>();
    //
    //     Assert.NotNull(TuteeFile);
    //     if (TuteeFile != null)
    //     {
    //         Assert.Equal(testTuteeFile.Id, TuteeFile.Id);
    //         Assert.Equal(testTuteeFile.TuteeImage, TuteeFile.TuteeImage);
    //         
    //     }
    //
    // }
    // [Fact]
    // public async Task AddTuteeFile()
    // {
    //     var testTuteeFile = new TuteeFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TuteeImage=Guid.NewGuid().ToByteArray(),
    //         TuteeTranscript =Guid.NewGuid().ToByteArray()
    //     };
    //
    //     //Act
    //     var id = testTuteeFile.Id;
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TuteeFiles", testTuteeFile);
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TuteeFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TuteeFile = await response.Content.ReadFromJsonAsync<TuteeFile>();
    //
    //     Assert.NotNull(TuteeFile);
    //     if (TuteeFile != null)
    //     {
    //         Assert.Equal(testTuteeFile.Id, TuteeFile.Id);
    //         Assert.Equal(testTuteeFile.TuteeImage, TuteeFile.TuteeImage);
    //         Assert.Equal(testTuteeFile.TuteeTranscript, TuteeFile.TuteeTranscript);
    //         
    //     }
    // }

}