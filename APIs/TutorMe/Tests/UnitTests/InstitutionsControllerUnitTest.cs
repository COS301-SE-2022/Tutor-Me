using System.Reflection;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using NuGet.Versioning;
using TutorMe.Controllers;
using TutorMe.Data;
using TutorMe.Models;
using TutorMe.Services;

namespace Tests.UnitTests;

public class InstitutionsControllerUnitTests
{
    private readonly Mock<IInstitutionService> _InstitutionRepositoryMock;
    private static Mock<IMapper> _mapper;

    public InstitutionsControllerUnitTests()
    {
        _InstitutionRepositoryMock = new Mock<IInstitutionService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllInstitutions_ListOfInstitutions_ReturnsListOfInstitutions()
    {
    
        //arrange
        List<Institution> Institutions = new List<Institution>
        {
            new Institution
            {
              
            InstitutionId = Guid.NewGuid(),
            Name ="University Of Pretoria",
             // Faculty 
             Location ="Hatfield"
            },
            new Institution
            {
                InstitutionId = Guid.NewGuid(),
                Name ="University Of Freestate",
                // Faculty 
                Location ="Freestate"
            },
            new Institution
            {
                InstitutionId = Guid.NewGuid(),
                Name ="University Of Johannesburg",
                // Faculty 
                Location ="Johannesburg"
            }
        };
        
        
        _InstitutionRepositoryMock.Setup(u => u.GetAllInstitutions()).Returns(Institutions);

        var controller = new InstitutionsController(_InstitutionRepositoryMock.Object, _mapper.Object);
        var result = controller.GetAllInstitutions();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Institution>>(actual);
        Assert.Equal(3, (actual as List<Institution>).Count);

    }
    
    [Fact]
    public async  Task GetInstitutionById_InstitutionId_ReturnsInstitutionOfId()
    {
        //arrange
        var Institution = new Institution
        {
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
        
        _InstitutionRepositoryMock.Setup(u => u.GetInstitutionById(Institution.InstitutionId)).Returns(Institution);
        
        var controller = new InstitutionsController(_InstitutionRepositoryMock.Object,_mapper.Object);
        
        //act
        var result = controller.GetInstitutionById(Institution.InstitutionId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Institution>(actual);
    }
    
    [Fact]
    public async  Task AddInstitution_Institution_ReturnsInstitution()
    {
        //arrange
        var Institution = new Institution
        {
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
        _InstitutionRepositoryMock.Setup(u => u. createInstitution(It.IsAny<Institution>())).Returns(Institution.InstitutionId);
        
        var controller = new InstitutionsController(_InstitutionRepositoryMock.Object,_mapper.Object);
        
        //act
        var result =  controller.createInstitution(Institution);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }
    
 
    
    [Fact]
    public async Task DeleteInstitutionById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Institution
        {
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
            
        _InstitutionRepositoryMock.Setup(repo => repo.deleteInstitutionById(It.IsAny<Guid>())).Returns(true);
        var controller = new  InstitutionsController(_InstitutionRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteInstitution(expectedTutor.InstitutionId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
    [Fact]
    public async Task DeleteInstitutionById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new Institution
        {
            Name ="University Of Pretoria",
            // Faculty 
            Location ="Hatfield"
        };
            
        _InstitutionRepositoryMock.Setup(repo => repo.deleteInstitutionById(It.IsAny<Guid>())).Returns(false);
        var controller = new  InstitutionsController(_InstitutionRepositoryMock.Object,_mapper.Object);

        //Act
        var result = controller.DeleteInstitution(expectedTutor.InstitutionId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(false, actual);

    }
  
}