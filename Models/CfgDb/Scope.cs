namespace AuthorizationServer.Models.CfgDb;

public class Scope
{
    public Scope(string id, string applicationId, string scopeName, Dictionary<string, string> value, Dictionary<string, string>? properties = null)
    {
        ArgumentException.ThrowIfNullOrEmpty(id);
        ArgumentException.ThrowIfNullOrEmpty(applicationId);
        ArgumentException.ThrowIfNullOrEmpty(scopeName);
        ArgumentNullException.ThrowIfNull(value);
        if (value.Count == 0)
            throw new ArgumentException("Value dictionary cannot be empty", nameof(value));
        Id = id;
        ApplicationId = applicationId;
        ScopeName = scopeName;
        Value = value;
        Properties = properties ?? new();
    }

    public string Id { get; set; }
    public string ApplicationId { get; set; }
    public string ScopeName { get; set; }

    public string ScopeKey { get; set; }

    public Dictionary<string, string> Value { get; set; }
    public Dictionary<string, string> Properties { get; set; }
    public bool IsDeleted { get; set; } = false;
}
