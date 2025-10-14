FROM rust:1.75 AS builder

WORKDIR /usr/src/app

COPY Cargo.toml .
COPY src/libdoh/Cargo.toml src/libdoh/Cargo.toml

COPY src ./src
RUN cargo build --release

FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /usr/src/app/target/release/doh-proxy /usr/local/bin/doh-proxy
COPY localhost.pem /app/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3000

ENV DOHS_HOSTNAME=localhost \
    DOHS_LISTEN_ADDRESS=127.0.0.1:3000 \
    DOHS_TLS_CERT_KEY_PATH=/app/localhost.pem \
    DOHS_TLS_CERT_PATH=/app/localhost.pem
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]