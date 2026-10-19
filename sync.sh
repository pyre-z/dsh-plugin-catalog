#!/usr/bin/env bash
# 同步 npm 包 dsh-plugin-catalog 的 index.json 到本仓库
set -euo pipefail
cd "$(dirname "$0")"

VER=$(curl -fsSL https://registry.npmjs.org/dsh-plugin-catalog \
  | python3 -c 'import json,sys;print(json.load(sys.stdin)["dist-tags"]["latest"])')
echo "npm latest: ${VER}"

OLD=""
[ -f .version ] && OLD=$(cat .version)
echo "local      : ${OLD:-<none>}"

curl -fsSL -o index.json.tmp \
  "https://cdn.jsdelivr.net/npm/dsh-plugin-catalog@${VER}/index.json"

# 校验可解析且结构正确，失败则保留旧文件
python3 - <<'PY'
import json, sys
d = json.load(open('index.json.tmp'))
assert d.get('format') == 1, 'unexpected format'
req = ['title', 'description', 'metadata', 'plugins']
missing = [k for k in req if k not in d]
assert not missing, f'missing keys: {missing}'
print(f"ok: format={d['format']} plugins={len(d['plugins'])}")
PY

mv index.json.tmp index.json
echo "$VER" > .version
sha256sum index.json
