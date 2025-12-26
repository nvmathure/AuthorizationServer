namespace AuthorizationServer.Models.Shared;

/// <summary>
/// Defines processing styles for attributes
/// </summary>
public enum ProcessingStyles
{
    /// <summary>
    /// System will calculate Maximum of attributes when defined at multiple scopes
    /// </summary>
    Maximum,

    /// <summary>
    /// System will calculate Minimum of attributes when defined at multiple scopes
    /// </summary>
    Minimum
}
