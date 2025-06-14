#Start from offcial Go image
FROM golang:1.22-alpine AS builder
# Working directory
WORKDIR /app
# Copy the Go source code
COPY go.mod go.sum ./
RUN go mod download
COPY . .
#Build the Go app
RUN go build -o hello
# ----- Final minimal image ----
FROM alpine:latest
WORKDIR /app
#Copy the  the compiled binary from builder stage
COPY --from=builder /app/hello .
# Expose port
EXPOSE 8080
ENTRYPOINT ["./hello"]