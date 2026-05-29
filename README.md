# claude-skills

Owen 的 Claude Code skill 集合，一鍵安裝到本機 `~/.claude/skills/`。

## 安裝

**Windows 用戶**：需使用 **Git Bash** 執行（PowerShell/CMD 不支援，WSL 會裝到錯誤路徑）。

```bash
# clone 或下載解壓後，進入目錄
bash install.sh
```

## 指令

```bash
bash install.sh                        # 安裝全部（已存在略過）
bash install.sh --update               # 強制更新全部
bash install.sh --install-one <name>   # 安裝單一 skill
bash install.sh --list                 # 列出已安裝的 skill
```

## Skills 清單

| Skill | 說明 |
|-------|------|
| `mock-interview` | 模擬技術面試，針對 JD 產生深度提問 |
| `karpathy-guidelines` | Karpathy 編碼原則 |
| `job-intel-taiwan` | 台灣求職目標公司情蒐 |
| `stock-market-analyst` | 台股／美股／ETF 結構性分析 |
| `session-handoff` | 跨 session context 保存與移交 |

## 新增 Skill 流程

1. 在 `skills/` 下建立新目錄，放入 `SKILL.md`
2. 更新 `skills.json` 登記來源資訊
3. `bash install.sh --install-one <name>`

## 目錄結構

```
claude-skills/
├── skills/
│   ├── mock-interview/SKILL.md
│   ├── karpathy-guidelines/SKILL.md
│   ├── job-intel-taiwan/SKILL.md
│   ├── stock-market-analyst/
│   │   ├── SKILL.md
│   │   └── references/
│   └── session-handoff/
│       ├── SKILL.md
│       ├── scripts/
│       ├── references/
│       └── evals/
├── install.sh
├── skills.json
└── README.md
```
