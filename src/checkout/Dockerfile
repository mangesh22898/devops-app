# Use Golang 1.22 Alpine as the builder
FROM golang:1.22-alpine AS builder

WORKDIR /usr/src/app/

# Copy go.mod and go.sum before running go mod download
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the checkout service
RUN go build -ldflags "-s -w" -o /go/bin/checkout .

# Use a lightweight Alpine image for final container
FROM alpine

WORKDIR /usr/src/app/

# Copy the built binary from the builder stage
COPY --from=builder /go/bin/checkout .

# Set the port for the service
EXPOSE 8080

# Run the checkout service
ENTRYPOINT ["./checkout"]

