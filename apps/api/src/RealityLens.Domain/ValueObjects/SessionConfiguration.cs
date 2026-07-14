using System.Collections.Generic;
using RealityLens.Domain.Common;

namespace RealityLens.Domain.ValueObjects;

public class SessionConfiguration : ValueObject
{
    public int? TimeLimitMinutes { get; private set; }
    public bool RandomQuestionOrder { get; private set; }
    public bool AllowRetry { get; private set; }
    public bool ShowImmediateFeedback { get; private set; }
    public bool LeaderboardEnabled { get; private set; }
    public bool CanvasRequired { get; private set; }
    public int? MaximumAttempts { get; private set; }
    public bool AutoAdvance { get; private set; }

    private SessionConfiguration() { } // Required for EF Core serialization

    public SessionConfiguration(
        int? timeLimitMinutes, 
        bool randomQuestionOrder, 
        bool allowRetry, 
        bool showImmediateFeedback, 
        bool leaderboardEnabled, 
        bool canvasRequired, 
        int? maximumAttempts,
        bool autoAdvance = false)
    {
        TimeLimitMinutes = timeLimitMinutes;
        RandomQuestionOrder = randomQuestionOrder;
        AllowRetry = allowRetry;
        ShowImmediateFeedback = showImmediateFeedback;
        LeaderboardEnabled = leaderboardEnabled;
        CanvasRequired = canvasRequired;
        MaximumAttempts = maximumAttempts;
        AutoAdvance = autoAdvance;
    }

    protected override IEnumerable<object?> GetEqualityComponents()
    {
        yield return TimeLimitMinutes;
        yield return RandomQuestionOrder;
        yield return AllowRetry;
        yield return ShowImmediateFeedback;
        yield return LeaderboardEnabled;
        yield return CanvasRequired;
        yield return MaximumAttempts;
        yield return AutoAdvance;
    }
}
