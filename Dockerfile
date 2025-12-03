# Stage 1: Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 7155
ENV ASPNETCORE_URLS=http://+:7155

# Stage 2: Build and restore dependencies
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy only the project file from the correct folder
COPY ["SampleDeployApp/SampleDeployApp.csproj", "SampleDeployApp/"]

# Restore dependencies
RUN dotnet restore "SampleDeployApp/SampleDeployApp.csproj"

# Copy entire project
COPY . .

# Build the project
RUN dotnet build "SampleDeployApp/SampleDeployApp.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Stage 3: Publish for deployment
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "SampleDeployApp/SampleDeployApp.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Stage 4: Runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Entry point
ENTRYPOINT ["dotnet", "SampleDeployApp.dll"]
