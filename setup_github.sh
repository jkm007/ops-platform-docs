#!/bin/bash
# GitHub 仓库初始化和文档上传脚本
# 用法: bash setup_github.sh

TOKEN="$1"
if [ -z "$TOKEN" ]; then
    echo "用法: bash setup_github.sh <github_token>"
    exit 1
fi

echo "=== 验证 Token ==="
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $TOKEN" https://api.github.com/user)
if [ "$STATUS" != "200" ]; then
    echo "Token 无效，HTTP $STATUS"
    exit 1
fi
echo "Token 有效"

echo ""
echo "=== 创建仓库 ==="

for REPO in ops-platform-backend ops-platform-frontend ops-platform-agent ops-platform-docs; do
    echo "创建 $REPO ..."
    RESP=$(curl -s -X POST https://api.github.com/user/repos \
        -H "Authorization: token $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"name\":\"$REPO\",\"description\":\"运维内网管理系统 - $REPO\",\"private\":true}")
    
    if echo "$RESP" | grep -q '"html_url"'; then
        URL=$(echo "$RESP" | grep '"html_url"' | head -1 | cut -d'"' -f4)
        echo "  ✅ $URL"
    elif echo "$RESP" | grep -q '"already exists"'; then
        echo "  ⚠️ 已存在，跳过"
    else
        echo "  ❌ 失败: $(echo $RESP | head -c 200)"
    fi
done

echo ""
echo "=== Push 文档到 ops-platform-docs ==="
cd /Users/hushaojie/运维内容管理系统

# 初始化 git
if [ ! -d ".git" ]; then
    git init
fi

git config user.email "ops@platform.local"
git config user.name "Ops Platform"

# 创建 .gitignore
cat > .gitignore << 'GITIGNORE'
.DS_Store
*.docx
*.tar.gz
GITIGNORE

git add *.md .gitignore 2>/dev/null
git status

echo ""
echo "=== 完成！现在手动 push ==="
echo "cd /Users/hushaojie/运维内容管理系统"
echo "git remote add origin https://github.com/jkm007/ops-platform-docs.git"
echo "git branch -M main"
echo "git push -u origin main"
