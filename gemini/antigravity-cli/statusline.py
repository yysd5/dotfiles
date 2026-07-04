#!/usr/bin/env python3
import sys
import json

def main():
    try:
        # CLIからのステータスJSONを標準入力から取得
        input_data = sys.stdin.read()
        if not input_data.strip():
            print("Agy CLI | No Data")
            return
        
        status = json.loads(input_data)
        
        # 渡されたデータをデバッグ用に保存する
        debug_path = "/Users/y_yoshida/.gemini/antigravity-cli/statusline_debug.json"
        try:
            with open(debug_path, "w", encoding="utf-8") as f:
                json.dump(status, f, indent=2, ensure_ascii=False)
        except Exception:
            pass # デバッグ保存の失敗は無視する

        # 各種ステータス情報の抽出を試みる
        model = status.get("model", "N/A")
        usage = status.get("usage", {})
        credits = status.get("credits", usage.get("credits", "N/A"))
        
        # ステータスラインに出力する文字列
        print(f"Model: {model} | Credits: {credits}")
        
    except Exception:
        print("Statusline Error")

if __name__ == "__main__":
    main()
