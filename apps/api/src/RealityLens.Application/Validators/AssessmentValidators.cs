using FluentValidation;
using RealityLens.Application.DTOs;

namespace RealityLens.Application.Validators;

public class CreateAssessmentRequestValidator : AbstractValidator<CreateAssessmentRequest>
{
    public CreateAssessmentRequestValidator()
    {
        RuleFor(x => x.MediaId).NotEmpty();
        RuleFor(x => x.Question).NotEmpty().MaximumLength(500);
    }
}

public class UpdateAssessmentRequestValidator : AbstractValidator<UpdateAssessmentRequest>
{
    public UpdateAssessmentRequestValidator()
    {
        RuleFor(x => x.Question).NotEmpty().MaximumLength(500);
    }
}
