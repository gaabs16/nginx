@echo off
:: Script para copiar a pasta "palavras-cruzadas" e reiniciar o Nginx corretamente

:: Definir variáveis
set ORIGEM=C:\dev\projects\palavras-cruzadas
set DESTINO=C:\dev\servers\nginx-1.26.2\html\palavras-cruzadas
set NGINX_PATH=C:\dev\servers\nginx-1.26.2
set NGINX_CONF=C:\dev\servers\nginx-1.26.2\conf\nginx.conf

:: Criar pasta de destino se não existir
if not exist "%DESTINO%" (
    mkdir "%DESTINO%"
)

:: Copiar a pasta e seus arquivos
xcopy "%ORIGEM%\*.*" "%DESTINO%" /E /I /Y

:: Garantir que estamos na pasta correta do Nginx
cd /d "%NGINX_PATH%"

:: Verificar se o Nginx está rodando
tasklist /FI "IMAGENAME eq nginx.exe" | find /I "nginx.exe" > NUL
if errorlevel 1 (
    echo Nginx nao esta rodando. Iniciando o Nginx...
    nginx.exe -c "%NGINX_CONF%"
) else (
    echo Nginx esta rodando. Reiniciando o Nginx...

    :: Parar o Nginx corretamente
    nginx.exe -s stop
    timeout /t 2 /nobreak > NUL
    
    :: Iniciar novamente com o arquivo nginx.conf correto
    nginx.exe -c "%NGINX_CONF%"
)

:: Mensagem de conclusão
echo Arquivos copiados e Nginx reiniciado com sucesso!

:: Pausa para visualizar resultado
pause
