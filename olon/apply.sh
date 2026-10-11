|"OLON-Support"|#!/usr/bin/env bash
|"OLON-Support"|# OLON Support: RustDesk 1.5.0 with the OLON name, icons and our own server (remote.olonerp.eu).
|"OLON-Support"|# hbb_common is a submodule, so its few lines are changed here, on the build machine, after checkout.
|"OLON-Support"|# Every change is checked; the build stops if RustDesk's source no longer looks as expected.
|"OLON-Support"|set -euo pipefail
|"OLON-Support"|cd "$(dirname "$0")/.."
|"OLON-Support"|f=libs/hbb_common/src/config.rs
|"OLON-Support"|
|"OLON-Support"|swap() { # file, exact old text, new text
|"OLON-Support"|  grep -qF -- "$2" "$1" || { echo "olon/apply.sh: not found in $1: $2" >&2; exit 1; }
|"OLON-Support"|  python3 - "$1" "$2" "$3" <<'PY'
|"OLON-Support"|import sys
|"OLON-Support"|p, old, new = sys.argv[1:4]
|"OLON-Support"|s = open(p, encoding="utf-8").read()
|"OLON-Support"|assert s.count(old) == 1, f"expected one {old!r} in {p}, found {s.count(old)}"
|"OLON-Support"|open(p, "w", encoding="utf-8", newline="").write(s.replace(old, new))
|"OLON-Support"|PY
|"OLON-Support"|}
|"OLON-Support"|
|"OLON-Support"|# Our server and its public key (not a secret: every client carries it).
|"OLON-Support"|swap "$f" 'pub const RENDEZVOUS_SERVERS: &[&str] = &["rs-ny.rustdesk.com"];' \
|"OLON-Support"|          'pub const RENDEZVOUS_SERVERS: &[&str] = &["remote.olonerp.eu"];'
|"OLON-Support"|swap "$f" 'pub const RS_PUB_KEY: &str = "OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=";' \
|"OLON-Support"|          'pub const RS_PUB_KEY: &str = "8SgswV6kZC6T8s0SGycP9Y8Z9QLEHhP+xCIiS4hPUHM=";'
|"OLON-Support"|# The name: RustDesk installs only a name of [a-zA-Z0-9-]+ (ui_interface.rs), so no space and no Greek.
|"OLON-Support"|swap "$f" 'pub static ref APP_NAME: RwLock<String> = RwLock::new("RustDesk".to_owned());' \
|"OLON-Support"|          'pub static ref APP_NAME: RwLock<String> = RwLock::new("OLON-Support".to_owned());'
|"OLON-Support"|# The customer sees no server or network settings to change by mistake.
|"OLON-Support"|swap "$f" 'pub static ref BUILTIN_SETTINGS: RwLock<HashMap<String, String>> = Default::default();' \
|"OLON-Support"|          'pub static ref BUILTIN_SETTINGS: RwLock<HashMap<String, String>> = RwLock::new(HashMap::from([("hide-server-settings".to_owned(), "Y".to_owned()), ("hide-network-settings".to_owned(), "Y".to_owned()), ("hide-proxy-settings".to_owned(), "Y".to_owned()), ("hide-websocket-settings".to_owned(), "Y".to_owned())]));'
|"OLON-Support"|
|"OLON-Support"|grep -c 'remote.olonerp.eu\|8SgswV6kZC6T8s0SGycP9Y8Z9QLEHhP+xCIiS4hPUHM=\|"OLON Support"\|hide-network-settings' "$f"
|"OLON-Support"|echo "OLON_APPLY_OK"
