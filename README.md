<div align="center">

<img src="logo.webp" height="250">

# FreeTurn for Windows

![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=flat-square&logo=windows&logoColor=white)
![Wails](https://img.shields.io/badge/UI-Wails%20v2%20%7C%20React%2019-DF0000?style=flat-square&logo=wails&logoColor=white)
![Go](https://img.shields.io/badge/Go-1.26-00ADD8?style=flat-square&logo=go&logoColor=white)
![License](https://img.shields.io/badge/license-Happy_Bunny-ff69b4?style=flat-square&logoColor=white)

**FreeTurn Windows Client** — графический клиент обхода блокировок и цензуры на базе инкапсуляции трафика через TURN/WebRTC протоколы с полноценной поддержкой системного VPN (Wintun / WireGuard / AmneziaWG).

[**Скачать релиз (v1.0.0)**](https://github.com/purkalolka/free-turn-windows/releases/latest)

</div>

---

## Возможности

- 🚀 **Полноценный системный VPN**: создание виртуального адаптера Wintun и перенаправление всего системного трафика (WireGuard / AmneziaWG) через защищенный релей.
- 🛡️ **Обход блокировок и DPI**: маскировка UDP/TCP трафика под WebRTC/TURN соединения и звонки, шифрование DTLS/TLS и обфускация пакетов (`rtpopus`, `rtpopus2`, `rtpopus3`, `shape`).
- 🔗 **Поддержка ссылок подключения**: мгновенный импорт конфигураций по ссылке `freeturn://` или прямых конфигов WireGuard/AmneziaWG (`.conf`).
- 🖥️ **Управление серверами**: встроенный мастер настройки и развертывания своего сервера на VPS через SSH в один клик, управление пирами и экспорт ссылок.
- 📦 **Встроенный Wintun драйвер**: драйвер `wintun.dll` встроен в клиент и автоматически распаковывается при необходимости.

---

## Быстрый старт

### 1. Установка
1. Перейдите в [**Releases**](https://github.com/purkalolka/free-turn-windows/releases/latest) и скачайте архив `FreeTurn-Windows-Portable-v1.0.0.zip`.
2. Распакуйте архив в любую удобную папку на компьютере.

### 2. Запуск
> ⚠️ **Важно:** Для создания виртуального сетевого адаптера Wintun и настройки системных маршрутов требуются права администратора.

- Запустите **`Run_Admin.bat`** (или нажмите правой кнопкой мыши по **`FreeTurn.exe`** ➔ **«Запуск от имени администратора»**).

### 3. Подключение
1. Вставьте ссылку конфигурации формата `freeturn://...` в поле добавления или импортируйте свой WireGuard `.conf`.
2. В выпадающем списке режима переключите на **VPN** для перенаправления всего трафика через туннель.
3. Нажмите кнопку **Подключиться**.

---

## Сборка из исходников

### Требования
- **Go** ≥ 1.26
- **Node.js** ≥ 18 + **npm**
- **Wails CLI v2**:
  ```bash
  go install github.com/wailsapp/wails/v2/cmd/wails@latest
  ```

### Сборка приложения
```bash
# Переходим в каталог desktop
cd desktop

# Установка зависимостей фронтенда
npm --prefix frontend install

# Сборка production-бинарника (с обязательным флагом -checklinkname=0)
wails build -ldflags "-checklinkname=0 -s -w" -trimpath
```
Готовый исполняемый файл будет доступен в `desktop/build/bin/freeturn-desktop.exe`.

### Запуск в dev-режиме
```bash
cd desktop
wails dev
```

---

## Благодарности
- Ядро прокси: [Free Turn Proxy](https://github.com/samosvalishe/free-turn-proxy)
- Разработчикам Wails, Wintun и сообществу.
