# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /tmp/build

# Copy all necessary source code and protobuf files (adjust if you have more folders)
COPY ./src/ ./src/
COPY ./pb/ ./pb/
# Uncomment and adjust if you have additional projects or generated code folders
# COPY ./shared/ ./shared/
# COPY ./proto-generated/ ./proto-generated/

# Clean previous builds
RUN dotnet clean ./src/cart/cart.sln

# Restore dependencies (must run before publish)
RUN dotnet restore ./src/cart/cart.sln \
    -r linux-musl-amd64 \
    /p:BaseIntermediateOutputPath=/tmp/obj/ \
    /p:IntermediateOutputPath=/tmp/obj/

# Publish the project as a single self-contained file for linux-musl runtime (Alpine)
RUN dotnet publish ./src/cart/src/cart.csproj \
    -r linux-musl-amd64 \
    --no-restore \
    -c Release \
    -o /cart \
    /p:PublishSingleFile=true \
    /p:SelfContained=true \
    /p:BaseIntermediateOutputPath=/tmp/obj/ \
    /p:IntermediateOutputPath=/tmp/obj/

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine3.20 AS runtime

WORKDIR /usr/src/app

# Copy published app from builder stage
COPY --from=builder /cart .

# Make the app executable
RUN chmod +x ./cart

# Entry point
ENTRYPOINT ["./cart"]

