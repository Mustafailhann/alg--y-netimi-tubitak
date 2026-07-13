using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Queries.TrainingLibrary;
using RealityLens.Domain.Entities;
using RealityLens.Persistence;
using Xunit;

namespace RealityLens.Application.Tests.CQRS.Queries.TrainingLibrary;

public class SearchLibraryItemsQueryHandlerTests
{
    private RealityLensDbContext GetDbContext()
    {
        var options = new DbContextOptionsBuilder<RealityLensDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        
        return new RealityLensDbContext(options);
    }

    [Fact]
    public async Task HandleAsync_FiltersByKeyword_ReturnsMatchingItems()
    {
        // Arrange
        using var context = GetDbContext();
        var teacherId = Guid.NewGuid();
        
        var media1 = new Media("Brain MRI.dcm", "application/dicom", ".dcm", 1024, "path", "checksum", teacherId);
        var assessment1 = new Assessment(media1.Id, "Identify the tumor");
        var gt1 = new RealityLens.Domain.Entities.GroundTruth(assessment1.Id, RealityLens.Domain.Enums.Judgment.Real, null, "test"); typeof(RealityLens.Domain.Entities.Assessment).GetProperty("GroundTruth").SetValue(assessment1, gt1); assessment1.MarkAsReady();
        assessment1.Publish();

        var media2 = new Media("Lung CT.dcm", "application/dicom", ".dcm", 1024, "path", "checksum", teacherId);
        var assessment2 = new Assessment(media2.Id, "Find the nodule");
        var gt2 = new RealityLens.Domain.Entities.GroundTruth(assessment2.Id, RealityLens.Domain.Enums.Judgment.Real, null, "test"); typeof(RealityLens.Domain.Entities.Assessment).GetProperty("GroundTruth").SetValue(assessment2, gt2); assessment2.MarkAsReady();
        assessment2.Publish();

        context.Media.AddRange(media1, media2);
        context.Assessments.AddRange(assessment1, assessment2);
        await context.SaveChangesAsync();

        var handler = new SearchLibraryItemsQueryHandler(context);
        var query = new SearchLibraryItemsQuery("tumor", null, null, null, null, null, null);

        // Act
        var result = await handler.HandleAsync(query, CancellationToken.None);

        // Assert
        result.Should().HaveCount(1);
        result.First().Id.Should().Be(assessment1.Id);
    }
}
