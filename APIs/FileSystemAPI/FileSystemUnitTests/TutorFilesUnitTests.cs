//using System.Reflection;
//using FileSystem.Controllers;
//using FileSystem.Data;
//using FileSystem.Models;
//using Microsoft.AspNetCore.Mvc;
//using Microsoft.EntityFrameworkCore;
//using Microsoft.EntityFrameworkCore.ChangeTracking;
//using Moq;

//namespace FileSystemUnitTests;

//public class TutorFileFilesUnitTests
//{
//    //DTO
//    private static TutorFile createTutorFile()
//    {
//        return new()
//        {
//            Id = Guid.NewGuid(),
//            TutorImage=Guid.NewGuid().ToByteArray(),
//            TutorTranscript =Guid.NewGuid().ToByteArray()
//        };
//    }
//    [Fact]
//    public async Task GetTutorFileAsync_WithUnexistingTutorFile_ReturnsNotFound()
//    {
//        //Arranage

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.FindAsync(It.IsAny<Type>())).ReturnsAsync((TutorFile)null);
//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act
//        var result = await controller.GetTutorFile(Guid.NewGuid());
//        //Assert
//        Assert.IsType<NotFoundResult>(result.Result);
//    }

//    [Fact]
//    public async Task GetTutorFileAsync_WithUnExistingDb_ReturnsFound()
//    {
//        //Arranage
//        var expectedTutorFile = createTutorFile();
//        // id = Guid.NewGuid();
    
//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutorFile));
//        var controller = new TutorFilesController(repositoryStub.Object);
    
//        //Act
//        Guid yourGuid = Guid.NewGuid();
//        var result = await controller.GetTutorFile(yourGuid);
    
//        //Assert 
//    //   result.Value.Should().BeEquivalentTo(expectedTutorFile, options => options.CompatingByMembers<TutorFile>());
//       result.Value.Equals(expectedTutorFile);
      
//    }
//    [Fact]
//    public async Task GetTutorFileAsync_WithanEmpyDb()
//    {
//        //Arranage
//        var repositoryStub = new Mock<FilesContext>();
//        //setup repositorystub to null
//        repositoryStub.Setup(repo => repo.TutorFiles).Returns((DbSet<TutorFile>)null);

//        //Act
//        var controller = new TutorFilesController(repositoryStub.Object);

//        var result = await controller.GetTutorFile(new Guid());

//        //Assert     
//        Assert.IsType<NotFoundResult>(result.Result);
//    }
//    //  GetTutorFile
//    [Fact]
//    public async Task GetTutorFilesAsync_WithExistingItem_ReturnsNull()
//    {
//        //Arranage
//        var repositoryStub = new Mock<FilesContext>();
//        var controller = new TutorFilesController(repositoryStub.Object);


//        //Act

//        var result = await controller.GetTutorFiles();

//        //Assert     
//        Assert.Null(result.Value);

//    }
//    //  Mock the GetTutorFile Method to return a list of TutorFile
//    [Fact]
//    public async Task GetTutorFilesAsync_WithExistingItemReturnsFound()
//    {
//        //Arranage
//        var repositoryStub = new Mock<FilesContext>();
//        //setup repositorystub to null
//        repositoryStub.Setup(repo => repo.TutorFiles).Returns((DbSet<TutorFile>)null);

//        //Act
//        var controller = new TutorFilesController(repositoryStub.Object);

//        var result = await controller.GetTutorFiles();

//        //Assert     
//        Assert.IsType<NotFoundResult>(result.Result);
//    }
  
  
//    //Test the PutTutorFile Method to check if id is the same as the id in the DTO
//    [Fact]
//    public async Task PutTutorFile_With_differentIds_BadRequestResult()
//    {
//        //Arranage
//        var repositoryStub = new Mock<FilesContext>();
//        //setup repositorystub to null
//        var expectedTutorFile = createTutorFile();
//        //Act
//        var controller = new TutorFilesController(repositoryStub.Object);
//        var id = Guid.NewGuid();
//        var email = Guid.NewGuid().ToString();
//        var result = await controller.PutTutorFile(id, expectedTutorFile);

//        //Assert     
//        Assert.IsType<BadRequestResult>(result);
//    }

//    [Fact]
//    public async Task PutTutorFile_With_same_Id_but_UnExisting_TutorFile_returns_NullReferenceException()//####
//    {
//        //Arranage
//        var repositoryStub = new Mock<FilesContext>();
//        //setup repositorystub to null
//        var expectedTutorFile = createTutorFile();
//        //repositoryStub.Setup(repo => repo.TutorFile.Find(expectedTutorFile.Id).Equals(expectedTutorFile.Id)).Returns(false);
//        repositoryStub.Setup(repo => repo.TutorFiles).Returns((DbSet<TutorFile>)null);
//        //Act
//        var controller = new TutorFilesController(repositoryStub.Object);
//        var id = Guid.NewGuid();
//        var email = Guid.NewGuid().ToString();
//        try
//        {
//            var result = await controller.PutTutorFile(expectedTutorFile.Id, expectedTutorFile);
//        }
//        //Assert   
//        catch (Exception e)
//        {
//            Assert.IsType<NullReferenceException>(e);
//        }

//    }
//    [Fact]
//    public async Task PutTutorFile_WithUnExistingId_NotFound()
//    {
//        //Arranage
//        var repositoryStub = new Mock<FilesContext>();
//        //setup repositorystub to null
//        var expectedTutorFile = createTutorFile();
//        //Act
//        var controller = new TutorFilesController(repositoryStub.Object);
//        var id = Guid.NewGuid();
//        var result = await controller.PutTutorFile(id, expectedTutorFile);

//        //Assert     
//        Assert.IsType<BadRequestResult>(result);
//    }
//    [Fact]
//    public void ModifiesTutorFile_Returns_NotFoundResult()
//    {
//        DbContextOptionsBuilder<FilesContext> optionsBuilder = new();
//        var databaseName = MethodBase.GetCurrentMethod()?.Name;
//        if (databaseName != null)
//            optionsBuilder.UseInMemoryDatabase(databaseName);
    
//        var newTutorFile = createTutorFile();
//        using (FilesContext ctx = new(optionsBuilder.Options))
//        {
//            ctx.Add(newTutorFile);
//            ctx.SaveChangesAsync();
//        }
    
//        //Modify the tutors Bio
//        newTutorFile.TutorImage = Guid.NewGuid().ToByteArray();
//        var id = Guid.NewGuid();
//        var unExsistingTutorFile = createTutorFile();
//        unExsistingTutorFile.Id = id;
//        Task<IActionResult>  result;
//        using (FilesContext ctx1 = new(optionsBuilder.Options))
//        {
//            result =new TutorFilesController(ctx1).PutTutorFile(unExsistingTutorFile.Id,unExsistingTutorFile);
//        }
    
//        // result should be of type NotFoundResult
//        Assert.IsType<NotFoundResult>(result.Result);
        
       
//    }




//    [Fact]
//    public async Task PostTutorFile_and_returns_a_type_of_Action_Result_returns_null()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTutorFile));
//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act

//        var result = await controller.PostTutorFile(expectedTutorFile);
//        // Assert
//        Assert.IsType<ActionResult<FileSystem.Models.TutorFile>>(result);

//    }
//    [Fact]
//    public async Task PostTutorFile_and_returns_a_type_of_Action()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((TutorFile)null);
//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act

//        var result = await controller.PostTutorFile(expectedTutorFile);
//        // Assert
//        // Assert.IsType<ActionResult<Api.Models.TutorFile>>(result);
//        Assert.Null(result.Value);
//    }
//    [Fact]
//    public async Task PostTutorFile_and_returns_ObjectResult()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles).Returns((DbSet<TutorFile>)null);

//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act

//        var result = await controller.PostTutorFile(expectedTutorFile);
//        // Assert
//        Assert.IsType<ObjectResult>(result.Result);
//    }
//    [Fact]
//    public async Task PostTutorFile_and_returns_CreatedAtActionResult()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.Add(expectedTutorFile)).Returns((Func<EntityEntry<TutorFile>>)null);

//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act

//        var result = await controller.PostTutorFile(expectedTutorFile);
//        // Assert
//        // Assert.IsType<ActionResult<Api.Models.TutorFile>>(result);
//        Assert.IsType<CreatedAtActionResult>(result.Result);
//    }
//    [Fact]
//    public async Task PostTutorFile_and_returns_TutorFileExists_DbUpdateException()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.Add(expectedTutorFile)).Throws<DbUpdateException>();

//        //repositoryStub.Setup(repo => repo.TutorFile.Update(expectedTutorFile)).Throws< DbUpdateException>();

//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act
//        try
//        {
//            var result = await controller.PostTutorFile(expectedTutorFile);
//        }
//        // Assert
//        catch (Exception e)
//        {
//            Assert.IsType<DbUpdateException>(e);
//        }

//    }

//    [Fact]
//    public async Task DeleteTutorFile_and_returns_a_type_of_NotFoundResult()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((TutorFile)null);
//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act
//        var result = await controller.DeleteTutorFile(expectedTutorFile.Id);
//        // Assert
//        Assert.IsType<NotFoundResult>(result);
//    }
//    // Mock the DeleteTutorFile method  and return a Value 
//    [Fact]
//    public async Task DeleteTutorFile_and_returns_a_type_of_NoContentResult()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedTutorFile);
//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act

//        var result = await controller.DeleteTutorFile(expectedTutorFile.Id);
//        // Assert
//        Assert.IsType<NoContentResult>(result);
//    }
//    [Fact]
//    public async Task DeleteTutorFile_and_returns_a_type_of_NotFound()
//    {

//        //Arranage
//        var expectedTutorFile = createTutorFile();

//        var repositoryStub = new Mock<FilesContext>();
//        repositoryStub.Setup(repo => repo.TutorFiles).Returns((DbSet<TutorFile>)null);
//        var controller = new TutorFilesController(repositoryStub.Object);

//        //Act

//        var result = await controller.DeleteTutorFile(expectedTutorFile.Id);
//        // Assert
//        Assert.IsType<NotFoundResult>(result);
//    }


//}