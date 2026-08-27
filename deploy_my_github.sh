#!/usr/bin/env bash
# ============================================================
# 部署利率曲线网站到你的 GitHub 账号
# 用法：在本文件夹空白处右键 → Git Bash Here → 运行：
#       bash deploy_my_github.sh
# 前提：已装 Git for Windows；已在 github.com 创建一个【空】仓库（不加 README）
# ============================================================
set -e
cd "$(dirname "$0")"

echo "=================================================="
echo "  部署利率曲线网站到你的 GitHub"
echo "=================================================="
echo ""
read -p "你的 GitHub 用户名: " USER
read -p "仓库名（建议 bond-yield-curve）: " REPO
echo ""
echo "提示：仓库需先在 github.com 创建为【空仓库】（不要勾选 Add README/.gitignore）"
echo "      免费个人版 GitHub Pages 需仓库为 Public。"
read -p "确认已创建空仓库？回车继续 / Ctrl+C 取消: " _

REMOTE="https://github.com/$USER/$REPO.git"
echo ""
echo ">>> 初始化 git 仓库..."
rm -rf .git
git init -b main >/dev/null 2>&1
git config user.name "workbuddy-deploy"
git config user.email "workbuddy@users.noreply.github.com"

echo ">>> 添加全部文件（含数据、资源、CI 配置）..."
git add -A
STAGED=$(git diff --cached --name-only | wc -l)
echo "    已暂存 $STAGED 个文件"

echo ">>> 提交..."
git commit -q -m "integrate preset-rate-research + offline fallback + title fix (v3)"

echo ">>> 关联远程仓库: $REMOTE"
git remote add origin "$REMOTE"

echo ">>> 推送到 main 分支..."
echo "    （首次推送会弹出 GitHub 登录窗口，按提示登录/授权即可）"
git push -u origin main

echo ""
echo "=================================================="
echo "  ✅ 推送成功！接下来在浏览器完成 2 步："
echo "=================================================="
echo ""
echo "【第1步】启用 Pages"
echo "  打开 https://github.com/$USER/$REPO/settings/pages"
echo "  → Build and deployment → Source 选 'GitHub Actions' → Save"
echo ""
echo "【第2步】触发部署"
echo "  打开 https://github.com/$USER/$REPO/actions"
echo "  → 选 'update-18-chinabond-yield-curves-and-deploy'"
echo "  → 右侧 Run workflow → 分支 main → 绿色 Run workflow"
echo "  → 等运行记录变绿对勾后访问："
echo "  👉 https://$USER.github.io/$REPO/   （按 Ctrl+F5 强制刷新）"
echo ""
echo "之后每工作日 cron 自动抓取中债登数据并更新部署（CI 配置保留）。"
echo ""
read -p "完成。回车关闭窗口。" _
