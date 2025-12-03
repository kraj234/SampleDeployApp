# Stage 1: Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 7155
ENV ASPNETCORE_URLS=http://+:7155

# Stage 2: Build and restore dependencies
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy only the project file first (for caching restore layer)
COPY ["SampleDeployApp..csproj", "./"]

# Restore project dependencies
RUN dotnet restore "SampleDeployApp..csproj"

# Copy the rest of the application source code
COPY . .

# Build the application
RUN dotnet build "SampleDeployApp..csproj" -c $BUILD_CONFIGURATION -o /app/build

# Stage 3: Publish for deployment
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "SampleDeployApp..csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Stage 4: Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleDeployApp..dll"]