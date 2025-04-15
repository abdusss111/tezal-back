# Первый этап: сборка
FROM golang:latest AS builder

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o mezet .

# Второй этап: создание минимального образа для выполнения
FROM ubuntu:latest

WORKDIR /root

RUN apt-get update && apt-get install -y tzdata

RUN  apt-get install -y ca-certificates
RUN  update-ca-certificates

# Копируем скомпилированный файл из предыдущего этапа
COPY --from=builder /app/mezet .
COPY --from=builder /app/.env .
COPY --from=builder /app/firebase_env.json .

# Добавляем права на выполнение, если они отсутствуют
# RUN chmod 777 /root/mezet

EXPOSE 8080

CMD ["./mezet"]
