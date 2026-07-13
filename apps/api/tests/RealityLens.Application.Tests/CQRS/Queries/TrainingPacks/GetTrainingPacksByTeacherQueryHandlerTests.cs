using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Queries.TrainingPacks;
using RealityLens.Domain.Entities;
using RealityLens.Persistence;
using Xunit;

namespace RealityLens.Application.Tests.CQRS.Queries.TrainingPacks;

public class GetTrainingPacksByTeacherQueryHandlerTests
{
    private RealityLensDbContext GetDbContext()
    {
        var options = new DbContextOptionsBuilder<RealityLensDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        
        return new RealityLensDbContext(options);
    }

    [Fact]
    public async Task HandleAsync_ReturnsTeacherPacks()
    {
        // Arrange
        using var context = GetDbContext();
        var teacherId1 = Guid.NewGuid();
        var teacherId2 = Guid.NewGuid();

        var pack1 = new TrainingPack(teacherId1, "Pack 1", 60);
        var pack2 = new TrainingPack(teacherId1, "Pack 2", 30);
        var pack3 = new TrainingPack(teacherId2, "Pack 3", 45);

        context.TrainingPacks.AddRange(pack1, pack2, pack3);
        await context.SaveChangesAsync();

        var handler = new GetTrainingPacksByTeacherQueryHandler(context);
        var query = new GetTrainingPacksByTeacherQuery(teacherId1);

        // Act
        var result = await handler.HandleAsync(query, CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result.Should().HaveCount(2);
        result.Select(x => x.Title).Should().Contain(new[] { "Pack 1", "Pack 2" });
        result.Select(x => x.Title).Should().NotContain("Pack 3");
    }
}
