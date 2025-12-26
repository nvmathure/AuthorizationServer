namespace AuthorizationServer.Models.CfgDb;

/// <summary>
/// Defines an application in the authorization server
/// </summary>
public class Application
{
    /// <summary>
    /// Initializes a new instance of the <see cref="Application"/> class.
    /// </summary>
    /// <param name="id">ID of the application</param>
    /// <param name="name">Name of the application</param>
    /// <param name="scopeDef">Root scope definition for the application</param>
    /// <param name="attributes">Attributes associated with the application</param>
    /// <param name="actions">List of Actions associated with the application</param>
    /// <exception cref="ArgumentNullException">When <paramref name="scopeDef"/> is null</exception>
    /// <exception cref="ArgumentException">When <paramref name="id"/> or <paramref name="name"/> is null or empty</exception>
    public Application(string id, string name, ScopeDef? scopeDef, List<AttributeDef>? attributes = null, List<string>? actions = null)
    {
        ArgumentException.ThrowIfNullOrEmpty(id);
        ArgumentException.ThrowIfNullOrEmpty(name);
        Id = id;
        Name = name;
        ScopeDef = scopeDef ?? throw new ArgumentNullException(nameof(scopeDef));
        Attributes = attributes ?? [];
        Actions = actions ?? [];
    }

    /// <summary>
    /// Gets or sets the ID of the application
    /// </summary>
    public string Id { get; }

    /// <summary>
    /// Gets or sets the name of the application
    /// </summary>
    public string Name { get; }

    /// <summary>
    /// Gets or sets the attributes associated with the application. E.g. Max Price Match Amount
    /// </summary>
    public List<AttributeDef> Attributes { get; }

    /// <summary>
    /// Gets or sets the root scope definition for the application. E.g Country -> Region -> State -> City etc.
    /// </summary>
    public ScopeDef ScopeDef { get; set; }

    /// <summary>
    /// List of Actions associated with the application
    /// </summary>
    public List<string> Actions { get; }

    /// <summary>
    /// Gets or sets if Application is deleted
    /// </summary>
    public bool IsDeleted { get; set; } = false;
}
