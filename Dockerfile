# Build the React frontend
FROM node:20-alpine AS react-build
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client/ .
RUN npm run build

# Build the ASP.NET Core application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /app

# Copy everything
COPY . ./
# Copy the React build output to the wwwroot folder
COPY --from=react-build /app/client/dist ./wwwroot/react

# Restore as distinct layers
RUN dotnet restore

# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose port 80 for the web API
EXPOSE 80

# Set the environment variable for ASP.NET Core
ENV ASPNETCORE_URLS=http://+:80

# Run the application
ENTRYPOINT ["dotnet", "testWebAPI.dll"]