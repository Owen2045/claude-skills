# claude-skills

Owen 的 Claude Code 插件集合。整個 repo 是一個 Claude Code marketplace（`owen-skills`），每個 skill 都是可以單獨安裝的插件。

## 安裝

在 Claude Code 對話框輸入（Windows、macOS、Linux 都一樣，不需要 Git Bash）：

```
/plugin marketplace add Owen2045/claude-skills
```

然後裝需要的插件：

```
/plugin install owen-change-flow@owen-skills
/plugin install owen-coding-principles@owen-skills
/plugin install owen-perf-measurement@owen-skills
/plugin install owen-task-framing@owen-skills
/plugin install owen-jira-log@owen-skills
/plugin install owen-mock-interview@owen-skills
/plugin install owen-job-intel-taiwan@owen-skills
/plugin install owen-stock-market-analyst@owen-skills
```

也可以輸入 `/plugin` 用選單安裝。裝完執行 `/reload-plugins` 或開新對話生效。

更新：`/plugin marketplace update owen-skills`。移除：`/plugin uninstall <name>@owen-skills`。

## 插件清單

| 插件 | 中文名 | 說明 |
|------|------|------|
| `owen-change-flow` | 炸夢! | 非小改動的寫程式流程：先列爆炸範圍、最小改動，改完派 `blast-radius` 與 `verifier` 兩個唯讀 sub-agent 平行檢查。開 session 時注入寫程式原則。 |
| `owen-coding-principles` | 我的做法，我的做人 | 五條寫程式原則（質疑前提、冪等操作、先分離再序列化共享狀態、把教訓寫進結構、拆成可驗證小單元），agent 依情境自動套用。改寫自 pstack。 |
| `owen-perf-measurement` | 效能量測 | 回報或依據效能數字行動前，先找出瓶頸並排除量錯東西；附 benchmark 檢查清單。改寫自 pstack。 |
| `owen-task-framing` | 任務釐清 | 手動呼叫：`/owen-sharpen` 把任務做深再改寫 prompt，`/owen-in-your-own-words` 複述使用者目標。改寫自 pstack。 |
| `owen-jira-log` | Jira 紀錄 | `/owen-jira-project`：把對話整理成 sub-task（標題＋內文）與主 task 摘要（已完成／進行中／待確認），存 `jira-project.md`。`/owen-jira-timeline`：在工作目錄根目錄 `jira-log.md` 記錄需求方何時提供什麼檔案、進度與卡點，開啟後讀到對方檔案會自動記一行。 |
| `owen-mock-interview` | 盲嗑面試 | 模擬技術面試，針對 JD 產生深度提問 |
| `owen-job-intel-taiwan` | 公司背景屌插菊 | 台灣求職目標公司情蒐 |
| `owen-stock-market-analyst` | 一張不賣，奇蹟自來 | 台股／美股／ETF 結構性分析 |

## 新增插件

插件與 skill 名稱一律以 `owen-` 開頭（資料夾名與 `name` 一致），方便在 `/` 選單搜尋。

**只有一個 skill**：在 `skills/` 下建目錄 `owen-<name>/` 放 `SKILL.md`，再到 `.claude-plugin/marketplace.json` 加一筆：

```json
{ "name": "owen-<name>", "source": "./", "description": "...", "skills": ["./skills/owen-<name>"] }
```

**有 hook 或 sub-agent**：在 `plugins/owen-<name>/` 下建完整插件（參考 `plugins/owen-change-flow/`），marketplace 那筆的 `source` 指向 `./plugins/owen-<name>`。

改完用 `claude plugin validate .` 檢查。

## 目錄結構

```
claude-skills/
├── .claude-plugin/marketplace.json   # marketplace 清單，定義每個插件
├── plugins/
│   ├── owen-change-flow/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── skills/owen-change-flow/SKILL.md
│   │   ├── agents/blast-radius.md, verifier.md
│   │   └── hooks/hooks.json, session-start.js, rules.md
│   ├── owen-coding-principles/            # 5 個 owen-principle-* skill
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/owen-principle-*/SKILL.md
│   ├── owen-perf-measurement/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/owen-benchmark-checklist/, owen-principle-explain-the-number/
│   ├── owen-task-framing/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/owen-sharpen/, owen-in-your-own-words/
│   └── owen-jira-log/
│       ├── .claude-plugin/plugin.json
│       └── skills/owen-jira-project/, owen-jira-timeline/
└── skills/                           # 單一 skill 插件
    ├── owen-mock-interview/
    ├── owen-job-intel-taiwan/
    ├── owen-stock-market-analyst/
```
