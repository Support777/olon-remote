#!/usr/bin/env bash
# OLON Support: RustDesk 1.5.0 with the OLON name, icons and our own server (remote.olonerp.eu).
# hbb_common is a submodule, so its few lines are changed here, on the build machine, after checkout; the one line
# of src/common.rs too, so that every change to RustDesk's source is in this file.
# Every change is checked; the build stops if RustDesk's source no longer looks as expected.
set -euo pipefail
cd "$(dirname "$0")/.."
f=libs/hbb_common/src/config.rs

swap() { # file, exact old text, new text
  grep -qF -- "$2" "$1" || { echo "olon/apply.sh: not found in $1: $2" >&2; exit 1; }
  python3 - "$1" "$2" "$3" <<'PY'
import sys
p, old, new = sys.argv[1:4]
s = open(p, encoding="utf-8").read()
assert s.count(old) == 1, f"expected one {old!r} in {p}, found {s.count(old)}"
open(p, "w", encoding="utf-8", newline="").write(s.replace(old, new))
PY
}

# Our server and its public key (not a secret: every client carries it).
swap "$f" 'pub const RENDEZVOUS_SERVERS: &[&str] = &["rs-ny.rustdesk.com"];' \
          'pub const RENDEZVOUS_SERVERS: &[&str] = &["remote.olonerp.eu"];'
swap "$f" 'pub const RS_PUB_KEY: &str = "OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=";' \
          'pub const RS_PUB_KEY: &str = "8SgswV6kZC6T8s0SGycP9Y8Z9QLEHhP+xCIiS4hPUHM=";'
# The name: RustDesk installs only a name of [a-zA-Z0-9-]+ (ui_interface.rs), so no space and no Greek.
swap "$f" 'pub static ref APP_NAME: RwLock<String> = RwLock::new("RustDesk".to_owned());' \
          'pub static ref APP_NAME: RwLock<String> = RwLock::new("OLON-Support".to_owned());'
# The customer sees no server or network settings to change by mistake.
swap "$f" 'pub static ref BUILTIN_SETTINGS: RwLock<HashMap<String, String>> = Default::default();' \
          'pub static ref BUILTIN_SETTINGS: RwLock<HashMap<String, String>> = RwLock::new(HashMap::from([("hide-server-settings".to_owned(), "Y".to_owned()), ("hide-network-settings".to_owned(), "Y".to_owned()), ("hide-proxy-settings".to_owned(), "Y".to_owned()), ("hide-websocket-settings".to_owned(), "Y".to_owned())]));'

# No «For faster connection, please set up your own server» beside «Ready»: RustDesk counts every client with an
# empty custom-rendezvous-server as being on its public servers, even when the built-in server is ours. Public only
# if the server in use is rustdesk.com (the same test get_local_option already makes).
swap src/common.rs '    crate::get_custom_rendezvous_server(get_option("custom-rendezvous-server")).is_empty()' \
                   '    crate::get_custom_rendezvous_server(get_option("custom-rendezvous-server")).is_empty() && is_public(&Config::get_rendezvous_server())'

grep -c 'remote.olonerp.eu\|8SgswV6kZC6T8s0SGycP9Y8Z9QLEHhP+xCIiS4hPUHM=\|"OLON-Support"\|hide-network-settings' "$f"
grep -cF 'is_empty() && is_public(&Config::get_rendezvous_server())' src/common.rs
echo "OLON_APPLY_OK"
