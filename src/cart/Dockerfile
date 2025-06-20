# ---------------------------------------------------------------
# Build Stage
# ---------------------------------------------------------------
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
ARG TARGETARCH

# Set working directory
WORKDIR /usr/src/app/

# Copy everything needed to restore and build
COPY . .

# Restore using the solution to bring in all project references
RUN dotnet restore ./cart.sln -r linux-musl-$TARGETARCH

# Publish the main app project
RUN dotnet publish ./src/cart/cart.csproj -r linux-musl-$TARGETARCH \
    --no-restore -c Release -o /cart

# ---------------------------------------------------------------
# Runtime Stage
# ---------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine3.20

# Set working directory
WORKDIR /usr/src/app/

# Copy published app from builder stage
COPY --from=builder /cart/ ./

# Set environment
ENV DOTNET_HOSTBUILDER__RELOADCONFIGONCHANGE=false

# Expose port (optional: update to actual port used by your app)
EXPOSE ${CART_PORT}

# Run the app
ENTRYPOINT [ "./cart" ]

