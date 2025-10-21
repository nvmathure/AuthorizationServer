namespace AuthorizationServer.Models.CfgDb;

public class AttributeDef
{
    public AttributeDef(string name, AttributeTypes type, ProcessingStyles processingStyle)
    {
        ArgumentException.ThrowIfNullOrEmpty(name);
        Name = name;
        Type = type;
        ProcessingStyle = processingStyle;
    }

    public string Name { get; set; } 

    public AttributeTypes Type { get; set; }
    
    public ProcessingStyles ProcessingStyle { get; set; }
}
