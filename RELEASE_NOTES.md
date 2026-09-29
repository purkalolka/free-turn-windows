# Release Notes v1.0.1

## Что нового в версии v1.0.1

### 🐛 Исправления и улучшения (Bug Fixes & Refactoring)
* **Tray & Popup Msg Pump**: исправлен цикл обработки сообщений трея и нативных всплывающих окон Windows (`624e78a`).
* **CI Workflows**: скорректированы триггеры веток в GitHub Actions для сборки под Windows (`624e78a`).
* **Gitignore**: улучшены правила игнорирования временных артефактов и бинарников (`624e78a`).
* **Wails JS Bindings**: актуализированы сгенерированные привязки Wails (`8ecc0db`).
* **Документация**: обновлены инструкции в `README.md` и `AGENTS.md` (`42c032a`).

### 📦 Артефакты сборки
* **FreeTurn-Windows-Portable-v1.0.1.zip**: Портативный клиент для Windows (GUI на базе Wails v2 + WinTUN драйвер).
* **client.exe / server.exe**: CLI бинарники ядра Free Turn Proxy.
