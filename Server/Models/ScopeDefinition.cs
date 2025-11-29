using FluentValidation;

namespace AuthorizationServer.Server.Models;

public class ScopeDefinition
{
    public ScopeDefinition(string name, bool? required = null, ScopeDefinition[]? children = null)
    {
        ArgumentException.ThrowIfNullOrEmpty(name);
        Name = name;
        Required = required ?? true;
        Children = children ?? [];
    }

    public string? Code { get; }

    public string? Name { get; }

    public bool? Required { get; }

    public ScopeDefinition[] Children { get; }

    public async Task Validate()
    {
        var validator = new Validator();
        await validator.ValidateAndThrowAsync(this);
    }

    public async Task<ScopeDef> ToScopeDef()
    {
        await Validate();

        return new ScopeDef(
            Name!,
            Required ?? true,
            Children.Select(async c => await c.ToScopeDef()).ToList()
        );
    }

    public class Validator : AbstractValidator<ScopeDefinition>
    {
        public Validator()
        {
            RuleFor(x => x.Name).Matches("^[A-Z][a-z]*(?:\\ [A-Z][a-z]*)*$").WithAppErrorCode(ErrorCodes.InvalidScopeName);
            RuleForEach(x => x.Children).SetValidator(new Validator());
        }
    }
}