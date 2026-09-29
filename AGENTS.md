# AGENTS.md

## Repository Overview
Free Turn Proxy encapsulates UDP/TCP traffic over TURN/WebRTC protocols to bypass network restrictions. It supports multiple transports (UDP, TCP, DTLS, KCP), packet obfuscation (`rtpopus`, `rtpopus2`, `rtpopus3`, `shape`), and userspace WireGuard/AmneziaWG integration.

### Monorepo Structure & Key Boundaries
- `cmd/client`, `cmd/server`: Host binary CLI entrypoints (`main.go`).
- `internal/`: Core proxy routing, protocols, obfuscation codecs, credential providers (`vk`, `multi`), and TUN/AWG integration.
- `mobile/`: Exported Go mobile API (`gomobile bind`, package `main` / `mobile`), exposes control and TUN interface for Android/iOS.
- `desktop/`: Wails v2 desktop application.
  - `desktop/main.go`, `desktop/app.go`: Wails runtime lifecycle and Go frontend bridge.
  - `desktop/backend/`: App store, local TUN (`wintunnel` using wintun), SSH remote VPS setup engine.
  - `desktop/backend/serversetup/server-control/src/`: POSIX shell scripts concatenated to manage remote VPS proxies.
  - `desktop/frontend/`: React 19 + TypeScript + Vite UI. Generated bindings in `desktop/frontend/wailsjs`.

---

## Toolchain & Build Commands

### Go Toolchain Quirks
- **Go version**: Go >= 1.26.
- **Mandatory Linker Flag**: Builds (`go build`, `gomobile bind`) **must** include `-checklinkname=0` in `-ldflags`, e.g.:
  `-ldflags "-s -w -checklinkname=0 -X main.version=..."`.

### Host Binaries
```powershell
go build -ldflags "-s -w -checklinkname=0 -X main.version=dev" -trimpath -o dist/client.exe ./cmd/client
go build -ldflags "-s -w -checklinkname=0 -X main.version=dev" -trimpath -o dist/server.exe ./cmd/server
```
*(Via Taskfile: `task build`)*

### Desktop App & Frontend
- **Frontend build/typecheck**:
  ```powershell
  npm --prefix desktop/frontend run build
  ```
- **Frontend dev server**:
  ```powershell
  npm --prefix desktop/frontend run dev
  ```
- **Desktop application build**:
  ```powershell
  cd desktop && wails build
  ```

### Mobile Targets (via Taskfile)
- **iOS XCFramework** (macOS only): `task build:ios`
- **Android AAR**: `task build:android` (requires Android SDK/NDK and `gomobile`).

---

## Testing & Verification

### Running Tests
- **All unit tests** (avoid `-race` on Windows without MinGW/GCC CGO toolchain):
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
- **CI / Race detector**:
  `task test` or `go test -race -count=1 ./...` (requires CGO compiler).

### Integration Test Prerequisites
- In `desktop/backend/serversetup/`:
  - SSH integration tests are skipped unless `FT_TEST_SSH_HOST` is set.
  - Destructive remote VPS tests require `FT_TEST_MUTATE=1`.

### Verification Pipeline Order
When verifying changes before PR/commit:
1. `gofmt -l .` (or `task fmt:check`, fix with `task fmt` or `gofmt -w .`)
2. `go vet ./...` (or `task vet`)
3. `golangci-lint run --timeout=5m ./...` (or `task lint` if installed)
4. `npm --prefix desktop/frontend run build` (when modifying `desktop/frontend/`)
5. `go test -count=1 ./...`

---

## Key Constraints & Gotchas
- **Windows Path Handling**: Always use `filepath.Join` in Go and handle CRLF vs LF line endings explicitly when processing embedded scripts or templates.
- **Wails Serialization**: All types and methods exposed on `desktop/app.go` or passed between Go and frontend must be strictly JSON-serializable. Keep generated bindings in `desktop/frontend/wailsjs` in sync.
- **Embedded Server Control Scripts (`desktop/backend/serversetup/server-control/src/*.sh`)**:
  - Embedded into the desktop binary via Go `embed`.
  - Must remain strictly POSIX `/bin/sh` or bash compatible for standard Linux servers (Debian/Ubuntu/Alpine).
- **Mobile Bindings (`mobile/`)**:
  - Exported functions and types must adhere strictly to `gomobile` limitations (primitives, byte slices, strings, or supported interface types).
- **Windows Tun Driver (`wintun.dll`)**:
  - Embedded at `desktop/backend/wintunnel/assets/wintun.dll` and extracted at runtime next to the executable if not present.
