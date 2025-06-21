FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
WORKDIR /tmp/build

COPY ./src/ ./src/


RUN dotnet restore ./src/cart/cart.sln -r linux-musl-amd64

RUN dotnet build ./src/cart/src/cart.csproj -r linux-musl-amd64 -c Release

RUN dotnet publish ./src/cart/src/cart.csproj \
    -r linux-musl-amd64 \
    -c Release \
    -o /tmp/publish \
    --no-build \
    /p:PublishSingleFile=true \
    /p:SelfContained=true

FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine3.20 AS runtime
WORKDIR /usr/src/app
COPY --from=builder /tmp/publish ./
RUN chmod +x ./cart
ENTRYPOINT ["./cart"]
