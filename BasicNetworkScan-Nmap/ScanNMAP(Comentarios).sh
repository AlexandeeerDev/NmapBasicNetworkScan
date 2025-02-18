#!/bin/bash
#Inicio de Escaneo NMAP:
echo "Iniciando escaneo de red..."

# Variables para reducir procesos:
NETWORK="***.***.*.*/24"  # Cambiar con respecto a su IP.
FILE="resultadosNMAP"  # Nombre del directorio donde guardaremos los resultados.

# Creacion de una carpeta para el guardado de datos (resultados)
mkdir -p $FILE
# La opción -p garantiza que la carpeta se cree solo si no existe.

# Escaneo de dispositivos activos con Ping (-sn):
echo "Escaneando dispositivos activos..."
# Este comando envía paquetes de ping a todos los dispositivos de la red especificada (sin escanear puertos) para detectar cuáles están activos.
sudo nmap -sn $NETWORK -oN $FILE/activos_$(date '+%Y-%m-%d_%H-%M-%S').txt
# -sn: Desactiva el escaneo de puertos. Solo realiza un "ping" para ver qué dispositivos responden.
# -oN: Guarda el resultado en un archivo de texto con el nombre y fecha actuales.

# Escaneo de puertos TCP abiertos (TCP Connect Scan -sT):
echo "Escaneando puertos TCP abiertos..."
# Escanea puertos abiertos estableciendo conexiones TCP completas, lo cual es más exhaustivo y más lento que las otras funciones de scaneo.
sudo nmap -sT $NETWORK -oN $FILE/tcp_$(date '+%Y-%m-%d_%H-%M-%S').txt
# -sT: Realiza el "TCP Connect Scan", que establece una conexión completa con los puertos para verificar si están abiertos.
# Este escaneo es más confiable Y también más fácil de detectar por los dispositivos de la red.

# Escaneo SYN rápido (-sS):
echo "Realizando escaneo SYN..."
# Realiza un escaneo SYN, más rápido y menos detectable que el anterior, ya que no completa la conexión TCP.
sudo nmap -sS $NETWORK -oN $FILE/syn_$(date '+%Y-%m-%d_%H-%M-%S').txt
# -sS: Realiza un "SYN scan", también llamado escaneo furtivo, donde solo se envía un paquete SYN sin completar el "handshake" TCP.
# Es más rápido y menos detectable por firewalls, pero sigue siendo efectivo para identificar puertos abiertos.

# Escaneo de versiones de servicios (-sV):
# Detecta la versión de los servicios que se están ejecutando en los puertos abiertos identificados en el escaneo anterior.
echo "Detectando versiones de servicios..."
sudo nmap -sV $NETWORK -oN $FILE/versiones_$(date '+%Y-%m-%d_%H-%M-%S').txt
# -sV: Intenta detectar las versiones específicas de los servicios (como Apache, OpenSSH, etc.) que se ejecutan en los puertos abiertos.
# Esto es útil para detectar vulnerabilidades en versiones antiguas de software.

# Detección de sistemas operativos (-O)
# Intenta adivinar el sistema operativo de los dispositivos en la red basándose en las respuestas de los paquetes enviados.
echo "Intentando detectar sistemas operativos..."
sudo nmap -O $NETWORK -oN $FILE/sistemas_$(date '+%Y-%m-%d_%H-%M-%S').txt
# -O: Activa la detección de sistema operativo. Nmap compara las respuestas de los paquetes con una base de datos para adivinar el OS.
# Puede no ser 100% exacto, pero da una buena idea de qué sistema operativo está corriendo en los dispositivos.

# Escaneo con scripts NSE para detectar vulnerabilidades comunes (--script vuln)
# Utiliza scripts especializados de Nmap para detectar vulnerabilidades conocidas en los servicios detectados.
echo "Ejecutando scripts NSE para detección de vulnerabilidades..."
sudo nmap --script vuln $NETWORK -oN $FILE/vulnerabilidades_$(date '+%Y-%m-%d_%H-%M-%S').txt
# --script vuln: Ejecuta el conjunto de scripts "vuln" del Nmap Scripting Engine (NSE) para detectar vulnerabilidades conocidas.
# Estos scripts automatizan tareas comunes como la detección de servicios inseguros o vulnerables.

echo "Escaneo completado. Los resultados están en la carpeta $FILE."
