using FluentValidation;

namespace AuthorizationServer.Server.Models;

public class CreateApplicationRequest
{
    public string? Name { get; }

    public string[]? Actions { get; }

    public List<AttributeDefinition>? Attributes { get; }

    public ScopeDefinition? ScopeDef { get; }

    public async Task Validate()
    {
        var validator = new Validator();
        await validator.ValidateAndThrowAsync(this);
    }

    public async Task<Application> ToApplication()
    {
        await Validate();

        var scopeDef = await ScopeDef!.ToScopeDef();

        return new Application(
            id: Guid.NewGuid().ToString(),
            name: Name!,
            scopeDef: scopeDef,
            attributes: Attributes?.Select(a => a.ToAttributeDef()).ToList() ?? [],
            actions: Actions?.ToList() ?? []
        );  
    }

    public class Validator : AbstractValidator<CreateApplicationRequest>
    {
        public Validator()
        {
            RuleFor(x => x.Name).Matches("^[A-Z][a-z]*(?:\\ [A-Z][a-z]*)*$").WithAppErrorCode(ErrorCodes.InvalidApplicationName);
            RuleFor(x => x.ScopeDef).NotNull().WithAppErrorCode(ErrorCodes.MissingApplicationScopeDef);
            RuleForEach(x => x.Attributes).SetValidator(new AttributeDefinition.Validator());
            RuleFor(x => x.ScopeDef).SetValidator(new ScopeDefinition.Validator());
        }
    }
}