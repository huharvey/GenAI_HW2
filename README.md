# Gen AI 作业 2 - Agent 与多智能体系统

本仓库包含课程提供的原始多智能体系统（用于 Task 1），以及在其基础上改进后的多智能体系统（用于 Task 2）。

**Task 1 与 Task 2 冻结运行所使用的研究主题：**

`Application of reinforcement learning to quadrotor trajectory tracking`

## 文件说明

- `advanced.py`：课程原始 MAS，用作 Task 1 的基线系统。
- `task2_improved.py`：Task 2 改进后的 MAS，在原架构中加入了闭环运行的 `CitationAuditAgent`。
- `basic.py`：课程仓库提供的固定顺序基础版 MAS。
- `research_tools.py`：包含文献检索工具和确定性的引用审计工具。
- `common.py`：包含模型配置、日志记录、输出处理等公共函数。
- `data/course_sources.json`：课程本地资料库。
- `outputs/task1_frozen_advanced_20261003_213736/`：Task 1 最终冻结运行结果。
- `outputs/task2_frozen_advanced_20261003_212723/`：Task 2 最终冻结运行结果。

## 环境配置

建议使用 Python 3.11 或更高版本。

### 安装依赖

Windows PowerShell：

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

macOS / Linux：

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## 配置 LLM API

将 `.env.example` 复制为 `.env`，并填写自己的 API Key：

```text
ARK_API_KEY=YOUR_KEY_HERE
LLM_BASE_URL=https://ark.cn-beijing.volces.com/api/coding/v3
LLM_MODEL=doubao-seed-2-1-turbo-260628
LLM_MAX_TOKENS=1800
LLM_TEMPERATURE=0.2
```

可以使用下面的命令检查 API 是否能够正常连接：

```powershell
python check_api.py
```

**不要将真实的 `.env` 文件提交到仓库或作业中。**  
本提交版本只保留 `.env.example`，不包含真实 API Key。

## Task 1 - 原始 MAS

运行命令：

```powershell
python advanced.py --topic "Application of reinforcement learning to quadrotor trajectory tracking"
```

原始工作流：

```text
PlannerAgent
  -> SearchAgent -> search_literature()
  -> WriterAgent
  -> ReviewerAgent
       -> 如果需要修改，则返回 WriterAgent
       -> REVIEW_APPROVED
  -> 运行结束后执行 post-hoc audit_citations()
```

报告中使用的冻结运行结果为：

`advanced_20261003_213736`

## Task 2 - 改进后的 MAS

运行命令：

```powershell
python task2_improved.py --topic "Application of reinforcement learning to quadrotor trajectory tracking"
```

改进后的工作流：

```text
PlannerAgent
  -> SearchAgent -> search_literature()
  -> WriterAgent
  -> CitationAuditAgent -> audit_citations()
  -> ReviewerAgent
       -> 如果需要修改，则返回 WriterAgent
       -> CitationAuditAgent -> ReviewerAgent
       -> REVIEW_APPROVED
```

Task 2 的核心改进，是将引用审计从原来的**运行结束后的事后检查（post-hoc check）**改为**MAS 工作流内部的闭环验证（in-loop validation）**。

新增的 `CitationAuditAgent` 会在 WriterAgent 完成报告后，调用确定性的 `audit_citations()` 工具检查报告中的 `[S#]` 引用编号是否合法。工具返回结果随后会进入共享对话上下文，并由 `ReviewerAgent` 继续进行语义层面的证据审查。

因此，改进后的系统将两个不同层次的验证任务进行了分工：

- `CitationAuditAgent`：检查引用编号是否合法、是否来自已经注册的检索证据；
- `ReviewerAgent`：检查事实陈述是否真正受到对应证据支持，以及是否存在过度外推、缺失引用等问题。

报告中使用的冻结运行结果为：

`advanced_20261003_212723`

## 运行输出文件

每次运行都会在 `outputs/` 下生成一个新的结果目录，其中主要包含：

- `report.md`：最终技术调研报告；
- `review.md`：最终审阅结果；
- `trace.jsonl`：完整的 Agent 与 Tool 执行轨迹；
- `evidence_registry.json`：本次运行注册的检索证据及对应 `[S#]` 编号；
- `run_summary.json`：本次运行的模型设置和结果摘要，不包含 API Key。

## 提交文档

同级目录 `docs/` 中包含：

- `HW2_Report.typ`：作业总报告；
- `HW2_Task1_Research_Report.typ`：Task 1 独立研究报告；
- `HW2_Task2_Research_Report.typ`：Task 2 独立研究报告；
- `assets/task1_run.png`：Task 1 冻结运行截图；
- `assets/task2_run.png`：Task 2 冻结运行截图。

例如，可以使用下面的命令编译 Typst 总报告：

```powershell
typst compile docs/HW2_Report.typ docs/HW2_Report.pdf
```

## Task 1 与 Task 2 的比较说明

Task 1 和 Task 2 使用了相同的研究主题和相同的模型配置，因此可以用于比较两套 MAS 的工作流差异。

不过，两次运行中的外部 Crossref 检索结果并不完全一致：Task 2 恰好检索到了一条包含完整摘要的相关文献，而 Task 1 检索到的相关记录主要只有题录信息。因此，最终作业报告**不将两次报告内容质量的全部差异归因于 Task 2 的架构改进**。

本次比较主要关注以下方面：

- MAS 架构和 Agent 分工；
- 工具调用是否真正进入后续决策流程；
- 引用与证据验证机制；
- Reviewer 的修改与反馈路由；
- 原始 MAS 的 post-hoc validation 与改进 MAS 的 in-loop validation 的差异。
