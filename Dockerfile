# Use a newer Go version (latest stable)
FROM golang:1.24-alpine

WORKDIR /app

COPY . .

# Download dependencies
RUN go mod tidy

# Build the application
RUN go build -o main .

CMD [ "./main" ]
