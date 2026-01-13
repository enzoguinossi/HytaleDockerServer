FROM eclipse-temurin:25.0.1_8-jre-alpine-3.23

# Diretório do servidor
WORKDIR /hytale

# Dependências
RUN apk add --no-cache \
    curl \
    unzip \
    bash

# Baixar o downloader
RUN curl -L https://downloader.hytale.com/hytale-downloader.zip -o hytale-downloader.zip \
    && unzip hytale-downloader.zip hytale-downloader-linux-amd64 \
    && mv hytale-downloader-linux-amd64 hytale-downloader \
    && chmod +x hytale-downloader \
    && rm hytale-downloader.zip

# Script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Volume persistente do servidor
VOLUME ["/hytale"]

# Porta padrão (ajuste se necessário)
EXPOSE 5520

ENTRYPOINT ["/start.sh"]
