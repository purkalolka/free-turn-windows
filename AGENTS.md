# AGENTS.md

## Repository Overview
Free Turn Proxy encapsulates UDP/TCP traffic over TURN/WebRTC protocols to bypass network restrictions. It supports multiple transports (UDP, TCP, DTLS, KCP), packet obfuscation (`rtpopus`, `rtpopus2`, `rtpopus3`, `shape`), and userspace WireGuard/AmneziaWG integration.

### Core Modules & Monorepo Layout
- `cmd/client`, `cmd/server`: Host binary CLI entrypoints.
- `internal/`: Core proxy logic, wire codecs, TURN credential providers (`vk`, `multi`), and userspace TUN/AWG integration.
- `mobile/`: Exported Go mobile API (`gomobile bind`) consumed as Android AAR or iOS XCFramework.
- `desktop/`: Wails v2 desktop application.
  - `desktop/backend`: Go backend, app state store, local TUN (`wintunnel`), SSH remote VPS setup engine.
  - `desktop/backend/serversetup/server-control/src/`: POSIX shell scripts concatenated to manage remote VPS proxies.
  - `desktop/frontend`: React 19 + TypeScript + Vite UI. Types/bindings in `desktop/frontend/wailsjs`.

---

## Toolchain & Build Commands

### Go Toolchain Quirks
- **Go version**: Go >= 1.26 (CI uses 1.26.7).
- **Mandatory Linker Flag**: Any build (`go build` or `gomobile bind`) **must** include `-checklinkname=0` in `-ldflags`, e.g.:
  `-ldflags "-s -w -checklinkname=0 -X main.version=..."`.

### Host Binaries
```powershell
go build -ldflags "-s -w -checklinkname=0 -X main.version=dev" -trimpath -o dist/client.exe ./cmd/client
go build -ldflags "-s -w -checklinkname=0 -X main.version=dev" -trimpath -o dist/server.exe ./cmd/server
```
*(With Taskfile: `task build`)*

### Mobile Targets
- iOS XCFramework (macOS only): `task build:ios`
- Android AAR: `task build:android` (requires Android SDK / NDK and `gomobile`).

### Desktop App & Frontend
- Path: `desktop/frontend/`
- Install dependencies: `npm --prefix desktop/frontend install`
- Typecheck & build frontend: `npm --prefix desktop/frontend run build`
- Dev server: `npm --prefix desktop/frontend run dev`
- Full desktop app build (requires Wails v2 CLI): `cd desktop && wails build`

---

## Testing & Quality Assurance

### Running Tests
- **All unit tests** (without CGO race overhead on Windows):
  ```powershell
  go test -count=1 ./...
  ```
- **Single package**:
  ```powershell
  go test -v -count=1 ./internal/config/...
  go test -v -count=1 ./desktop/backend/serversetup/...
  ```
- **Single test**:
  ```powershell
  go test -v -run TestImportLinkWithWgConfSwitchesToVPN ./desktop/backend
  ```
- **Race detector** (CI default via `task test`):
  `go test -race -count=1 ./...` (requires GCC/MinGW CGO toolchain on Windows).

### Integration Test Prerequisites
- In `desktop/backend/serversetup/`:
  - Skipped by default unless `FT_TEST_SSH_HOST` is defined.
  - Tests that mutate remote VPS environment require `FT_TEST_MUTATE=1`.

### Verification Pipeline (Local Pre-Commit Order)
Run verification steps in this order:
1. `gofmt -l .` (fix with `gofmt -w .`)
2. `go vet ./...`
3. `golangci-lint run --timeout=5m ./...` (if installed)
4. `npm --prefix desktop/frontend run build` (if desktop frontend files changed)
5. `go test -count=1 ./...`
*(Or `task ci` if Taskfile and required linters are installed).*

---

## Key Constraints & Gotchas
- **Windows File Paths**: Always use `filepath.Join` and never assume forward slashes in Go code dealing with paths. Normalize CRLF / LF when reading embedded templates or scripts.
- **Wails Bindings**: Methods and types exported on `desktop/app.go` or passed between Go and frontend must remain JSON-serializable. Generated bindings reside in `desktop/frontend/wailsjs`.
- **Server Control Scripts (`desktop/backend/serversetup/server-control/src/*.sh`)**:
  - Embedded into the desktop binary via Go embed.
  - Must remain strictly POSIX `/bin/sh` or bash compatible for standard Linux servers (Debian/Ubuntu/Alpine).
- **Mobile Bindings (`mobile/`)**:
  - Exported functions and types must adhere strictly to `gomobile` limitations (primitives, byte slices, strings, or supported interface types).
- **Windows Tun Driver (`wintun.dll`)**:
  - Embedded at `desktop/backend/wintunnel/assets/wintun.dll` and extracted at runtime next to the executable if not present.
