using FluentValidation;

namespace AuthorizationServer.Server;

internal static class ErrorCodes
{
    internal const int InvalidApplicationName = 0x00010001;
    internal const int MissingApplicationScopeDef = 0x00010002;
    internal const int InvalidAttributeName = 0x00020001;
    internal const int InvalidAttributeType = 0x00020002;
    internal const int InvalidProcessingStyle = 0x00020003;

    internal static IRuleBuilderOptions<T, TProperty> WithAppErrorCode<T, TProperty>(this IRuleBuilderOptions<T, TProperty> rule, int errorCode)
    {
        return rule.WithErrorCode($"0x{errorCode:X}");
    }

    internal static string GetErrorMessage(string errorCode)
    {
        try
        {
            return ErrorMessages.ResourceManager.GetString($"_{errorCode}");
        }
        catch
        {
            return "Unknown error";
        }
    }
}
