#!/bin/bash
# 在 Mac 上执行，创建 GitLab 仓库

GITLAB_URL="http://10.0.50.107/api/v4"
TOKEN="***GITLAB_TOKEN***"

echo "=== 创建后端仓库 ==="
curl -s -X POST "$GITLAB_URL/projects" \
  -H "PRIVATE-TOKEN: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ops-platform-backend",
    "description": "运维内网管理系统 - 后端 Go API 服务",
    "visibility": "private",
    "initialize_with_readme": true
  }' | python3 -m json.tool 2>/dev/null | grep -E '"id"|"web_url"|"name"'

echo ""
echo "=== 创建前端仓库 ==="
curl -s -X POST "$GITLAB_URL/projects" \
  -H "PRIVATE-TOKEN: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ops-platform-frontend",
    "description": "运维内网管理系统 - React 前端",
    "visibility": "private",
    "initialize_with_readme": true
  }' | python3 -m json.tool 2>/dev/null | grep -E '"id"|"web_url"|"name"'

echo ""
echo "=== 创建 Agent 仓库 ==="
curl -s -X POST "$GITLAB_URL/projects" \
  -H "PRIVATE-TOKEN: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ops-platform-agent",
    "description": "运维内网管理系统 - 宿主机 Agent",
    "visibility": "private",
    "initialize_with_readme": true
  }' | python3 -m json.tool 2>/dev/null | grep -E '"id"|"web_url"|"name"'

echo ""
echo "=== 创建文档仓库 ==="
curl -s -X POST "$GITLAB_URL/projects" \
  -H "PRIVATE-TOKEN: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ops-platform-docs",
    "description": "运维内网管理系统 - PRD、设计稿、文档",
    "visibility": "private",
    "initialize_with_readme": true
  }' | python3 -m json.tool 2>/dev/null | grep -E '"id"|"web_url"|"name"'

echo ""
echo "=== 仓库列表 ==="
curl -s "$GITLAB_URL/projects?per_page=10" \
  -H "PRIVATE-TOKEN: $TOKEN" | \
  python3 -m json.tool 2>/dev/null | grep -E '"name"|"web_url"' | head -20
