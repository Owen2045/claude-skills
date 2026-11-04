# claude-skills

Owen 的 Claude Code 插件集合。整個 repo 是一個 Claude Code marketplace（`owen-skills`），每個 skill 都是可以單獨安裝的插件。

## 安裝

在 Claude Code 對話框輸入（Windows、macOS、Linux 都一樣，不需要 Git Bash）：

```
/plugin marketplace add Owen2045/claude-skills
```

然後裝需要的插件：

```
/plugin install change-flow@owen-skills
/plugin install coding-principles@owen-skills
/plugin install perf-measurement@owen-skills
/plugin install task-framing@owen-skills
/plugin install jira-log@owen-skills
/plugin install mock-interview@owen-skills
/plugin install job-intel-taiwan@owen-skills
/plugin install stock-market-analyst@owen-skills
```

也可以輸入 `/plugin` 用選單安裝。裝完執行 `/reload-plugins` 或開新對話生效。

更新：`/plugin marketplace update owen-skills`。移除：`/plugin uninstall <name>@owen-skills`。

## 插件清單

| 插件 | 中文名 | 說明 |
|------|------|------|
| `change-flow` | 炸夢! | 非小改動的寫程式流程：先列爆炸範圍、最小改動，改完派 `blast-radius` 與 `verifier` 兩個唯讀 sub-agent 平行檢查。開 session 時注入寫程式原則。 |
| `coding-principles` | 我的做法，我的做人 | 五條寫程式原則（質疑前提、冪等操作、先分離再序列化共享狀態、把教訓寫進結構、拆成可驗證小單元），agent 依情境自動套用。改寫自 pstack。 |
| `perf-measurement` | 效能量測 | 回報或依據效能數字行動前，先找出瓶頸並排除量錯東西；附 benchmark 檢查清單。改寫自 pstack。 |
| `task-framing` | 任務釐清 | 手動呼叫：`/sharpen` 把任務做深再改寫 prompt，`/in-your-own-words` 複述使用者目標。改寫自 pstack。 |
| `jira-log` | Jira 紀錄 | `/jira-project`：把對話整理成 sub-task（標題＋內文）與主 task 摘要（已完成／進行中／待確認），存 `jira-project.md`。`/jira-timeline`：在工作目錄根目錄 `jira-log.md` 記錄需求方何時提供什麼檔案、進度與卡點，開啟後讀到對方檔案會自動記一行。 |
| `mock-interview` | 盲嗑面試 | 模擬技術面試，針對 JD 產生深度提問 |
| `job-intel-taiwan` | 公司背景屌插菊 | 台灣求職目標公司情蒐 |
| `stock-market-analyst` | 一張不賣，奇蹟自來 | 台股／美股／ETF 結構性分析 |

## 新增插件

**只有一個 skill**：在 `skills/` 下建目錄放 `SKILL.md`，再到 `.claude-plugin/marketplace.json` 加一筆：

```json
{ "name": "<name>", "source": "./", "description": "...", "skills": ["./skills/<name>"] }
```

**有 hook 或 sub-agent**：在 `plugins/<name>/` 下建完整插件（參考 `plugins/change-flow/`），marketplace 那筆的 `source` 指向 `./plugins/<name>`。

改完用 `claude plugin validate .` 檢查。

## 目錄結構

```
claude-skills/
├── .claude-plugin/marketplace.json   # marketplace 清單，定義每個插件
├── plugins/
│   ├── change-flow/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── skills/change-flow/SKILL.md
│   │   ├── agents/blast-radius.md, verifier.md
│   │   └── hooks/hooks.json, session-start.js, rules.md
│   ├── coding-principles/            # 5 個 principle-* skill
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/principle-*/SKILL.md
│   ├── perf-measurement/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/benchmark-checklist/, principle-explain-the-number/
│   ├── task-framing/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/sharpen/, in-your-own-words/
│   └── jira-log/
│       ├── .claude-plugin/plugin.json
│       └── skills/jira-project/, jira-timeline/
└── skills/                           # 單一 skill 插件
    ├── mock-interview/
    ├── job-intel-taiwan/
    ├── stock-market-analyst/
```
