// Gen AI Assignment 2 | editable Typst source
// Compile from this directory with: typst compile <file>.typ <file>.pdf

#set page(
  paper: "a4",
  margin: 2.5cm,
  numbering: none,
  footer: context [
    #if counter(page).get().first() > 1 [
      #align(center)[#(counter(page).get().first() - 1)]
    ]
  ],
  header: context [
    #if counter(page).get().first() > 1 [
      #set text(font: "Times New Roman", size: 9pt)
      #align(center)[Agent & Multi-Agent Systems: Assignment 2]
      #v(4pt)
      #line(length: 100%, stroke: 0.5pt)
    ]
  ],
  header-ascent: 1cm,
)
#set text(font: "Times New Roman", size: 11pt, lang: "en", tracking: 0.2pt)
#set par(first-line-indent: (amount: 1.5em, all: true), leading: 0.65em, spacing: 0.65em, justify: true)
#set figure(gap: 0.8em)
#set figure.caption(position: bottom, separator: [. ])
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.caption: set text(size: 10pt)
#show figure: set block(above: 12pt, below: 16pt)
#show figure.where(kind: table): set block(breakable: false)
#set table(stroke: none, inset: (x: 6pt, y: 5pt), align: center)
#show table: set par(first-line-indent: 0pt, justify: false)
#show figure.caption: set par(first-line-indent: 0pt)
#set heading(numbering: "1.1")
#show heading.where(level: 1): set text(weight: "bold", size: 16pt)
#show heading.where(level: 2): set text(weight: "bold", size: 13pt)
#show heading: set block(above: 14pt, below: 12pt)
#show raw.where(block: true): set text(font: "Consolas", size: 9pt)
#show raw.where(block: true): block.with(
  width: 100%,
  breakable: false,
  fill: rgb("#F6F8FA"),
  stroke: 0.5pt + rgb("#DDE3EA"),
  radius: 5pt,
  inset: 12pt,
  above: 8pt,
  below: 8pt,
)
#set list(indent: 2.5em, body-indent: 0.6em)
#show link: set text(fill: rgb("#244a73"))

// Cover page
#align(center)[
  #v(2.4cm)
  #text(size: 17pt, weight: "bold")[Gen AI · Assignment 2]
  #v(1cm)
  #text(size: 28pt, weight: "bold")[Agent & Multi-Agent Systems]
  #v(1cm)
  #text(size: 26pt, weight: "bold")[Report Ⅱ]
  #v(0.7cm)
  #text(size: 15pt)[Original AutoGen MAS and In-Loop Citation Auditing]
  #v(6cm)
  #table(
    columns: (6cm, 7cm),
    stroke: none,
    inset: (x: 8pt, y: 9pt),
    align: (right, left),
    [Name:], [Hanwen Hu],
    [Student ID:], [3240104699],
    [Date:], [October 3, 2026],
  )
  #v(0.8cm)
  #text(size: 10pt)[
    #link("https://github.com/huharvey/GenAI_HW2")[GitHub: huharvey/GenAI_HW2]
    #v(7pt)
    #link("HW2_Task1_Research_Report.pdf")[Task 1 Research Report]
    #h(1em)
    #link("HW2_Task2_Research_Report.pdf")[Task 2 Research Report]
  ]
  #v(2cm)
  #text(size: 11pt)[2026-2027 Autumn Semester]
]
#pagebreak()

= Assignment Overview

This assignment examines how an AutoGen multi-agent system (MAS) retrieves evidence, drafts a technical report, and revises unsupported claims. Task 1 uses the supplied `advanced.py` workflow as the baseline. Task 2 adds a citation-audit agent to `task2_improved.py`, so a deterministic citation check becomes available to the reviewer before the team terminates. Both recorded runs address the same topic:

#quote[
  Application of reinforcement learning to quadrotor trajectory tracking
]

The evaluation focuses on the architectural change, actual tool execution, and subsequent use of retrieved evidence. The assignment does not require a quantified performance improvement. The two runs demonstrate the workflow, but do not establish that the revised architecture produces better research content under identical retrieval conditions.

== Run configuration and artifacts

The dependency versions in `requirements.txt` are AutoGen AgentChat 0.7.5, the AutoGen OpenAI extension 0.7.5, python-dotenv 1.1.1, and httpx 0.28.1. Both saved `run_summary.json` files record the model as `doubao-seed-2-1-turbo-260628`, with temperature 0.2 and a maximum output length of 1800 tokens per model response. The writer prompt requests a Chinese report of 500-700 characters; the two accompanying research reports provide edited English versions for submission.

The Task 1 run is `advanced_20261003_213736`; the Task 2 run is `advanced_20261003_212723`. Each frozen directory contains `report.md`, `review.md`, `trace.jsonl`, `evidence_registry.json`, and `run_summary.json`. Citation identifiers are local to each run: `[S5]` in Task 1 and `[S5]` in Task 2 refer to different records. Both scripts retain the output prefix `advanced`, so the Task 2 run name does not identify its entry-point script by itself.

= Task 1: Baseline MAS

== Roles and control flow

The baseline uses four `AssistantAgent` instances in a `SelectorGroupChat`. A custom `choose_next()` function selects the next speaker from the latest agent message and a revision counter. The normal route is therefore explicitly programmed, with model-based selection available when the function returns `None`.

```text
PlannerAgent -> SearchAgent -> WriterAgent -> ReviewerAgent
                  |                            |
           search_literature()          REVISION_REQUIRED
                                               |
                                 WriterAgent -> ReviewerAgent

After the team stops: audit_citations(final_report)
```

The planner turns the topic into research questions and search terms. The searcher calls `search_literature()`, which combines the local course database with Crossref retrieval and registers the returned records as `[S#]` sources. The writer drafts a report from this evidence, and the reviewer checks whether its claims and citations are supported. The selector permits one return to the writer for revision. The team uses `max_turns=6`, together with approval-text and 20-message termination conditions.

The citation check at the end of `advanced.py` is a separate Python call made after `run_team()` returns. Its result is appended to `review.md`; it cannot influence an agent in the completed conversation.

== Run result and screenshot

From the repository root, the baseline is run with:

```powershell
python advanced.py --topic "Application of reinforcement learning to quadrotor trajectory tracking"
```

#figure(
  image("assets/task1_run.png", width: 100%),
  caption: [Task 1 terminal output: the reviewer requests a revision, the writer revises the report, and the final review returns REVIEW_APPROVED.],
  supplement: [Figure],
)

The terminal screenshot shows the report and review sequence. Tool execution is established by the JSONL trace, since the console prints only selected text messages. The frozen trace contains 15 records, including the user message, model thought events, tool events, and the final `TaskResult`. These are log records, not 15 agent turns. There is one in-loop tool invocation, one writer revision, and a final approval.

== Extracted log and interpretation

The following excerpt indexes records by their one-based line numbers in `trace.jsonl`. Descriptions summarize the recorded messages in English.

```text
Line  4  SearchAgent: ToolCallRequestEvent
         search_literature(query=..., limit=6)
Line  5  SearchAgent: ToolCallExecutionEvent
         S1-S4: course summaries on LLM-based MASs
         S5-S8: topic-related metadata; no abstracts returned
Line  8  WriterAgent: first report
Line 10  ReviewerAgent: unsupported claims; REVISION_REQUIRED
Line 12  WriterAgent: revised report limits claims to metadata
Line 14  ReviewerAgent: REVIEW_APPROVED
Line 15  TaskResult: approval-text termination
```

The first draft inferred an RL method taxonomy, performance advantages, and deployment limitations from titles alone. The reviewer rejected these claims because the retrieved records did not contain the required technical evidence. The revised draft acknowledges that the available material cannot support a substantive comparison of tracking controllers. The post-run audit then finds all eight cited identifiers in the registry.

This run illustrates both the value and the limit of the revision loop. The reviewer identifies unsupported inference, and the writer responds by narrowing the report. Although the reviewer also requests better retrieval, the programmed revision route returns only to the writer; no second search occurs. The workflow therefore corrects the scope of the claims without resolving the underlying evidence shortage.

== Research outcome

The final Task 1 report is an account of insufficient evidence. Four course records concern LLM-based MASs, while four records relevant to quadrotor tracking contain bibliographic metadata only. The report identifies those research topics but cannot compare controller accuracy, disturbance rejection, or computational demands. `REVIEW_APPROVED` records the reviewer's acceptance of this restricted report; it does not mean that the original survey objectives were fully achieved.

= Task 2: Design and Implementation

== Motivation and revised architecture

The baseline's deterministic citation check arrives too late to inform revision. Task 2 places a dedicated `CitationAuditAgent` between the writer and reviewer. Each draft is routed through this agent, whose prompt requires it to pass the writer's report to `audit_citations()`. The resulting tool summary enters the conversation before the reviewer responds.

```text
PlannerAgent -> SearchAgent -> WriterAgent
                  |                |
           search_literature()      v
                           CitationAuditAgent
                                   |
                            audit_citations()
                                   |
                                   v
                             ReviewerAgent
                              /         \
                REVISION_REQUIRED    REVIEW_APPROVED
                         |
                    WriterAgent
                  (audit and review repeat)
```

The two checks address different questions. The Python audit extracts citation markers matching `[S#]`, flags missing citations or unknown identifiers, and otherwise reports the number of distinct registered sources used. The LLM reviewer assesses whether those sources support the associated claims. A valid identifier is therefore necessary for traceability but insufficient to establish factual support.

#block(breakable: false)[
== Implementation changes

The selector adds the audit stage and increases the revision counter limit from one to three. The relevant routing branches are:

```python
if source == "WriterAgent":
    return "CitationAuditAgent"
if source == "CitationAuditAgent":
    return "ReviewerAgent"
if source == "ReviewerAgent":
    if "REVISION_REQUIRED" in content and state["revisions"] < 3:
        state["revisions"] += 1
        return "WriterAgent"
```
]

`CitationAuditAgent` is constructed with `tools=[audit_citations]`, `reflect_on_tool_use=False`, and `max_tool_iterations=1`. Its prompt requires a tool call with the complete writer report as the `report` argument. The reviewer's prompt is also revised: it must consider the audit result and request revision if the audit finds unknown identifiers or no citations. The improved script removes the baseline's post-run audit call.

The team-turn limit increases from 6 to 30, while `MaxMessageTermination(20)` and approval-text termination remain in place. The selector allows up to three revisions, but a termination condition can stop the conversation earlier. Both frozen runs used only one revision.

The new participant, routing branches, and in-loop tool binding constitute the architectural change. The actual tool call and the reviewer's response still depend on instruction-following by the LLM agents: the code does not implement a separate deterministic approval gate. The saved trace is consequently needed to verify that the intended sequence occurred in this run.

= Task 2: Run Result and Interpretation

== Run result and screenshot

```powershell
python task2_improved.py --topic "Application of reinforcement learning to quadrotor trajectory tracking"
```

#figure(
  image("assets/task2_run.png", width: 90%),
  caption: [Task 2 terminal output: one revision precedes final approval. The relevant run begins at the displayed task2_improved.py command; the line above it belongs to earlier terminal output. Tool calls are documented in the trace below.],
  supplement: [Figure],
)

The frozen trace contains 21 records and three in-loop tool invocations: one literature search and two citation audits. The second audit checks the revised draft. Both audits return a successful identifier check, and the run terminates after the reviewer's `REVIEW_APPROVED` message.

== Tool execution and subsequent use

```text
Line  4  SearchAgent: search_literature(query=..., limit=10)
Line  5  Tool result: S1 course record; S2-S5 Crossref records
Line  8  WriterAgent: first draft cites S2, S3, S4, S5
Line  9  CitationAuditAgent: audit_citations(report=first_draft)
Line 10  Tool result: four registered sources; check passed
Line 11  CitationAuditAgent: tool summary enters shared context
Line 13  ReviewerAgent: semantic objections; REVISION_REQUIRED
Line 15  WriterAgent: revised draft
Line 16  CitationAuditAgent: audit_citations(report=revised_draft)
Line 17  Tool result: four registered sources; check passed
Line 18  CitationAuditAgent: tool summary enters shared context
Line 20  ReviewerAgent: REVIEW_APPROVED
Line 21  TaskResult: approval-text termination
```

Lines 9-11 and 16-18 establish that the citation tool executes inside the conversation and its result is delivered before each review. In both cases it finds the same four registered sources, `['S2', 'S3', 'S4', 'S5']`. The first draft nevertheless fails semantic review. In particular, the reviewer rejects an end-to-end architecture claim based on the title-only record `[S2]`, a claim about PID limitations unsupported by `[S5]`, and a high-dimensional generalization claim absent from the retrieved abstract.

The assignment's requirement for a real tool call with later use is directly visible in the search-to-writing sequence: the writer uses the returned `[S5]` abstract to describe Q-learning combined with sliding-mode control, and the reviewer refers to that abstract when identifying unsupported claims. The audit adds another explicit input to the later review. However, the reviewer does not explicitly discuss the audit in its final text, and neither audit fails. This trace demonstrates delivery of the audit result to the reviewer, but does not isolate its effect on the approval decision or test recovery from an invalid citation.

== Research outcome and remaining review errors

Unlike Task 1, this search retrieves an abstract for one relevant record, `[S5]`. It describes a Q-learning-assisted sliding-mode controller with disturbance estimation and adaptive parameter tuning, together with qualitative simulation findings. The revised draft removes several unsupported technical details and confines its detailed method description to this source.

Approval does not eliminate every overstatement. The frozen Chinese draft still generalizes the lack of retrieved abstracts into claims about what research has publicly disclosed, and describes simulation advantages more strongly than the abstract can quantify. The accompanying English Task 2 report narrows those statements to the evidence actually retrieved and identifies them as editorial corrections. The frozen output is preserved as the record of what the MAS produced.

= Comparison of the Two MASs

#let accent = rgb("#244a73")
#let light-accent = rgb("#eef4f9")
#let light-gray = rgb("#f7f7f7")
#let border = rgb("#d7dce2")

#figure(
  table(
    columns: (3.2cm, 1fr, 1fr),
    inset: (x: 8pt, y: 7pt),
    align: (left, left, left),

    stroke: (x, y) => (
      bottom: 0.5pt + border,
    ),

    fill: (x, y) => {
      if y == 0 {
        accent
      } else if y == 1 or y == 5 {
        light-accent
      } else if calc.rem(y, 2) == 0 {
        light-gray
      } else {
        white
      }
    },

    table.header(
      [#text(fill: white, weight: "bold")[Dimension]],
      [#text(fill: white, weight: "bold")[Task 1: Original MAS]],
      [#text(fill: white, weight: "bold")[Task 2: Improved MAS]],
    ),

    // ---------- Architecture ----------
    table.cell(colspan: 3)[
      #text(fill: accent, weight: "bold")[Architecture]
    ],

    [*Agent composition*],
    [Planner → Search → Writer → Reviewer],
    [
      Planner → Search → Writer \
      → *CitationAudit* → Reviewer
    ],

    [*Citation validation*],
    [
      `audit_citations()` runs \
      *after* the MAS terminates
    ],
    [
      `audit_citations()` runs \
      *inside* the MAS loop
    ],

    [*Role separation*],
    [
      Reviewer checks citation IDs \
      and semantic support
    ],
    [
      CitationAudit checks citation IDs; \
      Reviewer checks semantic support
    ],

    // ---------- Frozen run ----------
    table.cell(colspan: 3)[
      #text(fill: accent, weight: "bold")[Frozen-run behavior]
    ],

    [*Tool calls*],
    [
      1 in-loop call \
      `search_literature()`
    ],
    [
      3 in-loop calls \
      `search_literature()` + \
      2 × `audit_citations()`
    ],

    [*Revision limit*],
    [1; 6 team turns],
    [3; 30 team turns],

    [*Observed revisions*],
    [1],
    [1],

    [*Can citation audit affect later agents?*],
    [No; post-hoc only],
    [*Yes; audit result enters reviewer context*],

    [*Trace records*],
    [15],
    [21],

    [*Final state*],
    [`REVIEW_APPROVED`],
    [`REVIEW_APPROVED`],
  ),

  caption: [
    Comparison of the original and improved MAS in architecture and frozen-run behavior.
  ],
  supplement: [Table],
)


The observed change is the placement and visibility of validation. Task 1 performs one search inside the conversation and one audit after it ends. Task 2 performs the search and both audits inside the conversation, so the reviewer receives a citation-check result for each draft. This run adds two audit-agent turns and two in-loop tool invocations; it does not demonstrate a measured gain in accuracy, latency, or cost.

The shared topic and model settings do not make the runs a controlled comparison of report quality. Task 1 searches for:

```text
reinforcement learning for quadrotor trajectory tracking:
control framework, comparison with PID/MPC,
applications and challenges
```

Task 2 searches for:

```text
reinforcement learning quadrotor trajectory tracking
deep reinforcement learning quadrotor control
```

The search calls also request different limits, 6 and 10 respectively, although `search_literature()` caps each Crossref request at four records. Different query terms lead to different local matches and external records: Task 1 receives eight records without a relevant abstract, whereas Task 2 receives five records including one relevant abstract. Retrieval inputs and revision budgets therefore differ alongside the architecture. The richer Task 2 report cannot be attributed solely to the additional agent.

A more focused follow-up would give both systems the same saved evidence and initial draft, then introduce an unknown citation identifier. This would test whether a failed audit actually leads to correction before approval. Repeated trials would also be needed to assess the consistency of the LLM review. These tests were not part of the two frozen runs.

= Conclusion

Task 1 reproduces the baseline workflow and documents a search, a reviewer rejection, one revision, and final approval. Task 2 adds a dedicated citation-audit agent and routes each draft through its tool result before review. The saved trace confirms that both audits execute and that the writer and reviewer use retrieved evidence later in the conversation.

The main contribution is a clearer validation sequence: deterministic identifier checking and semantic review are separately observable within the MAS. The runs also expose unresolved limits. Neither system retrieves additional evidence during revision, the audit checks identifiers rather than claim support, and the LLM reviewer can approve residual overstatements. The results support the architectural improvement while leaving its effect on overall report quality unmeasured.

= Submission Artifacts

The submission archive, `GenAI_HW2_Submission.zip`, contains the three PDF documents listed below. Extract the archive before opening the reports and keep the files in the same directory so the document links can resolve.

#figure(
  table(
    columns: (6.2cm, 1fr),
    align: left,
    inset: (x: 8pt, y: 7pt),
    stroke: (bottom: 0.5pt + rgb("#d7dce2")),
    fill: (x, y) => if y == 0 { rgb("#eef4f9") } else { none },
    table.header([*Document*], [*Contents*]),
    [#link("HW2_Report.pdf")[Overall Assignment Report]],
    [This document: architectures, implementation changes, run results, extracted logs, and comparison.],
    [#link("HW2_Task1_Research_Report.pdf")[Task 1 Research Report]],
    [Edited English version of the baseline MAS research output and its evidence registry.],
    [#link("HW2_Task2_Research_Report.pdf")[Task 2 Research Report]],
    [Edited English version of the improved MAS research output and its evidence registry.],
  ),
  caption: [Clickable index of the three PDF submission documents.],
  supplement: [Table],
)

The runnable code is available at #link("https://github.com/huharvey/GenAI_HW2")[github.com/huharvey/GenAI_HW2]. The #link("https://github.com/huharvey/GenAI_HW2/blob/main/README.md")[repository README] includes QUICK START instructions for environment setup, model configuration, and both task commands. Editable Typst sources and terminal screenshots are available in the #link("https://github.com/huharvey/GenAI_HW2/tree/main/docs")[repository's docs directory].

The analysis in this report uses the locally archived Chinese reports and complete execution logs in these directories relative to the repository root:

```text
outputs/task1_frozen_advanced_20261003_213736/
outputs/task2_frozen_advanced_20261003_212723/
```

The extracted log excerpts and screenshots needed to interpret the runs are included in this overall report. The local frozen directories are separate from the three-PDF archive. Runtime credentials are read from a local `.env`; the repository provides `.env.example` as the configuration template.
