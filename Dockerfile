FROM rust:1.70-slim-bullseye as builder

WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim
WORKDIR /app
COPY --from=builder /app/target/release/lawadvocate_pro .
CMD ["./lawadvocate_pro"]
