# OLON Support

RustDesk 1.5.0 as the remote-support client of OLON (ΟΛΟΝ): the OLON name and icons, already set to our own
RustDesk server `remote.olonerp.eu`, with the server and network settings hidden from the customer. The customer
accepts every session.

What changes from RustDesk (branch `olon`, from the tag `1.5.0`):

| Where | Change |
| --- | --- |
| `res/*.png`, `res/*.ico`, `flutter/windows/runner/resources/app_icon.ico`, `flutter/assets/icon.svg` | the OLON app icon |
| `olon/apply.sh` (run by the build on `libs/hbb_common/src/config.rs`) | server `remote.olonerp.eu`, its public key, the name «OLON-Support» (RustDesk installs only [a-zA-Z0-9-]+), server/network/proxy/websocket settings hidden |
| `olon/apply.sh` (on `src/common.rs`) | `using_public_server()` is true only if the server in use is rustdesk.com, so «Ready» comes without «please set up your own server» |
| `.github/workflows/olon-windows.yml` | RustDesk's own Windows x64 build steps, plus `olon/apply.sh`; a tag `olon-<version>` publishes the release |

Build: Actions → «OLON Support (Windows)» → Run workflow, or push a tag `olon-1.5.0`.

RustDesk is licensed under the GNU AGPL-3.0 (see `LICENCE`); this modified version is published here under the same
licence, with its full source.
