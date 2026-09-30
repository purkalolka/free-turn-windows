# Мобильные устройства

## Android (Termux)

При работе на мобильных устройствах возникают две основные проблемы: перехват DNS оператором и зацикливание маршрутов VPN.

1. Установите Termux.
2. В клиенте WireGuard / AmneziaWG: `Endpoint = 127.0.0.1:9000`, `MTU = 1280` (если связь нестабильна, MTU можно снижать вплоть до 1120).
3. **Критично:** Добавьте Termux в **Исключения WireGuard** (разрешенные приложения, не пускать через VPN). Если этого не сделать, туннель завернется сам в себя, и соединения не будет.
4. **Критично:** В большинстве случаев мобильные операторы блокируют сторонние DNS, включая DoH. Передавайте IP-адрес DNS вашего оператора связи через флаг `-dns-servers`.

Сборка клиента из исходников для Termux (arm64):

```bash
GOOS=android GOARCH=arm64 go build -o dist/client-android-arm64 ./cmd/client
adb push dist/client-android-arm64 /data/data/com.termux/files/usr/bin/client
```

Снять wake lock: `termux-wake-unlock`.

## iOS (iSH)

Запасной вариант без нативного клиента.

```bash
apk update
apk add curl
curl -L -o client https://github.com/samosvalishe/free-turn-proxy/releases/latest/download/client-linux-386
chmod +x client
GOMAXPROCS=1 GODEBUG=asyncpreemptoff=1 ./client -listen 127.0.0.1:9000 -peer <vps>:56000 -link "<vk-link>"
```

Дольше в фоне:

```bash
cat /dev/location > /dev/null &
```
