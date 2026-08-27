#!/usr/bin/env bash
# 一键部署：将修改后的利率曲线网站推送到 harry-li-sf/Bond-yield-curve
# 用法：在本工作空间根目录运行 bash bond_yield_site_modified/deploy_to_github.sh
# 注意：push 时需要 GitHub 写权限（会弹出凭据管理器或要求 token）
set -e

SRC="$(cd "$(dirname "$0")" && pwd)"
REPO_URL="https://github.com/harry-li-sf/Bond-yield-curve.git"
DEPLOY_DIR="$SRC/_deploy_repo"

echo "=== 1. 克隆仓库（depth 1）==="
rm -rf "$DEPLOY_DIR"
git clone --depth 1 "$REPO_URL" "$DEPLOY_DIR"
cd "$DEPLOY_DIR"

echo "=== 2. 复制修改/新增文件 ==="
# 修改文件
cp "$SRC/index.html" index.html
# 新增文件
cp "$SRC/offline_snapshot.js" offline_snapshot.js
mkdir -p data
cp "$SRC/data/actuals.json" data/actuals.json
cp "$SRC/data/predictions.json" data/predictions.json
cp "$SRC/prediction_views.html" prediction_views.html
cp "$SRC/formula_report.html" formula_report.html
cp "$SRC/trigger_analysis_report.html" trigger_analysis_report.html

echo "=== 3. 暂存并提交 ==="
git add index.html offline_snapshot.js data/actuals.json data/predictions.json prediction_views.html formula_report.html trigger_analysis_report.html
git config user.name "workbuddy-deploy"
git config user.email "workbuddy@users.noreply.github.com"
git commit -m "integrate preset-rate-research module + offline fallback + title fix

- 第三板块「预定利率研究值」整合参考网页(sig546)布局与功能(ECharts, 目标色系)
- 新增 data/actuals.json + data/predictions.json + 3 个报告页
- 新增 offline_snapshot.js 离线快照回退(file:// 下可用)
- 标题切换修复: base 按债券设主标题, premium/preset 固定标题
- 板块一/二逻辑与 ci_update 数据管道不变, 每日自动更新保留"

echo "=== 4. 推送（需要 GitHub 凭据）==="
echo "如推送被拒（远端有新提交），脚本会自动 rebase 后重试。"
if git push origin main; then
    echo "✅ 推送成功！GitHub Actions 将自动部署到 Pages。"
else
    echo "→ 远端有更新，rebase 后重试..."
    git pull --rebase origin main
    git push origin main
    echo "✅ 推送成功！GitHub Actions 将自动部署到 Pages。"
fi

echo ""
echo "部署后："
echo "  - push 触发 .github/workflows/update-data.yml（push 模式：仅 --derived-only + 部署）"
echo "  - 每工作日 cron 自动抓取中债登数据并部署（每日自动更新保留）"
echo "  - 访问 https://harry-li-sf.github.io/Bond-yield-curve/ （Ctrl+F5 强刷）"
