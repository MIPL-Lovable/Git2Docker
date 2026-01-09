# React build
FROM node:20-alpine AS react-build
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client .
RUN npm run build
 
# .NET build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app
COPY . .
RUN mkdir -p /app/client/dist
COPY --from=react-build /app/client/dist /app/client/dist
RUN dotnet publish -c Release -o out
 
# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/out .
COPY --from=build /app/client /app/client
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80
ENTRYPOINT ["dotnet", "testWebAPI.dll"]
