using FluentValidation;

namespace AuthorizationServer.Server.Models;

/// <summary>
/// Defines an attribute for an application
/// </summary>
public class AttributeDefinition
{
    /// <summary>
    /// Gets or sets the name of the attribute
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the type of the attribute
    /// </summary>
    public AttributeTypes Type { get; }

    /// <summary>
    /// Gets or sets the processing style of the attribute
    /// </summary>
    public ProcessingStyles ProcessingStyle { get; }

    public AttributeDef ToAttributeDef()
    {
        return new AttributeDef(Name, Type, ProcessingStyle);
    }

    public class Validator : AbstractValidator<AttributeDefinition>
    {
        public Validator()
        {
            RuleFor(x => x.Name).Matches("^[A-Z][a-z]*(?:\\ [A-Z][a-z]*)*$").WithAppErrorCode(ErrorCodes.InvalidAttributeName);
            RuleFor(x => x.Type).IsInEnum().WithAppErrorCode(ErrorCodes.InvalidAttributeType);
            RuleFor(x => x.ProcessingStyle).IsInEnum().WithAppErrorCode(ErrorCodes.InvalidProcessingStyle);
        }
    }
}