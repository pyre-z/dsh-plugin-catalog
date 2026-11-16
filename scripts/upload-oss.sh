#!/usr/bin/env bash
# 把 index.json 上传到阿里云 OSS
#
# 必需环境变量：
#   OSS_ACCESS_KEY_ID / OSS_ACCESS_KEY_SECRET
# 可选环境变量（括号内为默认值）：
#   OSS_REGION  (cn-chengdu)   区域 ID，不带 oss- 前缀
#   OSS_BUCKET  (pyre-z)       存储桶
#   OSS_PREFIX  (dsh-plugin-catalog)  对象前缀，留空则传到桶根目录
set -euo pipefail
cd "$(dirname "$0")/.."

: "${OSS_ACCESS_KEY_ID:?未设置 OSS_ACCESS_KEY_ID}"
: "${OSS_ACCESS_KEY_SECRET:?未设置 OSS_ACCESS_KEY_SECRET}"

REGION="${OSS_REGION:-cn-chengdu}"
BUCKET="${OSS_BUCKET:-pyre-z}"
PREFIX="${OSS_PREFIX:-dsh-plugin-catalog}"
PREFIX="${PREFIX#/}"
PREFIX="${PREFIX%/}"

[ -f index.json ] || { echo "index.json 不存在，先运行 sync.sh" >&2; exit 1; }

if [ -n "$PREFIX" ]; then
  DEST="oss://${BUCKET}/${PREFIX}/index.json"
else
  DEST="oss://${BUCKET}/index.json"
fi

echo "上传 $(stat -c%s index.json) 字节 -> ${DEST}（region=${REGION}）"

# 上传可能因网络抖动卡住（曾出现 10 分钟挂死被 job 超时掐掉），
# 每条尝试包一层 timeout，失败后带退避重试
RETRIES="${OSS_RETRIES:-3}"
ATTEMPT=1
until timeout 240 ossutil cp -f index.json "$DEST" \
    --region "$REGION" \
    --storage-class Standard \
    --cache-control "public, max-age=300" \
    --connect-timeout 15 \
    --read-timeout 60; do
  if [ "$ATTEMPT" -ge "$RETRIES" ]; then
    echo "上传连续失败 ${RETRIES} 次，放弃" >&2
    exit 1
  fi
  echo "第 ${ATTEMPT} 次上传失败，10 秒后重试（最多 ${RETRIES} 次）" >&2
  ATTEMPT=$((ATTEMPT + 1))
  sleep 10
done

echo "--- 远端对象信息 ---"
ossutil stat "$DEST" --region "$REGION"

URL="https://${BUCKET}.oss-${REGION}.aliyuncs.com/${PREFIX:+${PREFIX}/}index.json"
echo "公网地址：${URL}"

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  echo "- OSS 对象: \`${DEST}\`" >> "$GITHUB_STEP_SUMMARY"
  echo "- 公网地址: ${URL}" >> "$GITHUB_STEP_SUMMARY"
fi

