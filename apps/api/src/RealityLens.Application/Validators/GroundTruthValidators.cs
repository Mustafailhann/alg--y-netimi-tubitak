using FluentValidation;
using RealityLens.Application.DTOs;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.Validators;

public class CreateGroundTruthRequestValidator : AbstractValidator<CreateGroundTruthRequest>
{
    public CreateGroundTruthRequestValidator()
    {
        RuleFor(x => x.Judgment).IsInEnum();
        
        RuleFor(x => x.ManipulationCategoryId)
            .NotEmpty().When(x => x.Judgment == Judgment.Manipulated)
            .WithMessage("ManipulationCategory is required when judgment is Manipulated.");
            
        RuleFor(x => x.ManipulationCategoryId)
            .Empty().When(x => x.Judgment == Judgment.Real)
            .WithMessage("ManipulationCategory must be null when judgment is Real.");
            
        RuleFor(x => x.Reason).NotEmpty();
    }
}

public class UpdateGroundTruthRequestValidator : AbstractValidator<UpdateGroundTruthRequest>
{
    public UpdateGroundTruthRequestValidator()
    {
        RuleFor(x => x.Judgment).IsInEnum();
        
        RuleFor(x => x.ManipulationCategoryId)
            .NotEmpty().When(x => x.Judgment == Judgment.Manipulated)
            .WithMessage("ManipulationCategory is required when judgment is Manipulated.");
            
        RuleFor(x => x.ManipulationCategoryId)
            .Empty().When(x => x.Judgment == Judgment.Real)
            .WithMessage("ManipulationCategory must be null when judgment is Real.");
            
        RuleFor(x => x.Reason).NotEmpty();
    }
}
