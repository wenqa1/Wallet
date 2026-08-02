#!/usr/bin/env python3
"""读取 coverage/lcov.info，打印 lib/ 各业务文件行覆盖率。"""

import os
import sys


def main():
    lcov = os.path.join("coverage", "lcov.info")
    if not os.path.exists(lcov):
        print("未找到 coverage/lcov.info，先运行 flutter test --coverage")
        sys.exit(1)

    files = {}
    cur = None
    with open(lcov, encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.strip()
            if line.startswith("SF:"):
                cur = line[3:].replace("\\", "/")
                files[cur] = [0, 0]
            elif line.startswith("LF:"):
                files[cur][0] += int(line[3:])
            elif line.startswith("LH:"):
                files[cur][1] += int(line[3:])

    rows = []
    for k, (lf, lh) in files.items():
        if not k.startswith("lib/") or ".g.dart" in k:
            continue
        name = k[4:]
        pct = lh / lf * 100 if lf else 0
        rows.append((pct, name, lh, lf))

    rows.sort()
    print(f"lib/ 业务文件数: {len(rows)}")
    for pct, name, lh, lf in rows:
        print(f"{pct:5.1f}%  {lh:3}/{lf:<3}  {name}")


if __name__ == "__main__":
    main()
