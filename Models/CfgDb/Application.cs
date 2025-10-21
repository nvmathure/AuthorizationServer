namespace AuthorizationServer.Models.CfgDb;

public class Application
{
    public string Id { get; set; }

    public string Name { get; set; }

    public List<AttributeDef> Attributes { get; set; }

    public ScopeDef ScopeDef { get; set; } 

    public ScopeDef ScopeKeys { get; set; }

    public List<string> Actions { get; set; }
    
    public bool IsDeleted { get; set; } = false;
}
