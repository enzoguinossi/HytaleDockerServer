#!/bin/bash
set -e

echo "=== Hytale Server Docker ==="

SERVER_DIR="/hytale"
DOWNLOADER="$SERVER_DIR/hytale-downloader"
ASSETS="$SERVER_DIR/Assets.zip"

mkdir -p "$SERVER_DIR"
cd "$SERVER_DIR"

# Copia o downloader para o volume persistente
if [ ! -f "$DOWNLOADER" ]; then
    echo "Copiando hytale-downloader para volume persistente..."
    cp /opt/hytale/hytale-downloader "$DOWNLOADER"
    chmod +x "$DOWNLOADER"
fi

echo "Versão do downloader:"
./hytale-downloader -print-version || true

echo "Verificando atualizações do servidor..."
./hytale-downloader -check-update || true

echo "Baixando servidor (se necessário)..."
./hytale-downloader

SERVER_ZIP=$(ls [0-9]*.zip 2>/dev/null | sort | tail -n 1)

if [ -z "$SERVER_ZIP" ]; then
    echo "ERRO: ZIP do servidor não encontrado!"
    exit 1
fi

if [ ! -f "Server/HytaleServer.jar" ]; then
    echo "Extraindo servidor a partir de $SERVER_ZIP ..."
    unzip "$SERVER_ZIP"
else
    echo "Servidor já extraído, pulando unzip."
fi


echo "Iniciando Hytale Server..."
exec java -jar Server/HytaleServer.jar --assets "$ASSETS"