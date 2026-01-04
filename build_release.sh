#!/bin/bash

# MouseKeepAlive Release Build Script
# 用于构建正式发布版本

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
APP_NAME="MouseKeepAlive"
PROJECT_NAME="MouseKeepAlive.xcodeproj"
SCHEME="MouseKeepAlive"
CONFIGURATION="Release"
BUILD_DIR="build"
ARCHIVE_PATH="${BUILD_DIR}/${APP_NAME}.xcarchive"
EXPORT_PATH="${BUILD_DIR}/Release"
APP_PATH="${EXPORT_PATH}/${APP_NAME}.app"
ZIP_NAME="${APP_NAME}.app.zip"

echo -e "${GREEN}🚀 开始构建 ${APP_NAME} Release 版本${NC}"
echo ""

# 检查 Xcode 是否安装
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ 错误: 未找到 xcodebuild 命令${NC}"
    echo "请确保已安装 Xcode 并配置了命令行工具"
    exit 1
fi

# 清理旧的构建目录
echo -e "${YELLOW}🧹 清理旧的构建文件...${NC}"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# 清理 Xcode 构建缓存
echo -e "${YELLOW}🧹 清理 Xcode 构建缓存...${NC}"
xcodebuild clean \
    -project "${PROJECT_NAME}" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}"

# 构建项目
echo -e "${YELLOW}🔨 构建项目...${NC}"
xcodebuild \
    -project "${PROJECT_NAME}" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -derivedDataPath "${BUILD_DIR}/DerivedData" \
    build

# 复制 .app 到 Release 目录
echo -e "${YELLOW}📦 复制应用程序...${NC}"
mkdir -p "${EXPORT_PATH}"
cp -R "${BUILD_DIR}/DerivedData/Build/Products/${CONFIGURATION}/${APP_NAME}.app" "${APP_PATH}"

# 检查应用是否构建成功
if [ ! -d "${APP_PATH}" ]; then
    echo -e "${RED}❌ 错误: 应用构建失败${NC}"
    exit 1
fi

# 显示应用信息
echo -e "${GREEN}✅ 应用构建成功！${NC}"
echo ""
echo "应用路径: ${APP_PATH}"
echo "应用大小: $(du -sh "${APP_PATH}" | cut -f1)"
echo ""

# 验证应用签名（如果有）
echo -e "${YELLOW}🔍 检查应用签名...${NC}"
codesign -dv "${APP_PATH}" 2>&1 | grep -E "Authority|Identifier|TeamIdentifier" || echo "未签名的应用"
echo ""

# 创建 DMG 安装包
DMG_NAME="${APP_NAME}.dmg"
echo -e "${YELLOW}📀 创建 DMG 安装包...${NC}"

# 创建临时目录
TMP_DMG_DIR="${BUILD_DIR}/dmg_temp"
mkdir -p "${TMP_DMG_DIR}"

# 复制应用到临时目录
cp -R "${APP_PATH}" "${TMP_DMG_DIR}/"

# 创建应用程序文件夹的符号链接
ln -s /Applications "${TMP_DMG_DIR}/Applications"

# 创建 DMG
hdiutil create \
    -volname "${APP_NAME}" \
    -srcfolder "${TMP_DMG_DIR}" \
    -ov \
    -format UDZO \
    "${EXPORT_PATH}/${DMG_NAME}"

echo -e "${GREEN}✅ DMG 创建成功: ${EXPORT_PATH}/${DMG_NAME}${NC}"
echo "DMG 大小: $(du -sh "${EXPORT_PATH}/${DMG_NAME}" | cut -f1)"
echo ""

# 计算 DMG 的 SHA256 校验和
echo -e "${YELLOW}🔐 计算 DMG SHA256 校验和...${NC}"
shasum -a 256 "${EXPORT_PATH}/${DMG_NAME}" > "${EXPORT_PATH}/${DMG_NAME}.sha256"
cat "${EXPORT_PATH}/${DMG_NAME}.sha256"
echo ""

# 清理临时目录
rm -rf "${TMP_DMG_DIR}"

# 创建 ZIP 压缩包
echo -e "${YELLOW}🗜️  创建 ZIP 压缩包...${NC}"
cd "${EXPORT_PATH}"
zip -r -q "${ZIP_NAME}" "${APP_NAME}.app"
cd - > /dev/null

echo -e "${GREEN}✅ ZIP 创建成功: ${EXPORT_PATH}/${ZIP_NAME}${NC}"
echo "ZIP 大小: $(du -sh "${EXPORT_PATH}/${ZIP_NAME}" | cut -f1)"
echo ""

# 计算 SHA256 校验和
echo -e "${YELLOW}🔐 计算 SHA256 校验和...${NC}"
shasum -a 256 "${EXPORT_PATH}/${ZIP_NAME}" > "${EXPORT_PATH}/${ZIP_NAME}.sha256"
cat "${EXPORT_PATH}/${ZIP_NAME}.sha256"
echo ""

# 完成
echo -e "${GREEN}🎉 构建完成！${NC}"
echo ""
echo "发布文件位于: ${EXPORT_PATH}/"
echo ""
echo "下一步："
echo "1. 测试应用是否正常运行"
echo "2. 创建 GitHub Release"
echo "3. 上传以下文件到 Release:"
echo "   - ${DMG_NAME}"
echo "   - ${DMG_NAME}.sha256"
echo ""
echo "创建 Release 的命令示例:"
echo "gh release create v1.0.1 '${EXPORT_PATH}/${DMG_NAME}' '${EXPORT_PATH}/${DMG_NAME}.sha256' --title 'v1.0.1' --notes '发布说明'"
