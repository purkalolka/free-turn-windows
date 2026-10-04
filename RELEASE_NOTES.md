# Release Notes v1.0.2

## Что нового в версии v1.0.2

### 🛡️ Безопасность и ядро (free-turn-proxy v3.4.1)
* **VK Calls без капчи**: официальный мобильный `client_id=8093730` с поддержкой `token` и `user_token` для вызовов `auth.getAnonymToken` и `messages.getAnonymCallToken`, гарантирующий получение TURN-учетных данных без запроса капчи.
* **DTLS Certificate Pinning**: защита от MITM через проверку SHA-256 отпечатка сертификата (параметр `fp` в ссылках `freeturn://` и CLI-флаг `-dtls-fingerprint`), постоянные самоподписанные сертификаты сервера.
* **Anti-Replay Window**: скользящее окно размером 128 пакетов (RFC 6479 / RFC 4303) в протоколах обфускации RTP Opus (`rtpopus`, `rtpopus2`, `rtpopus3`), пресекающее атаки повтора пакетов.
* **Защита конфигураций**: безопасные права доступа `0600` (`-rw-------`) для файлов конфигурации, паролей и ключей.
* **Server-Control**: скрипты настройки VPS переключены на защищенный репозиторий `purkalolka/free-turn-proxy`, добавлена retry-логика при скачивании бинарников, сверка SHA-256 и надежное управление блокировками пакетных менеджеров.

### 📦 Артефакты сборки
* **FreeTurn-Windows-Portable-v1.0.2.zip**: Портативный клиент для Windows (GUI на базе Wails v2 + WinTUN драйвер `wintun.dll` + `Run_Admin.bat`).
* **client-windows-amd64.exe / server-windows-amd64.exe**: CLI бинарники ядра Free Turn Proxy.
* **checksums.txt**: SHA-256 контрольные суммы всех файлов.
