#!/usr/bin/env bash
# Program: CAP_Postgres Start Script
# Author: ORBAICODER
# Version: 1.0.1
# Date: 2025-09-27
# Outline:
#  - 加载 .env 环境变量（若存在）
#  - 解析参数：mode [watch|start]、--profile、--port
#  - 根据模式启动：
#      * watch => npx cds watch --profile <profile>
#      * start => npm start (node server.js)
#  - 打印实际生效端口（未设置则为 CAP 默认 4004）
#  - 示例：
#      * ./start.sh                 # 默认：watch + production
#      * ./start.sh watch --profile development
#      * ./start.sh start --profile production --port 4004

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 加载 .env（若存在），自动导出变量到环境
if [[ -f "$ROOT_DIR/.env" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ROOT_DIR/.env"
  set +a
fi

MODE="watch"           # watch | start
PROFILE="production"   # production | development

while [[ $# -gt 0 ]]; do
  case "$1" in
    watch|start)
      MODE="$1"; shift ;;
    --profile)
      PROFILE="${2:-$PROFILE}"; shift 2 ;;
    --port)
      export PORT="${2}"; shift 2 ;;
    -h|--help)
      echo "Usage: $0 [watch|start] [--profile <production|development>] [--port <number>]"
      exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

echo "==> Mode: $MODE"
echo "==> Profile: $PROFILE"
# 计算并打印实际生效端口（未设置则为 CAP 默认 4004）
EFFECTIVE_PORT="${PORT:-4004}"
echo "==> Effective Port: ${EFFECTIVE_PORT}"

if [[ "$MODE" == "watch" ]]; then
  exec npx cds watch --profile "$PROFILE"
else
  # start 模式：使用 package.json 的 start 脚本（node server.js）
  exec npm start --silent
fi
