#!/bin/bash

TARGET="$HOME/Downloads"
OUTPUT_FILE="resault_lab.txt"

echo "----------------------------------------------------------"
echo "🔎 PEEP: $TARGET"
echo "🚫 FROM: ANNACTF"
echo "----------------------------------------------------------"

echo "DOWNLOADS FOLDER SCAN REPORT" > "$OUTPUT_FILE"
echo "Scan Time: $(date)" >> "$OUTPUT_FILE"
echo "Target Directory: $TARGET" >> "$OUTPUT_FILE"
echo "----------------------------------------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ -d "$TARGET" ]; then
    find "$TARGET" -name "*Adobe*" -type d -prune -o -print | while read -r item; do
        if [ -d "$item" ]; then
            if [ "$item" != "$TARGET" ]; then
                echo "[FOLD] $item" >> "$OUTPUT_FILE"
            fi
        else
            echo "  |_ [FILE] $item" >> "$OUTPUT_FILE"
        fi
    done

    echo "✅ Done!"
else
    echo "❌ Target folder not found!"
fi

if [ -f "$PYTHON_SCRIPT" ]; then
    echo "🐍 Running: $PYTHON_SCRIPT..."
    echo "----------------------------------------------------------"
    python "$PYTHON_SCRIPT"
else
    echo "ERROR"
fi