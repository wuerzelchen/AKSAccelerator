# Stage 1 - Build the car (using the sdk, our factory)
FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine3.17 AS builder 
WORKDIR /source
COPY . .
RUN dotnet publish --output package

# Stage 2 - Ship the car (but not the factory)
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine3.17
WORKDIR /app
COPY --from=builder /source/package .
ENTRYPOINT ["dotnet", "BuildContainerDemo.dll"]
