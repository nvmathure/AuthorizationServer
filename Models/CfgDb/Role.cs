namespace AuthorizationServer.Models.CfgDb;

public class Role
{
    public Role(string id, string applicationId, string name, string description,
        List<string>? actions = null, List<string>? noActions = null)
    {
        ArgumentException.ThrowIfNullOrEmpty(id);
        ArgumentException.ThrowIfNullOrEmpty(applicationId);
        ArgumentException.ThrowIfNullOrEmpty(name);
        ArgumentException.ThrowIfNullOrEmpty(description);
        Id = id;
        ApplicationId = applicationId;
        Name = name;
        Description = description;
        Actions = actions ?? new();
        NoActions = noActions ?? new();
    }

    public string Id { get; set; }
    public string ApplicationId { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public List<string> Actions { get; set; }
    public List<string> NoActions { get; set; }
    public bool IsDeleted { get; set; } = false;
}
