@echo off
:: Script para copiar múltiplas pastas e reiniciar o Nginx corretamente

:: Definir IP do seu computador manualmente
set IP_LOCAL=192.168.208.71

:: Definir variáveis
set ORIGEM=C:\dev\projects\landingPage_primeiraEntrega
set DESTINO=C:\dev\servers\nginx-1.26.2\html
set DESTINO_REMOTO=\\%IP_LOCAL%\c$\dev\servers\nginx-1.26.2\html
set NGINX_PATH=C:\dev\servers\nginx-1.26.2
set NGINX_CONF=C:\dev\servers\nginx-1.26.2\conf\nginx.conf

:: Criar destino local se não existir
if not exist "%DESTINO%" mkdir "%DESTINO%"

:: Copiar arquivos para o destino local
for %%D in (%ORIGEM%) do (
    echo Copiando de %%D para %DESTINO%...
    robocopy %%D %DESTINO% /E /MT:8 /R:3 /W:5
)

:: Copiar para outro computador na rede (se acessível)
echo Copiando arquivos para o destino remoto em %DESTINO_REMOTO%...
for %%D in (%ORIGEM%) do (
    robocopy %%D %DESTINO_REMOTO% /E /MT:8 /R:3 /W:5
)

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