using System.Reflection;
using FileSystem.Controllers;
using FileSystem.Data;
using FileSystem.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Options;
using Moq;

public class TuteeFilesUnitTests
{
    
      List<TuteeFile> _expectedTuteeFile = new List<TuteeFile> { createTuteeFile(), createTuteeFile(), createTuteeFile(), createTuteeFile() };

    //DTO
    private static TuteeFile createTuteeFile()
    {
        return new()
        {
            Id = Guid.NewGuid(),
            TuteeImage=Guid.NewGuid().ToByteArray(),
            TuteeTranscript =Guid.NewGuid().ToByteArray()
        };
    }
    [Fact]
    public async Task GetTuteeFileAsync_WithUnexistingTuteeFile_ReturnsNotFound()
    {
        //Arranage

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.FindAsync(It.IsAny<Type>())).ReturnsAsync((TuteeFile)null);
        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act
        var result = await controller.GetTuteeFile(Guid.NewGuid());
        //Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task GetTuteeFileAsync_WithUnExistingDb_ReturnsFound()
    {
        //Arranage
        var expectedTuteeFile = createTuteeFile();
        // id = Guid.NewGuid();
    
        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTuteeFile));
        var controller = new TuteeFilesController(repositoryStub.Object);
    
        //Act
        Guid yourGuid = Guid.NewGuid();
        var result = await controller.GetTuteeFile(yourGuid);
    
        //Assert 
    //   result.Value.Should().BeEquivalentTo(expectedTuteeFile, options => options.CompatingByMembers<TuteeFile>());
       result.Value.Equals(expectedTuteeFile);
       // result.Value.Should().BeEquivalentTo(expectedTuteeFile,
       //Verifying all the DTO variables matches the expected TuteeFile 
       //   options => options.ComparingByMembers<TuteeFile>());

    }
    [Fact]
    public async Task GetTuteeFileAsync_WithanEmpyDb()
    {
        //Arranage
        var repositoryStub = new Mock<FilesContext>();
        //setup repositorystub to null
        repositoryStub.Setup(repo => repo.TuteeFiles).Returns((DbSet<TuteeFile>)null);

        //Act
        var controller = new TuteeFilesController(repositoryStub.Object);

        var result = await controller.GetTuteeFile(new Guid());

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
    //  GetTuteeFile
    [Fact]
    public async Task GetTuteeFilesAsync_WithExistingItem_ReturnsNull()
    {
        //Arranage
        var repositoryStub = new Mock<FilesContext>();
        var controller = new TuteeFilesController(repositoryStub.Object);


        //Act

        var result = await controller.GetTuteeFiles();

        //Assert     
        Assert.Null(result.Value);

    }
    //  Mock the GetTuteeFile Method to return a list of TuteeFile
    [Fact]
    public async Task GetTuteeFilesAsync_WithExistingItemReturnsFound()
    {
        //Arranage
        var repositoryStub = new Mock<FilesContext>();
        //setup repositorystub to null
        repositoryStub.Setup(repo => repo.TuteeFiles).Returns((DbSet<TuteeFile>)null);

        //Act
        var controller = new TuteeFilesController(repositoryStub.Object);

        var result = await controller.GetTuteeFiles();

        //Assert     
        Assert.IsType<NotFoundResult>(result.Result);
    }
  
  
    //Test the PutTuteeFile Method to check if id is the same as the id in the DTO
    [Fact]
    public async Task PutTuteeFile_With_differentIds_BadRequestResult()
    {
        //Arranage
        var repositoryStub = new Mock<FilesContext>();
        //setup repositorystub to null
        var expectedTuteeFile = createTuteeFile();
        //Act
        var controller = new TuteeFilesController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var email = Guid.NewGuid().ToString();
        var result = await controller.PutTuteeFile(id, expectedTuteeFile);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public async Task PutTuteeFile_With_same_Id_but_UnExisting_TuteeFile_returns_NullReferenceException()//####
    {
        //Arranage
        var repositoryStub = new Mock<FilesContext>();
        //setup repositorystub to null
        var expectedTuteeFile = createTuteeFile();
        //repositoryStub.Setup(repo => repo.TuteeFile.Find(expectedTuteeFile.Id).Equals(expectedTuteeFile.Id)).Returns(false);
        repositoryStub.Setup(repo => repo.TuteeFiles).Returns((DbSet<TuteeFile>)null);
        //Act
        var controller = new TuteeFilesController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var email = Guid.NewGuid().ToString();
        try
        {
            var result = await controller.PutTuteeFile(expectedTuteeFile.Id, expectedTuteeFile);
        }
        //Assert   
        catch (Exception e)
        {
            Assert.IsType<NullReferenceException>(e);
        }

    }
    [Fact]
    public async Task PutTuteeFile_WithUnExistingId_NotFound()
    {
        //Arranage
        var repositoryStub = new Mock<FilesContext>();
        //setup repositorystub to null
        var expectedTuteeFile = createTuteeFile();
        //Act
        var controller = new TuteeFilesController(repositoryStub.Object);
        var id = Guid.NewGuid();
        var result = await controller.PutTuteeFile(id, expectedTuteeFile);

        //Assert     
        Assert.IsType<BadRequestResult>(result);
    }

    [Fact]
    public void ModifiesTuteeFile_Returns_NotFoundResult()
    {
        DbContextOptionsBuilder<FilesContext> optionsBuilder = new();
        var databaseName = MethodBase.GetCurrentMethod()?.Name;
        if (databaseName != null)
            optionsBuilder.UseInMemoryDatabase(databaseName);
    
        var newTuteeFile = createTuteeFile();
        using (FilesContext ctx = new(optionsBuilder.Options))
        {
            ctx.Add(newTuteeFile);
            ctx.SaveChangesAsync();
        }
    
        //Modify the tutors Bio
        newTuteeFile.TuteeImage = Guid.NewGuid().ToByteArray();
        var id = Guid.NewGuid();
        var unExsistingTuteeFile = createTuteeFile();
        unExsistingTuteeFile.Id = id;
        Task<IActionResult>  result;
        using (FilesContext ctx1 = new(optionsBuilder.Options))
        {
            result =new TuteeFilesController(ctx1).PutTuteeFile(unExsistingTuteeFile.Id,unExsistingTuteeFile);
        }
    
        // result should be of type NotFoundResult
        Assert.IsType<NotFoundResult>(result.Result);
        
       
    }


    [Fact]
    public async Task PostTuteeFile_and_returns_a_type_of_Action_Result_returns_null()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((expectedTuteeFile));
        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act

        var result = await controller.PostTuteeFile(expectedTuteeFile);
        // Assert
        Assert.IsType<ActionResult<FileSystem.Models.TuteeFile>>(result);

    }
    [Fact]
    public async Task PostTuteeFile_and_returns_a_type_of_Action()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((TuteeFile)null);
        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act

        var result = await controller.PostTuteeFile(expectedTuteeFile);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.TuteeFile>>(result);
        Assert.Null(result.Value);
    }
    [Fact]
    public async Task PostTuteeFile_and_returns_ObjectResult()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles).Returns((DbSet<TuteeFile>)null);

        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act

        var result = await controller.PostTuteeFile(expectedTuteeFile);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.TuteeFile>>(result);
        Assert.IsType<ObjectResult>(result.Result);
    }
    [Fact]
    public async Task PostTuteeFile_and_returns_CreatedAtActionResult()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.Add(expectedTuteeFile)).Returns((Func<EntityEntry<TuteeFile>>)null);

        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act

        var result = await controller.PostTuteeFile(expectedTuteeFile);
        // Assert
        // Assert.IsType<ActionResult<Api.Models.TuteeFile>>(result);
        Assert.IsType<CreatedAtActionResult>(result.Result);
    }
    [Fact]
    public async Task PostTuteeFile_and_returns_TuteeFileExists_DbUpdateException()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.Add(expectedTuteeFile)).Throws<DbUpdateException>();

        //repositoryStub.Setup(repo => repo.TuteeFile.Update(expectedTuteeFile)).Throws< DbUpdateException>();

        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act
        try
        {
            var result = await controller.PostTuteeFile(expectedTuteeFile);
        }
        // Assert
        catch (Exception e)
        {
            Assert.IsType<DbUpdateException>(e);
        }

    }

    [Fact]
    public async Task DeleteTuteeFile_and_returns_a_type_of_NotFoundResult()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync((TuteeFile)null);
        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act
        var result = await controller.DeleteTuteeFile(expectedTuteeFile.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
    // Mock the DeleteTuteeFile method  and return a Value 
    [Fact]
    public async Task DeleteTuteeFile_and_returns_a_type_of_NoContentResult()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles.FindAsync(It.IsAny<Guid>())).ReturnsAsync(expectedTuteeFile);
        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteTuteeFile(expectedTuteeFile.Id);
        // Assert
        Assert.IsType<NoContentResult>(result);
    }
    [Fact]
    public async Task DeleteTuteeFile_and_returns_a_type_of_NotFound()
    {

        //Arranage
        var expectedTuteeFile = createTuteeFile();

        var repositoryStub = new Mock<FilesContext>();
        repositoryStub.Setup(repo => repo.TuteeFiles).Returns((DbSet<TuteeFile>)null);
        var controller = new TuteeFilesController(repositoryStub.Object);

        //Act

        var result = await controller.DeleteTuteeFile(expectedTuteeFile.Id);
        // Assert
        Assert.IsType<NotFoundResult>(result);
    }

    
}