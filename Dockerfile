FROM mcr.microsoft.com/dotnet/aspnet:3.1-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["sampledb31.csproj", ""]
RUN dotnet restore "./sampledb31.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "sampledb31.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "sampledb31.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080
ENTRYPOINT ["dotnet", "sampledb31.dll"]
