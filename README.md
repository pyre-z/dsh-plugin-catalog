# dsh-plugin-catalog（镜像）

存放 npm 包 [`dsh-plugin-catalog`](https://www.npmjs.com/package/dsh-plugin-catalog) 的 `index.json` ——
[awesome-dsh-plugin.com](https://awesome-dsh-plugin.com) 社区维护的 DeepSeek Harness（dsh）插件目录快照。

本仓库只做**镜像与分发**：所有内容来自上游（CC0-1.0 许可），不添加自有数据。

## 可用直链

| 途径 | 地址 | 说明 |
| --- | --- | --- |
| jsDelivr（本仓库） | `https://cdn.jsdelivr.net/gh/pyre-z/dsh-plugin-catalog@main/index.json` | 首次访问由 jsDelivr 回源抓取 |
| jsDelivr（npm 上游） | `https://cdn.jsdelivr.net/npm/dsh-plugin-catalog/index.json` | 直接取 npm 包，与本仓库无关 |
| 上游官网 | `https://awesome-dsh-plugin.com/index.json` | 数据源站（GitHub Pages） |

## 当前快照

| 项 | 值 |
| --- | --- |
| 版本 | `2026.1114.20961` |
| 文件大小 | 4,580,866 字节 |
| 插件条目 | 5,643 |
| sha256 | `bb7091c8a387437c07018ef98efcfce3d2937140ba8a1b115279fe6fdf31876f` |
| 记录日期 | 2026-11-16 |

> 本表是手动更新的，可能滞后。**权威版本号以 `.version` 文件为准**，字节级校验请对仓库里的 `index.json` 直接算 sha256。

## 数据来源

- jsDelivr npm CDN：`https://cdn.jsdelivr.net/npm/dsh-plugin-catalog@<版本>/index.json`
- npm 原始 tarball：`https://registry.npmjs.org/dsh-plugin-catalog/-/dsh-plugin-catalog-<版本>.tgz`（包内即本文件）
- 上游官网直链：`https://awesome-dsh-plugin.com/index.json`（GitHub Pages 托管）
- 上游仓库：`https://github.com/awesome-dsh-plugin/awesome-dsh-plugin`

许可：上游为 [CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0/)，本镜像沿用；
仓库内的 `LICENSE` 与上游 npm 包内同名文件逐字节相同（7,048 字节，sha256 `a2010f34…`）。

## 更新快照

### 自动（GitHub Actions）

`.github/workflows/sync-index.yml` 用两条 cron（`17 3` 与 `17 13` UTC）检查 npm `latest`，
发现新版本就更新 `index.json` + `.version` 并提交推送；版本没变则直接跳过，不产生空提交。

- **注意**：GitHub 对 scheduled workflow 有 5～8 小时排队延迟，实测单条 cron 落地时刻在 16:30～19:00 CST 之间浮动，
  所以不保证「几点几分」精确执行，只保证**高频刷新**（两条错开 10 小时，最长陈旧约 12 小时）
- 手动触发：仓库 Actions 页 → `Sync index.json` → **Run workflow**
- 运行摘要会写明当前版本、文件大小与 sha256
- 自动提交由 `github-actions[bot]` 完成，**不带 GPG 签名**（GitHub 会标 Unverified，属预期）

### 手动（本地）

```bash
bash sync.sh
```

读取 npm 的 `latest` 标签 → 下载 → 校验 JSON 结构 → 覆盖 `index.json` 并更新 `.version`，
但**不会自动 commit**，改动确认后自行提交。

## 限制与注意事项

- **jsDelivr 单文件上限 20 MB**。本文件在 2026-10-20 是 2.39 MB、2026-11-14 已 4.58 MB，
  按当前增长速度将来可能触顶；届时 `/gh/` 与 `/npm/` 都会失效，需要改用其他分发方式。
- 本仓库是**公开**仓库，任何人可读取与 fork；其中不含任何密钥（凭据只存在于 GitHub Secrets）。
- 上游数据由社区维护，本仓库不保证内容准确性与可用性，仅保证与上游同步。
- 本仓库是镜像，**请不要在此提交上游数据的修改**，问题请反馈到上游仓库。
