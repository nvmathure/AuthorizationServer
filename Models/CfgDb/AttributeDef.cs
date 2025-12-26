using AuthorizationServer.Models.Shared;

namespace AuthorizationServer.Models.CfgDb;

/// <summary>
/// Defines an attribute associated with an application
/// </summary>
public class AttributeDef
{
    /// <summary>
    /// Initializes a new instance of the <see cref="AttributeDef"/> class.
    /// </summary>
    /// <param name="name">Name of the attribute</param>
    /// <param name="type">Type of the attribute</param>
    /// <param name="processingStyle">Processing style of the attribute</param>
    /// <exception cref="ArgumentException">When <paramref name="name"/> is null or empty</exception>
    public AttributeDef(string name, AttributeTypes type, ProcessingStyles processingStyle)
    {
        ArgumentException.ThrowIfNullOrEmpty(name);
        Name = name;
        Type = type;
        ProcessingStyle = processingStyle;
    }

    /// <summary>
    /// Gets or sets the name of the attribute
    /// </summary>
    public string Name { get; }

    /// <summary>
    /// Gets or sets the type of the attribute
    /// </summary>
    public AttributeTypes Type { get; }

    /// <summary>
    /// Gets or sets the processing style of the attribute
    /// </summary>
    public ProcessingStyles ProcessingStyle { get; }
}
