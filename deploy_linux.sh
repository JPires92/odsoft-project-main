#!/bin/bash

echo "Kill the application if it is running"

# Obtém o PID do processo na porta especificada
process=$(netstat -tulnp | grep :$SERVER_PORT | awk '{print $7}' | cut -d'/' -f1)

# Verifica se o processo foi encontrado e termina o processo
if [ -n "$process" ]; then
    echo "Killing process with PID: $process"
    kill -9 $process
else
    echo "No process found running on port $SERVER_PORT"
fi

echo "Deploying the application"

# Cria a pasta de deploy se não existir
mkdir -p $DEPLOY_DIR

# Dá permissão total para a pasta de deploy
chmod -R 777 $DEPLOY_DIR

# Verifica se o arquivo JAR existe na pasta target
if [ -f "target/psoft-g1-0.0.1-SNAPSHOT.jar" ]; then

    # Remove o JAR existente se ele já estiver na pasta de deploy
    if [ -f "$DEPLOY_DIR/psoft-g1-0.0.1-SNAPSHOT.jar" ]; then
        echo "Removing existing JAR in deploy directory..."
        rm "$DEPLOY_DIR/psoft-g1-0.0.1-SNAPSHOT.jar"
    fi

    # Copia o novo arquivo JAR para a pasta de deploy
    cp target/psoft-g1-0.0.1-SNAPSHOT.jar $DEPLOY_DIR/

    # Muda para a pasta de deploy
    cd $DEPLOY_DIR
    

    echo "Starting the application..."

    # Inicia a aplicação em segundo plano a partir da pasta de deploy
    nohup java -jar psoft-g1-0.0.1-SNAPSHOT.jar --server.port="$SERVER_PORT" &

    echo "Application started in background on port $SERVER_PORT"
else
    echo "Error: psoft-g1-0.0.1-SNAPSHOT.jar not found in target!"
    exit 1
fi
