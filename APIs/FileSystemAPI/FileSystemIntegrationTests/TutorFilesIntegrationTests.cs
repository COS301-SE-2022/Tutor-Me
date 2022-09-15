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

public class TutorFileFilesIntegrationTests :IClassFixture<WebApplicationFactory<Program>>
{
    // private readonly HttpClient _httpClient;
    //
    // public TutorFileFilesIntegrationTests()
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
    // public async Task GetAllTutorFiles_NoTutorFiles()
    // {
    //     //Act
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TutorFiles");
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TutorFiles = await response.Content.ReadFromJsonAsync<List<TutorFile>>();// ReadAsAsync<List<TutorFile>>();
    //
    //     Assert.Equal(0, TutorFiles.Count());
    // }
    //
    // [Fact]
    // public async Task GetAllTutorFiles_TutorFiles()
    // {
    //     //Arrange
    //     var testTutorFile = new TutorFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTutorFile2 = new TutorFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTutorFile3 = new TutorFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile2);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile3);
    //
    //     //Act
    //     var response = await _httpClient.GetAsync("http://localhost:7062/api/TutorFiles");
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var tutorFiles = await response.Content.ReadFromJsonAsync<List<TutorFile>>();
    //     Assert.NotNull(tutorFiles);
    //     Assert.Equal(3, tutorFiles.Count());
    // }
    //
    // [Fact]
    // public async Task GetTutorFileById_NoTutorFile()
    // {
    //     //Act
    //     Guid id = Guid.NewGuid();
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TutorFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(404, (double)response.StatusCode);
    // }
    // [Fact]
    // public async Task GetTutorFileById_TutorFileFound()
    // { 
    //     //Arrange
    //     var testTutorFile = new TutorFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTutorFile2 = new TutorFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTutorFile3 = new TutorFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile2);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile3);
    //
    //     //Act
    //     var id = testTutorFile.Id;
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TutorFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TutorFile = await response.Content.ReadFromJsonAsync<TutorFile>();
    //
    //     Assert.NotNull(TutorFile);
    //     if (TutorFile != null)
    //     {
    //         Assert.Equal(testTutorFile.Id, TutorFile.Id);
    //         Assert.Equal(testTutorFile.TutorImage, TutorFile.TutorImage);
    //         Assert.Equal(testTutorFile.TutorTranscript, TutorFile.TutorTranscript);
    //        
    //     }
    // }
    //
    // [Fact]
    // public async Task GetTutorFileById_TutorFileNotFound() 
    // {
    //     //Arrange
    //     var testTutorFile = new TutorFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTutorFile2 = new TutorFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //     var testTutorFile3 = new TutorFile()
    //     {
    //
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //
    //     };
    //
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile2);
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile3);
    //
    //     //Act
    //     var id = Guid.NewGuid();//TutorFile that does not exist
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TutorFiles/"+id);
    //     
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(404, (double)response.StatusCode);
    // }
    // [Fact]
    // public async Task GetTutorFileByEmail_NoTutorFile()
    // {
    //     //Act
    //     Guid id = Guid.NewGuid();
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TutorFiles/email/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(404, (double)response.StatusCode);
    // }
    //
    //
    //   [Fact]
    // public async Task ModifiesTutorFileFromDatabase()
    // {
    //     //Arrange
    //     var testTutorFile = new TutorFile()
    //     {
    //        
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //         
    //     };
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile);
    //     
    //     //Act
    //     
    //     //Modify the Tutors Image
    //     testTutorFile.TutorImage =Guid.NewGuid().ToByteArray();
    //     
    //     
    //     var stringContent =new StringContent(testTutorFile.ToJson(), Encoding.UTF8, "application/json");
    //     var response1= await _httpClient.PutAsync("https://localhost:7062/api/TutorFiles/" + testTutorFile.Id,stringContent );
    //     //Assert
    //     Assert.NotNull(response1);
    //     Assert.Equal(204, (double)response1.StatusCode); 
    //
    //     
    //     //Now checking if the Image was actually Modified on the database 
    //     var id = testTutorFile.Id;
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TutorFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TutorFile = await response.Content.ReadFromJsonAsync<TutorFile>();
    //
    //     Assert.NotNull(TutorFile);
    //     if (TutorFile != null)
    //     {
    //         Assert.Equal(testTutorFile.Id, TutorFile.Id);
    //         Assert.Equal(testTutorFile.TutorImage, TutorFile.TutorImage);
    //         
    //     }
    //
    // }
    // [Fact]
    // public async Task AddTutorFile()
    // {
    //     var testTutorFile = new TutorFile()
    //     {
    //         Id = Guid.NewGuid(),
    //         TutorImage=Guid.NewGuid().ToByteArray(),
    //         TutorTranscript =Guid.NewGuid().ToByteArray()
    //     };
    //
    //     //Act
    //     var id = testTutorFile.Id;
    //     await _httpClient.PostAsJsonAsync("https://localhost:7062/api/TutorFiles", testTutorFile);
    //     var response = await _httpClient.GetAsync("https://localhost:7062/api/TutorFiles/"+id);
    //
    //     //Assert
    //     Assert.NotNull(response);
    //     Assert.Equal(200, (double)response.StatusCode);
    //
    //     var TutorFile = await response.Content.ReadFromJsonAsync<TutorFile>();
    //
    //     Assert.NotNull(TutorFile);
    //     if (TutorFile != null)
    //     {
    //         Assert.Equal(testTutorFile.Id, TutorFile.Id);
    //         Assert.Equal(testTutorFile.TutorImage, TutorFile.TutorImage);
    //         Assert.Equal(testTutorFile.TutorTranscript, TutorFile.TutorTranscript);
    //         
    //     }
    // }

}