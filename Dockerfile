# Stage 1: Build the application
FROM crystallang/crystal:latest AS builder

WORKDIR /app

# Copy all files from the root directory
COPY . .

# Install shards dependencies
RUN shards install

# Build the application
RUN crystal build --release --static src/app.cr -o /app/app

# Stage 2: Create the final image
FROM scratch

# Copy the binary from the builder stage
COPY --from=builder /app/app /app/app

# Expose the desired port(s)
EXPOSE 3000

# Set the entrypoint to run the application
ENTRYPOINT ["/app/app"]
