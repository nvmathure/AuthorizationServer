using AuthorizationServer.Server.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace AuthorizationServer.Server.Functions.Application;

public class CreateApplicationFunction
{
    private readonly ILogger<CreateApplicationFunction> _logger;

    public CreateApplicationFunction(ILogger<CreateApplicationFunction> logger)
    {
        _logger = logger;
    }

    [Function("CreateApplication")]
    public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequestData request)
    {
        var requestBody = await request.ToObject<CreateApplicationRequest>();
        _logger.LogInformation("C# HTTP trigger function processed a request.");
        var response = request.CreateResponse(System.Net.HttpStatusCode.OK);
        await response.WriteStringAsync("Welcome to Azure Functions!");
        return response;
    }
}