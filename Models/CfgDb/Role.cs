namespace AuthorizationServer.Models.CfgDb;

/// <summary>
/// Defines a role associated with an application
/// </summary>
public class Role
{
    /// <summary>
    /// Initializes a new instance of the <see cref="Role"/> class.
    /// </summary>
    /// <param name="id">The unique identifier of the role</param>
    /// <param name="applicationId">The identifier of the associated application</param>
    /// <param name="name">The name of the role</param>
    /// <param name="description">A description of the role</param>
    /// <param name="actions">A list of actions associated with the role</param>
    /// <param name="noActions">A list of actions explicitly excluded from the role</param>
    /// <param name="dataActions">A list of data actions associated with the role</param>
    /// <param name="noDataActions">A list of data actions explicitly excluded from the role</param>
    public Role(string id, string applicationId, string name, string description,
        List<string>? actions = null, List<string>? noActions = null, List<string>? dataActions = null, List<string>? noDataActions = null)
    {
        ArgumentException.ThrowIfNullOrEmpty(id);
        ArgumentException.ThrowIfNullOrEmpty(applicationId);
        ArgumentException.ThrowIfNullOrEmpty(name);
        ArgumentException.ThrowIfNullOrEmpty(description);
        Id = id;
        ApplicationId = applicationId;
        Name = name;
        Description = description;
        Actions = actions ?? [];
        NoActions = noActions ?? [];
        DataActions = dataActions ?? [];
        NoDataActions = noDataActions ?? [];
    }

    public string Id { get; }
    public string ApplicationId { get; }
    public string Name { get; set; }
    public string Description { get; set; }
    public List<string> Actions { get; set; }
    public List<string> NoActions { get; set; }
    public List<string> DataActions { get; set; }
    public List<string> NoDataActions { get; set; }
    public bool IsDeleted { get; set; } = false;
}
