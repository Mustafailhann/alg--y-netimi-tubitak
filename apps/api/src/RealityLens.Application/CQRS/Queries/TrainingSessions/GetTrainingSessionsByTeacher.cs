using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;

using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record TrainingSessionDto(Guid Id, Guid TrainingPackId, string JoinCode, TrainingSessionStatus Status, int ParticipantCount, DateTime CreatedAt);

public record GetTrainingSessionsByTeacherQuery(Guid TeacherId) : IQuery<IEnumerable<TrainingSessionDto>>;

public class GetTrainingSessionsByTeacherQueryHandler : IQueryHandler<GetTrainingSessionsByTeacherQuery, IEnumerable<TrainingSessionDto>>
{
    private readonly IApplicationDbContext _context;

    public GetTrainingSessionsByTeacherQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<TrainingSessionDto>> HandleAsync(GetTrainingSessionsByTeacherQuery query, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingSessions
            .AsNoTracking()
            .Where(x => x.CreatedBy == query.TeacherId)
            .Select(x => new TrainingSessionDto(x.Id, x.TrainingPackId, x.JoinCode.Value, x.Status, x.ParticipantCount, x.CreatedAt))
            .ToListAsync(cancellationToken);
    }
}
