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

public class BadgesControllerUnitTest
{
    private readonly Mock<IBadgeService> _BadgeRepositoryMock;
    private readonly TutorMeContext _TutorMeContextMock;
    private static Mock<IMapper> _mapper;

    public BadgesControllerUnitTest()
    {
        // _TutorMeContextMock = new Mock<TutorMeContext>();
        _BadgeRepositoryMock = new Mock<IBadgeService>();
        _mapper = new Mock<IMapper>();
    }
    
    [Fact]
    public async Task  GetAllBadges_ListOfBadges_ReturnsListOfBadges()
    {
    
        //arrange
        List<Badge> Badges = new List<Badge>
        {
            new Badge
            { 
                BadgeId = Guid.NewGuid(),
                Name = Guid.NewGuid().ToString(),
                Description = Guid.NewGuid().ToString(),
                Image =Guid.NewGuid().ToString(),
                Points = 10,
                PointsToAchieve = 10
            },
            new Badge
            {
                BadgeId = Guid.NewGuid(),
                Name = Guid.NewGuid().ToString(),
                Description = Guid.NewGuid().ToString(),
                Image =Guid.NewGuid().ToString(),
                Points = 10,
                PointsToAchieve = 10
            },
            new Badge
            {
                BadgeId = Guid.NewGuid(),
                Name = Guid.NewGuid().ToString(),
                Description = Guid.NewGuid().ToString(),
                Image =Guid.NewGuid().ToString(),
                Points = 10,
                PointsToAchieve = 10
            }
        };
        
        
        _BadgeRepositoryMock.Setup(u => u.GetAllBadges()).Returns(Badges);

        var controller = new BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);
        var result = controller.GetAllBadges();


        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
            
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<List<Badge>>(actual);
        Assert.Equal(3, (actual as List<Badge>).Count);

    }
    
    [Fact]
    public async  Task GetBadgeById_BadgeId_ReturnsBadgeOfId()
    {
        //arrange
        var Badge = new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
        
        _BadgeRepositoryMock.Setup(u => u.GetBadgeById(Badge.BadgeId)).Returns(Badge);
        
        var controller = new BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);
        
        //act
        var result = controller.GetBadgeById(Badge.BadgeId);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Badge>(actual);
    }
      
    [Fact]
    public async  Task GetBadgeById_BadgeId_ReturnsBadgeNotFound()
    {
        //arrange
        var Badge = new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
        
        _BadgeRepositoryMock.Setup(u => u.GetBadgeById(Badge.BadgeId)).Throws(new KeyNotFoundException("Badge not found"));
        
        var controller = new BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);
        
        //act
        try
        {
             controller.GetBadgeById(Badge.BadgeId);

        }
        catch (Exception e)
        {
            Assert.IsType<KeyNotFoundException>(e);
            Assert.Equal("Badge not found", e.Message);
        }
        
    }

    [Fact]
    public async  Task AddBadge_Badge_ReturnsBadge()
    {
        //arrange
        var Badge = new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
        _BadgeRepositoryMock.Setup(u => u. createBadge(It.IsAny<Badge>())).Returns(Badge.BadgeId);
        
        var controller = new BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);
        
        //act
        var result =  controller.PostBadge(Badge);
        
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<System.Guid>(actual);
    }
    
 
    
    [Fact]
    public async Task DeleteBadgeById_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.deleteBadgeById(It.IsAny<Guid>())).Returns(true);
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        var result = controller.DeleteBadge(expectedTutor.BadgeId);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result.Result);
        var actual = (result.Result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
    [Fact]
    public async Task DeleteBadgeById_Returns_False()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.deleteBadgeById(It.IsAny<Guid>())).Throws(new KeyNotFoundException("Badge not found"));
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.DeleteBadge(expectedTutor.BadgeId);
        }
        catch (Exception e)
        {
            Assert.Equal("Badge not found", e.Message);
        }
        

    }
    
    // test updateBadgePoints
    [Fact]
    public async Task UpdateBadgePoints_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.updateBadgePoints(It.IsAny<Guid>(),It.IsAny<int>())).Returns(true);
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        var result = controller.updateBadgePoints(expectedTutor.BadgeId,10);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    
    // test updateBadgePoints throws key not found
    [Fact]
    public async Task UpdateBadgePoints_Returns_ThrowsKeyNotFound()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.updateBadgePoints(It.IsAny<Guid>(),It.IsAny<int>())).Throws(new KeyNotFoundException("Badge not found"));
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.updateBadgePoints(expectedTutor.BadgeId,10);
        }
        catch (Exception e)
        {
            Assert.Equal("Badge not found", e.Message);
        }
        

    }
    
    //test updateBadgePointsToAchieve returns true
    [Fact]
    public async Task UpdateBadgePointsToAchieve_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.updateBadgePointsToAchieve(It.IsAny<Guid>(),It.IsAny<int>())).Returns(true);
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        var result = controller.updateBadgePointsToAchieve(expectedTutor.BadgeId,10);
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    //test updateBadgePointsToAchieve returns false
    [Fact]
    public async Task UpdateBadgePointsToAchieve_Returns_ThrowsKeyNotFound()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.updateBadgePointsToAchieve(It.IsAny<Guid>(),It.IsAny<int>())).Throws(new KeyNotFoundException("Badge not found"));
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.updateBadgePointsToAchieve(expectedTutor.BadgeId,10);
        }
        catch (Exception e)
        {
            Assert.Equal("Badge not found", e.Message);
        }
        

    }
    
    //test updateBadgeName returns true
    [Fact]
    public async Task UpdateBadgeName_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.updateBadgeName(It.IsAny<Guid>(),It.IsAny<string>())).Returns(true);
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        var result = controller.updateBadgeName(expectedTutor.BadgeId,"New Name");
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    //test updateBadgeName_Returns_ThrowsKeyNotFound()
    [Fact]
    public async Task UpdateBadgeName_Returns_ThrowsKeyNotFound()
    {

        //Arrange
        var expectedTutor = new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image = Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };

        _BadgeRepositoryMock.Setup(repo => repo.updateBadgeName(It.IsAny<Guid>(), It.IsAny<string>()))
            .Throws(new KeyNotFoundException("Badge not found"));
        var controller = new BadgesController(_TutorMeContextMock, _BadgeRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.updateBadgeName(expectedTutor.BadgeId, "New Name");
        }
        catch (Exception e)
        {
            Assert.Equal("Badge not found", e.Message);
        }
    }

    //test updateBadgeDescription return true
    [Fact]
    public async Task UpdateBadgeDescription_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.updateBadgeDescription(It.IsAny<Guid>(),It.IsAny<string>())).Returns(true);
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        var result = controller.updateBadgeDescription(expectedTutor.BadgeId,"New Description");
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    //test updateBadgeDescription_Returns_ThrowsKeyNotFound()
    [Fact]
    public async Task UpdateBadgeDescription_Returns_ThrowsKeyNotFound()
    {

        //Arrange
        var expectedTutor = new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image = Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };

        _BadgeRepositoryMock.Setup(repo => repo.updateBadgeDescription(It.IsAny<Guid>(), It.IsAny<string>()))
            .Throws(new KeyNotFoundException("Badge not found"));
        var controller = new BadgesController(_TutorMeContextMock, _BadgeRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.updateBadgeDescription(expectedTutor.BadgeId, "New Description");
        }
        catch (Exception e)
        {
            Assert.Equal("Badge not found", e.Message);
        }
    }
    
    //test updateBadgeImage return true
    [Fact]
    public async Task UpdateBadgeImage_Returns_true()
    {

        //Arrange
        var expectedTutor =  new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image =Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };
            
        _BadgeRepositoryMock.Setup(repo => repo.updateBadgeImage(It.IsAny<Guid>(),It.IsAny<string>())).Returns(true);
        var controller = new  BadgesController(_TutorMeContextMock,_BadgeRepositoryMock.Object);

        //Act
        var result = controller.updateBadgeImage(expectedTutor.BadgeId,"New Image");
        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        var actual = (result as OkObjectResult).Value;
        Assert.IsType<Boolean>(actual);
        Assert.Equal(true, actual);

    }
    //test updateBadgeImage_Returns_ThrowsKeyNotFound()
    [Fact]
    public async Task UpdateBadgeImage_Returns_ThrowsKeyNotFound()
    {

        //Arrange
        var expectedTutor = new Badge
        {
            BadgeId = Guid.NewGuid(),
            Name = Guid.NewGuid().ToString(),
            Description = Guid.NewGuid().ToString(),
            Image = Guid.NewGuid().ToString(),
            Points = 10,
            PointsToAchieve = 10
        };

        _BadgeRepositoryMock.Setup(repo => repo.updateBadgeImage(It.IsAny<Guid>(), It.IsAny<string>()))
            .Throws(new KeyNotFoundException("Badge not found"));
        var controller = new BadgesController(_TutorMeContextMock, _BadgeRepositoryMock.Object);

        //Act
        try
        {
            var result = controller.updateBadgeImage(expectedTutor.BadgeId, "New Image");
        }
        catch (Exception e)
        {
            Assert.Equal("Badge not found", e.Message);
        }
    }


}