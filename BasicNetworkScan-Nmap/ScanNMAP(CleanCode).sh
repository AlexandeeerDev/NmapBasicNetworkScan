#!/bin/bash
echo "Iniciando escaneo de red..."
NETWORK="***.***.*.*/24"  
FILE="resultadosNMAP" 
mkdir -p $FILE

echo "Escaneando dispositivos activos..."
sudo nmap -sn $NETWORK -oN $FILE/activos_$(date '+%Y-%m-%d_%H-%M-%S').txt
echo "Escaneando puertos TCP abiertos..."
sudo nmap -sT $NETWORK -oN $FILE/tcp_$(date '+%Y-%m-%d_%H-%M-%S').txt
echo "Realizando escaneo SYN..."
sudo nmap -sS $NETWORK -oN $FILE/syn_$(date '+%Y-%m-%d_%H-%M-%S').txt
echo "Detectando versiones de servicios..."
sudo nmap -sV $NETWORK -oN $FILE/versiones_$(date '+%Y-%m-%d_%H-%M-%S').txt
echo "Intentando detectar sistemas operativos..."
sudo nmap -O $NETWORK -oN $FILE/sistemas_$(date '+%Y-%m-%d_%H-%M-%S').txt
echo "Ejecutando scripts NSE para detección de vulnerabilidades..."
sudo nmap --script vuln $NETWORK -oN $FILE/vulnerabilidades_$(date '+%Y-%m-%d_%H-%M-%S').txt
echo "Escaneo completado. Los resultados están en la carpeta $FILE."