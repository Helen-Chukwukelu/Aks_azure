FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ReferenceData.Api/ReferenceData.Api.csproj", "ReferenceData.Api/"]
COPY ["nuget.config", "ReferenceData.Api/"]
RUN dotnet restore "ReferenceData.Api/ReferenceData.Api.csproj"
COPY . .
WORKDIR "/src/ReferenceData.Api"
RUN dotnet build "ReferenceData.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ReferenceData.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

RUN DATADOGVERSION=1.28.8 \
  && ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='amd64';; \
    arm64) ARCH='arm64';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && echo $DATADOGVERSION $ARCH \
  && apt-get update; apt-get -y install curl \
  && mkdir -p /opt/datadog \
  && mkdir -p /var/log/datadog \
  && package=datadog-dotnet-apm_${DATADOGVERSION}_${ARCH}.deb \
  && curl -LO https://github.com/DataDog/dd-trace-dotnet/releases/download/v$DATADOGVERSION/$package \
  && dpkg -i ./$package \
  && rm ./$package

ENV CORECLR_ENABLE_PROFILING=1
ENV CORECLR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}
ENV CORECLR_PROFILER_PATH=/opt/datadog/Datadog.Trace.ClrProfiler.Native.so
ENV DD_DOTNET_TRACER_HOME=/opt/datadog
ENV DD_INTEGRATIONS=/opt/datadog/integrations.json
ENV CONSUL_HOST=http://host.docker.internal:8500
ENV CONSUL_ENV=reference-data/local.json

ENTRYPOINT ["dotnet", "ReferenceData.Api.dll"]
