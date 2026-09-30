#!/usr/bin/env python3
"""review-aid のデータ(JSON)をテンプレートに流し込み、1枚の HTML を作る。

使い方:
    python3 build.py <data.json> <output.html> [--mode local|artifact]

- local（既定）: ブラウザで直接開ける完全な HTML を出力する
- artifact: Claude の Artifact として公開する前提の HTML を出力する
  （doctype などはビューアが付けるので付けない）

どちらのモードでも Mermaid はテンプレートが CDN から読み込んで描画する。
"""
import argparse
import html
import json
import sys
from pathlib import Path

TEMPLATE = Path(__file__).resolve().parent.parent / "assets" / "template.html"
PLACEHOLDER = "window.REVIEW_AID = __REVIEW_AID_DATA__;"
REQUIRED_TOP = ("meta", "learn", "review")
LEVELS = {"must", "sug", "minor", "check", "ok"}
EVIDENCE = {"R1", "R2", "R3", "R4", "R5"}


def validate(data):
    """描画が壊れる、またはルール違反になる典型的な誤りを検出する。"""
    errors, warnings = [], []
    for k in REQUIRED_TOP:
        if k not in data:
            errors.append(f"トップレベルに '{k}' がない")
    change_ids = set()
    for part in data.get("review", {}).get("parts", []):
        for c in part.get("changes", []):
            cid = c.get("id")
            if not cid:
                errors.append(f"part '{part.get('id')}' に id の無い change がある")
                continue
            if cid in change_ids:
                errors.append(f"change id '{cid}' が重複している")
            change_ids.add(cid)
            for f in c.get("ai", []):
                where = f"change '{cid}' の指摘「{f.get('short', '')[:20]}」"
                if f.get("lv") not in LEVELS:
                    errors.append(f"{where}: lv が不正（{f.get('lv')}）")
                if f.get("ev") not in EVIDENCE:
                    errors.append(f"{where}: ev が不正（{f.get('ev')}）")
                if f.get("lv") == "ok" and f.get("ev") == "R5":
                    errors.append(f"{where}: R5 の根拠は「問題なし」にできない（check にする）")
                if not f.get("short"):
                    warnings.append(f"{where}: short（ひとこと）が無い")
                if f.get("lv") in ("must", "sug", "minor") and not f.get("why"):
                    warnings.append(f"{where}: 判断が要る指摘に why / view / options が無い")
                if f.get("lv") == "check" and not f.get("resolve"):
                    warnings.append(f"{where}: 要確認に resolve（何を確認すれば決着するか）が無い")
                if f.get("lv") != "ok" and not f.get("draft"):
                    warnings.append(f"{where}: PR コメントの draft が無い")
    for t in data.get("review", {}).get("trace", []):
        if t.get("change") and t["change"] not in change_ids:
            errors.append(f"trace の change '{t['change']}' に対応する change が無い")
    section_ids = [s.get("id") for s in data.get("learn", {}).get("sections", [])]
    dup = {i for i in section_ids if section_ids.count(i) > 1}
    if dup:
        errors.append(f"learn の section id が重複している: {sorted(dup)}")
    clash = change_ids & set(section_ids)
    if clash:
        errors.append(f"learn と review で id が衝突している: {sorted(clash)}")
    return errors, warnings


def build(data, mode):
    tpl = TEMPLATE.read_text(encoding="utf-8")
    # </script> を含む文字列があってもスクリプトが途中で閉じないようにする
    payload = json.dumps(data, ensure_ascii=False).replace("</", "<\\/")
    if tpl.count(PLACEHOLDER) != 1:
        sys.exit("error: テンプレートのプレースホルダーが見つからない")
    out = tpl.replace(PLACEHOLDER, "window.REVIEW_AID = " + payload + ";", 1)
    title = html.escape(data.get("meta", {}).get("title") or "Review Aid")
    out = out.replace("<title>Review Aid</title>", f"<title>{title}</title>", 1)
    if mode == "local":
        out = "<!doctype html>\n<html lang=\"ja\">\n" + out + "\n</html>\n"
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("data")
    ap.add_argument("output")
    ap.add_argument("--mode", choices=("local", "artifact"), default="local")
    args = ap.parse_args()

    data = json.loads(Path(args.data).read_text(encoding="utf-8"))
    errors, warnings = validate(data)
    for w in warnings:
        print(f"warning: {w}", file=sys.stderr)
    if errors:
        for e in errors:
            print(f"error: {e}", file=sys.stderr)
        sys.exit(1)

    out_path = Path(args.output).expanduser()
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(build(data, args.mode), encoding="utf-8")
    print(f"wrote {out_path} ({args.mode})")


if __name__ == "__main__":
    main()
