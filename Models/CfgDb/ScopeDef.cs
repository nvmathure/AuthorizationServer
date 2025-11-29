namespace AuthorizationServer.Models.CfgDb;

/// <summary>
/// Defines a scope definition associated with an application
/// </summary>
public class ScopeDef
{
    /// <summary>
    /// Initializes a new instance of the <see cref="ScopeDef"/> class.
    /// </summary>
    /// <param name="name">Name of the scope</param>
    /// <param name="required">Indicates if the scope is required for runtime assertion</param>
    /// <param name="children">Child scopes</param>
    public ScopeDef(string name, bool required, List<ScopeDef>? children)
    {
        ArgumentException.ThrowIfNullOrEmpty(name);
        Name = name;
        Required = required;
        Children = children ?? [];
    }

    /// <summary>
    /// Gets or sets the name of the scope
    /// </summary>
    public string Name { get; }

    /// <summary>
    /// Gets or sets a value indicating whether the scope is required for runtime assertion
    /// </summary>
    public bool Required { get; }

    /// <summary>
    /// Gets or sets the child scopes
    /// </summary>
    public List<ScopeDef> Children { get; }
}
