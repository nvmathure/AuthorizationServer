namespace AuthorizationServer.Models.CfgDb;

public class Assignment
{
    public Assignment(string id, string applicationId, string roleName, string scopeId, string identityKey, DateTime effective, DateTime? expiration)
    {
        ArgumentException.ThrowIfNullOrEmpty(id);
        ArgumentException.ThrowIfNullOrEmpty(applicationId);
        ArgumentException.ThrowIfNullOrEmpty(roleName);
        ArgumentException.ThrowIfNullOrEmpty(scopeId);
        ArgumentException.ThrowIfNullOrEmpty(identityKey);
        if (effective == default)
            throw new ArgumentException("Effective date must be set", nameof(effective));
        Id = id;
        ApplicationId = applicationId;
        RoleName = roleName;
        ScopeId = scopeId;
        IdentityKey = identityKey;
        Effective = effective;
        Expiration = expiration;
    }

    public string Id { get; set; }
    public string ApplicationId { get; set; }
    public string RoleName { get; set; }
    public string ScopeId { get; set; }
    public string IdentityKey { get; set; }
    public DateTime Effective { get; set; }
    public DateTime? Expiration { get; set; }
}
