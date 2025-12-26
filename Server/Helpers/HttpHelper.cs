using Microsoft.Azure.Functions.Worker.Http;
using Newtonsoft.Json;
using System.Text;

namespace AuthorizationServer.Server.Helpers;

public static class HttpHelper
{
    public static async Task<TRequestBody> ToObject<TRequestBody>(this HttpRequestData request)
    {
        if (request == null)
            throw new ArgumentNullException(nameof(request));

        string requestBody;
        using (var reader = new StreamReader(request.Body, Encoding.UTF8))
        {
            requestBody = await reader.ReadToEndAsync();
        }

        if (string.IsNullOrEmpty(requestBody))
            throw new ArgumentException("Request body cannot be empty", nameof(request));

        var returnValue = JsonConvert.DeserializeObject<TRequestBody>(requestBody) ?? throw new InvalidOperationException("Failed to deserialize request body");
        return returnValue;
    }
}