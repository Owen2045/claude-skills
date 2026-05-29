---
name: job-intel-taiwan
description: Gather job market intelligence for Taiwan-based job targets. Triggers when the user provides a company name + job title — confirms whether the listing is active, scrapes multiple review platforms, and outputs a structured intelligence report. Trigger keywords include "情蒐", "查一下", "面試心得", "這間公司", or any "company + position" combination. This skill only collects and presents data — no personal scores or recommendations.
---

# Taiwan Job Intelligence Skill

Collect multi-platform job intelligence for a target company and role. Report facts, no opinions.

---

## Trigger

User provides a company name + job title. Examples:
- `Delta Electronics Fullstack Engineer`
- `喬美國際網路 Data Engineer`
- `TVBS Senior Backend Engineer Lab team`

---

## Workflow

### Step 1: Confirm Whether the Listing Is Active

Search the following sources in order to verify whether the job exists and what compensation is listed:

1. **CakeResume / Cake** — `site:cake.me [company] [role]`
2. **Yourator** — `site:yourator.co [company] [role]`
3. **104** — Google-cached public results (no login required)

If found: record salary range, team/department, seniority level, and whether posted via recruiter.
If not found: mark "No active listings found on any platform" and continue researching the company.

### Step 2: Multi-Platform Research

**Required platforms (in priority order):**

| Platform | What to Extract | URL Pattern |
|----------|----------------|-------------|
| 比薪水 (salary.tw) | Avg monthly salary, overtime frequency, work mood, per-role reviews | `salary.tw/c/[ID]` |
| 面試趣 (interview.tw) | Interview rating, difficulty, number of reviews, process, sample questions | `interview.tw/c/[ID]` |
| GoodJob | Interview experiences (with salary), work reviews | `goodjob.life/companies/[company-name]` |
| Dcard 科技業板 | Engineer community discussions, interview experiences, workplace sentiment | Google: `site:dcard.tw [company] 工程師` |
| PTT Soft_Job / Tech_Job | Interview experiences, salary discussions | Google: `site:ptt.cc [company] 工程師` |

**Search strategy:**
- For each platform: Google-search to find the company's page ID, then fetch the page directly
- Search keywords: `[company] [role] 面試 薪水 評價 加班`
- For GoodJob: fetch both `/interview-experiences` and `/salary-work-times` sub-pages

### Step 3: Identify Company Background

Via company website, Yourator company page, and LinkedIn, collect:
- Company type (startup / traditional corp / listed / foreign MNC)
- Headcount and registered capital
- Core business and products
- Office location(s)

---

## Data Filter Rules

**Only include engineering role data.** Salary and review data for the following roles must be excluded entirely (do not display or footnote):
- Journalists, video editors, planners, designers, sales, marketing, accounting, HR, admin, and all other non-technical roles

If the overall average salary is diluted by non-technical roles, clearly annotate: "⚠️ This is a company-wide average. For engineering-specific compensation, see individual records."

---

## Output Format

Use the fixed Markdown structure below. **No personal scores or recommendations.**

```
## [Company] — [Role] Intelligence Report

### 🏢 Company Background
[Company type, size, business, office location]

### 💻 Listing Status
[Whether the listing is active, posted salary, seniority level, posting channel]
[Key technical requirements from the JD]

### 🎯 Interview Process (Engineering)
[Number of rounds, process steps, technical question types, difficulty rating]
[Specific interview questions with source platform and date for each]

### 💰 Compensation Intelligence (Engineering Roles Only)
[Salary data by engineering role, including overtime, hours, work sentiment]
[Engineering roles only — use table or bullet list]

### 🌡️ Workplace Culture
[Engineer-specific workplace reviews: overtime culture, management style, tech environment]
[Quote each entry in format: "Role (date shared): …"]

### ⚠️ Special Flags (if any)
[Significant risks or verified unusual circumstances, e.g., gambling industry, frequent reorgs]

### 📊 Data Summary
[Table with all key metrics: salary, overtime, interview rating, review count, listing status]
```

---

## Output Principles

1. **Report only, no recommendations** — present data and let the user decide; never say "I recommend going" or "avoid this company"
2. **Cite sources** — tag each data point with platform name and share date when available
3. **Be honest about sparse data** — if a platform has no relevant engineer reviews, write "[Platform]: No engineering reviews found"
4. **No listing ≠ stop researching** — if the job isn't active, still complete the full company research
5. **Acknowledge platform limits** — if 面試趣/比薪水 content is behind a paywall, note "Content locked; only preview available"

---

## Special Company Type Handling

| Company Type | Additional Notes |
|--------------|-----------------|
| **Gambling / iGaming** | Must prominently flag "⚠️ Gambling (菠菜) company" in Company Background and explain legal status and risks in Special Flags |
| **AgriTech / IoT startups** | Note that backend engineer scope differs from pure software companies (e.g., aquaculture device communication, sensor data) |
| **Media companies** | Overall salary average includes many non-technical roles — filter aggressively; highlight overtime differences between engineering and media roles |
| **Hardware / Electronics manufacturers** | Cross-department variance is high; note "Department differences are significant — verify team type during interview" |

---

## Search Mechanics

### Finding 比薪水 Company ID
```
Google: "[company] 薪水 site:salary.tw"
→ Locate salary.tw/c/[ID]
→ Fetch page; filter to engineering roles only
```

### Finding 面試趣 Company ID
```
Google: "[company] 面試 site:interview.tw"
→ Locate interview.tw/c/[ID]
→ Fetch page; filter to engineering roles only
```

### GoodJob Search
```
Direct fetch: goodjob.life/companies/[full Chinese company name]/interview-experiences
Direct fetch: goodjob.life/companies/[full Chinese company name]/salary-work-times
```

### Confirming JD Content
```
After locating the listing page, fetch the full page and extract:
- Required technical skills (languages, frameworks, years of experience)
- Core responsibilities summary
- Salary range if disclosed
```

---

## Edge Cases

- **Duplicate company names**: If two companies share the same name (e.g., 艾滴科技), verify by registration number or address; match to the company relevant to the job listing
- **Company renames**: Some companies have rebranded (e.g., 大慶證券 → 美好證券); try both names in searches
- **Recruiter-posted listings**: A listing on Cake Recruitment Consulting still counts as a valid listing; note "Posted via recruiter"
- **Low review count**: If a role has fewer than 5 reviews, annotate "Limited sample size — treat with caution"
