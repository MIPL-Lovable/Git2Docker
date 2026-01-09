# Stage 1: Build React
FROM node:20-alpine AS react-build
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build
 
# Stage 2: Build .NET
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /app
COPY *.sln ./
COPY SocialSecurity.* ./SocialSecurity.*/   # adjust as per your project structure
COPY --from=react-build /app/client/dist ./wwwroot/react
RUN dotnet restore
RUN dotnet publish -c Release -o out
 
# Stage 3: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build-env /app/out .
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80
ENTRYPOINT ["dotnet", "testWebAPI.dll"]
