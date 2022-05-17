#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env
WORKDIR /app

COPY . ./
RUN dotnet restore

RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS final
WORKDIR /app
COPY --from=build-env /app/out .

LABEL io.k8s.display-name="dotnet-311-git" \
      io.k8s.description="container description..." \
      io.openshift.expose-services="8080:http"

EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

ENTRYPOINT ["dotnet", "sampledb31.dll"]
