namespace AuthorizationServer.Models.CfgDb;

public class ScopeDef
{
    public ScopeDef(string name, bool required, List<ScopeDef>? children)
    {
        ArgumentException.ThrowIfNullOrEmpty(name);
        Name = name;
        Required = required;
        Children = children ?? [];
    }

    public string Name { get; set; }
    public bool Required { get; set; }
    public List<ScopeDef> Children { get; set; }
}
