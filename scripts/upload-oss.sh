#!/usr/bin/env bash
# 把 index.json 上传到对象存储（S3 兼容）
#
# 全部配置走环境变量，仓库里不落任何桶名 / 区域 / 地址：
#   OSS_ACCESS_KEY_ID, OSS_ACCESS_KEY_SECRET   凭据（必填）
#   OSS_BUCKET                                 存储桶（必填）
#   OSS_REGION                                 区域 ID，不带 oss- 前缀（必填）
#   OSS_PREFIX                                 对象前缀（可选，默认 dsh-plugin-catalog；
#                                              设为空串则放到桶根目录）
#   OSS_RETRIES                                失败重试次数（可选，默认 3）
#
# 本脚本面向公开仓库使用：日志里只输出字节数与结果，
# 不打印桶名、区域、对象路径与公网地址。
set -euo pipefail
cd "$(dirname "$0")/.."

: "${OSS_ACCESS_KEY_ID:?未设置 OSS_ACCESS_KEY_ID}"
: "${OSS_ACCESS_KEY_SECRET:?未设置 OSS_ACCESS_KEY_SECRET}"
: "${OSS_BUCKET:?未设置 OSS_BUCKET}"
: "${OSS_REGION:?未设置 OSS_REGION}"

REGION="$OSS_REGION"
BUCKET="$OSS_BUCKET"
PREFIX="${OSS_PREFIX:-dsh-plugin-catalog}"
PREFIX="${PREFIX#/}"
PREFIX="${PREFIX%/}"

[ -f index.json ] || { echo "index.json 不存在，先运行 sync.sh" >&2; exit 1; }

if [ -n "$PREFIX" ]; then
  DEST="oss://${BUCKET}/${PREFIX}/index.json"
else
  DEST="oss://${BUCKET}/index.json"
fi

LOCAL_SIZE=$(stat -c%s index.json)
echo "开始上传：${LOCAL_SIZE} 字节"

# 上传可能因网络抖动卡住（曾出现 10 分钟挂死被 job 超时掐掉），
# 每条尝试包一层 timeout，失败后带退避重试
RETRIES="${OSS_RETRIES:-3}"
ATTEMPT=1
until timeout 240 ossutil cp -f index.json "$DEST" \
    --region "$REGION" \
    --storage-class Standard \
    --cache-control "public, max-age=300" \
    --connect-timeout 15 \
    --read-timeout 60 >/dev/null; do
  if [ "$ATTEMPT" -ge "$RETRIES" ]; then
    echo "上传连续失败 ${RETRIES} 次，放弃" >&2
    exit 1
  fi
  echo "第 ${ATTEMPT} 次上传失败，10 秒后重试（最多 ${RETRIES} 次）" >&2
  ATTEMPT=$((ATTEMPT + 1))
  sleep 10
done

# 回读校验：远端大小必须与本地一致
REMOTE_SIZE=$(ossutil stat "$DEST" --region "$REGION" 2>/dev/null \
  | awk -F: '/^Content-Length/{gsub(/[^0-9]/,"",$2); print $2; exit}')

if [ "$REMOTE_SIZE" != "$LOCAL_SIZE" ]; then
  echo "回读校验失败：远端 ${REMOTE_SIZE:-未知} 字节，本地 ${LOCAL_SIZE} 字节" >&2
  exit 1
fi

echo "上传完成并校验通过：${LOCAL_SIZE} 字节"

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  echo "- 对象存储已刷新：${LOCAL_SIZE} 字节（回读校验通过）" >> "$GITHUB_STEP_SUMMARY"
fi
