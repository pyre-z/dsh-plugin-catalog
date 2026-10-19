# dsh-plugin-catalog（私有镜像）

存放 npm 包 [`dsh-plugin-catalog`](https://www.npmjs.com/package/dsh-plugin-catalog) 的 `index.json`，
即下面这个 CDN 链接指向的文件：

```
https://cdn.jsdelivr.net/npm/dsh-plugin-catalog/index.json
```

## 当前快照

| 项 | 值 |
| --- | --- |
| 版本 | `2026.1019.8082` |
| 文件大小 | 2,390,028 字节 |
| 插件条目 | 3,036 |
| sha256 | `02919f4c1febf279442135197ffbe0586b4dce51d8cf38c2658c1710d02e2d54` |
| 抓取日期 | 2026-10-19 |

版本号同时记录在 `.version` 文件里，方便脚本比对。

## 数据来源

- jsDelivr npm CDN：`https://cdn.jsdelivr.net/npm/dsh-plugin-catalog@<版本>/index.json`
- npm 原始 tarball：`https://registry.npmjs.org/dsh-plugin-catalog/-/dsh-plugin-catalog-<版本>.tgz`（包内即本文件）
- 上游官网直链：`https://awesome-dsh-plugin.com/index.json`（GitHub Pages 托管）
- 上游仓库：`https://github.com/awesome-dsh-plugin/awesome-dsh-plugin`

许可：上游为 CC0-1.0，本镜像沿用。

## 更新快照

```bash
bash sync.sh
```

脚本会读取 npm 的 `latest` 标签、下载对应版本、校验 JSON 可解析后覆盖 `index.json` 并更新 `.version`；
**不会自动 commit**，改动确认后自行提交。

## 注意

本仓库是**私有**仓库，因此 `cdn.jsdelivr.net/gh/pyre-z/dsh-plugin-catalog@main/index.json` 这类
jsDelivr GitHub 加速地址无法使用（jsDelivr 只索引公开仓库）。若需要 CDN 直链，请改用上面的 npm CDN 或上游官网。
