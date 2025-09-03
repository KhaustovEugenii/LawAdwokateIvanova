# Используем официальный образ Rust
FROM rust:1.70 as builder

# Создаем новую пустую рабочую директорию
WORKDIR /usr/src/app

# Копируем только файлы конфигурации зависимостей
COPY Cargo.toml Cargo.lock ./

# Создаем фиктивный исходный код для предварительной сборки зависимостей
RUN mkdir src && \
    echo 'fn main() {}' > src/main.rs && \
    cargo build --release && \
    rm -rf src

# Копируем реальный исходный код
COPY src ./src

# Собираем приложение
RUN cargo build --release

# Финальный образ
FROM debian:bullseye-slim
WORKDIR /usr/src/app

# Копируем собранный бинарник
COPY --from=builder /usr/src/app/target/release/lawadvocate_pro .

# Указываем команду для запуска
CMD ["./lawadvocate_pro"]
