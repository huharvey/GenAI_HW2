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
#set text(font: "Times New Roman", size: 12pt, lang: "en", tracking: 0.2pt)
#set par(first-line-indent: (amount: 1.5em, all: true), leading: 0.8em, spacing: 0.8em, justify: true)
#set figure(gap: 0.8em)
#set figure.caption(position: bottom, separator: [. ])
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.caption: set text(size: 10pt)
#show figure: set block(above: 12pt, below: 20pt)
#set table(stroke: none, inset: (x: 6pt, y: 5pt), align: center)
#set heading(numbering: "1.1")
#show heading.where(level: 1): set text(weight: "bold", size: 17pt)
#show heading.where(level: 2): set text(weight: "bold", size: 13pt)
#show heading: set block(above: 16pt, below: 16pt)
#show raw.where(block: true): set text(font: "Consolas", size: 9pt)
#show raw.where(block: true): block.with(
  width: 100%,
  fill: rgb("#F6F8FA"),
  stroke: 0.5pt + rgb("#DDE3EA"),
  radius: 5pt,
  inset: 12pt,
  above: 8pt,
  below: 8pt,
)
#set list(indent: 2.5em, body-indent: 0.6em)

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
  #v(4cm)
  #text(size: 11pt)[2026-2027 Autumn Semester]
]
#pagebreak()

= Assignment Overview

This assignment studies an LLM-based multi-agent research workflow implemented with AutoGen. Task 1 runs and interprets the original course MAS. Task 2 modifies the architecture so that deterministic citation auditing is executed inside the multi-agent loop and its result is consumed by a later reviewer. Both frozen runs use the same research topic:

#quote[
  Application of reinforcement learning to quadrotor trajectory tracking
]

The original baseline is `advanced.py`. The improved implementation is `task2_improved.py`. The frozen runs used for this submission are `advanced_20261003_213736` for Task 1 and `advanced_20261003_212723` for Task 2.

== Environment and model configuration

The Python dependencies are fixed in `requirements.txt`: AutoGen AgentChat 0.7.5, AutoGen OpenAI extension 0.7.5, python-dotenv 1.1.1, and httpx 0.28.1. Both frozen runs used the same LLM configuration: `doubao-seed-2-1-turbo-260628`, maximum output length 1800 tokens, and temperature 0.2. The API key is intentionally excluded from the submission; `.env.example` is provided instead.

The repository records all agent and tool activity in `trace.jsonl`, and stores the generated report, final review, evidence registry, and run summary separately. This makes the workflow auditable rather than relying only on the terminal display.

= Task 1: Original MAS

== Original architecture

The Task 1 baseline uses four LLM agents coordinated by `SelectorGroupChat`. Its effective workflow is:

```text
PlannerAgent
  -> SearchAgent -> search_literature()
  -> WriterAgent
  -> ReviewerAgent
       -> WriterAgent, if REVISION_REQUIRED
       -> REVIEW_APPROVED
  -> post-hoc audit_citations() after the team has stopped
```

`PlannerAgent` decomposes the research question. `SearchAgent` calls the literature-search tool. `WriterAgent` drafts a 500-700 Chinese-character technical report using only registered `[S#]` evidence identifiers. `ReviewerAgent` checks evidence scope and may request one revision. Finally, `advanced.py` calls `audit_citations()` after the MAS run has already ended.

== Run command and observed result

```powershell
python advanced.py --topic "Application of reinforcement learning to quadrotor trajectory tracking"
```

#figure(
  image("assets/task1_run.png", width: 100%),
  caption: [Frozen Task 1 terminal run. The reviewer rejects the first draft, the writer revises it, and the reviewer finally returns REVIEW_APPROVED.],
  supplement: [Figure],
)

The frozen Task 1 trace contains 15 recorded events. It includes one in-loop tool call, `SearchAgent -> search_literature()`, one rejected draft, one writer revision, and a final `REVIEW_APPROVED`.

== Execution-log interpretation

The most important part of the baseline run is the revision behavior. The search tool returned four course-database sources `[S1]-[S4]` that were unrelated to quadrotor trajectory tracking and four Crossref records `[S5]-[S8]` whose titles were relevant but whose abstracts were unavailable. The first writer draft nevertheless inferred detailed technical conclusions from those titles. The reviewer correctly identified this as unsupported inference and returned `REVISION_REQUIRED`.

A condensed trace is:

```text
SearchAgent -> search_literature(...)
Tool result -> S1-S4: unrelated course sources
               S5-S8: relevant titles, but no abstracts
WriterAgent  -> technical claims inferred from titles
ReviewerAgent -> REVISION_REQUIRED
                 "S5-S8 only provide titles/authors and cannot support
                  the technical claims in the draft."
WriterAgent  -> rewrites the report to state only what the evidence proves
ReviewerAgent -> REVIEW_APPROVED
```

The revised report no longer claims an RL taxonomy, performance superiority, or sim-to-real limitations from title-only evidence. Instead, it explicitly states that the retrieved evidence is insufficient for a substantive method comparison. This is a useful failure-and-recovery case: the semantic reviewer prevents unsupported research claims even though the search itself returned weak evidence.

After the team stops, the baseline performs a deterministic post-hoc citation audit. It reports that all eight cited identifiers are registered. However, because this audit occurs after termination, its result cannot trigger another writer revision.

== Task 1 output

The final Task 1 report concludes that the evidence is insufficient for a complete technical survey. The course sources are off-topic, while the four relevant Crossref items provide bibliographic metadata but no usable technical content. The report therefore refuses to rank methods or state performance advantages without additional abstracts or full texts.

The complete frozen output is included under:

```text
LLMMASAutoGen/outputs/task1_frozen_advanced_20261003_213736/
```

= Task 2: Improved MAS

== Motivation

The Task 1 workflow has a structural limitation: `audit_citations()` is deterministic, but it is executed only after the MAS has finished. Therefore, even if the audit found an invalid `[S#]` identifier, the result would not become part of the decision loop. In addition, citation-ID validity and semantic evidence sufficiency are different checks and should not be conflated.

Task 2 changes the workflow from post-hoc validation to in-loop validation. A new `CitationAuditAgent` is inserted between the writer and reviewer. It must call the deterministic `audit_citations()` tool, and the reviewer receives that tool result before deciding whether to approve or request a revision.

== Improved architecture

```text
PlannerAgent
  -> SearchAgent -> search_literature()
  -> WriterAgent
  -> CitationAuditAgent -> audit_citations()
  -> ReviewerAgent
       -> WriterAgent, if REVISION_REQUIRED
       -> CitationAuditAgent -> ReviewerAgent
       -> REVIEW_APPROVED
```

The division of responsibility is deliberate:

- `CitationAuditAgent`: deterministic citation-ID validity. It checks whether every `[S#]` used by the report exists in the evidence registry.
- `ReviewerAgent`: semantic evidence validation. It checks whether a registered source actually supports the claim made from it, whether the report overgeneralizes, and whether important claims lack evidence.

== Concrete implementation

The routing logic is changed so every writer draft must pass through citation auditing before semantic review:

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

The new agent binds the existing deterministic tool:

```python
citation_auditor = AssistantAgent(
    "CitationAuditAgent",
    model_client=model_client,
    tools=[audit_citations],
    system_message=(
        "After receiving the WriterAgent report, you must call "
        "audit_citations and use the tool result as the audit result."
    ),
    reflect_on_tool_use=False,
    max_tool_iterations=1,
)
```

This is an architectural change, not only a prompt edit: a new role, a new routing edge, and an additional tool-execution stage are added to the MAS.

= Task 2 Run Result and Interpretation

== Run command

```powershell
python task2_improved.py --topic "Application of reinforcement learning to quadrotor trajectory tracking"
```

#figure(
  image("assets/task2_run.png", width: 100%),
  caption: [Frozen Task 2 terminal run. The improved workflow performs one revision and ends with REVIEW_APPROVED.],
  supplement: [Figure],
)

The frozen Task 2 trace contains 21 recorded events. It includes three in-loop tool calls: one literature search and two citation audits, because the first draft is revised once and then audited again.

== Tool result used later

The first Task 2 draft cites `[S2]`, `[S3]`, `[S4]`, and `[S5]`. `CitationAuditAgent` calls `audit_citations()` and receives:

```text
Citation audit passed: the report uses 4 registered sources
['S2', 'S3', 'S4', 'S5'].
```

This tool result is then available to `ReviewerAgent`. Crucially, the reviewer still rejects the draft. It observes that `[S2]-[S4]` are registered identifiers but only provide titles, so they cannot support claims such as end-to-end architecture details, real-flight transfer conclusions, or high-dimensional generalization. It also notes that the evidence from `[S5]` does not support every claim made in the draft.

This demonstrates the intended two-layer validation:

```text
Citation-ID validity: PASS
        |
        v
Semantic evidence sufficiency: FAIL
        |
        v
Writer revision
        |
        v
Citation-ID validity: PASS
        |
        v
Semantic review: REVIEW_APPROVED
```

After revision, the writer limits `[S2]-[S4]` to title-level statements and bases detailed method claims on `[S5]`, whose Crossref record includes a full abstract. The citation auditor runs again and passes, after which the reviewer returns `REVIEW_APPROVED`.

== Final Task 2 research result

Unlike the Task 1 run, the Task 2 search happened to retrieve a detailed abstract for source `[S5]`. The final report therefore describes a Q-learning plus nonsingular terminal sliding-mode-control scheme, including disturbance estimation, adaptive parameter tuning, and simulation evidence. It also explicitly states that `[S2]-[S4]` provide only titles and therefore are not used to support detailed technical conclusions.

The complete frozen output is included under:

```text
LLMMASAutoGen/outputs/task2_frozen_advanced_20261003_212723/
```

= Comparison of the Two MASs

#figure(
  table(
    columns: (2.8cm, 5.4cm, 5.4cm),
    [*Dimension*], [*Task 1: Original MAS*], [*Task 2: Improved MAS*],
    [Core agents], [Planner, Search, Writer, Reviewer], [Planner, Search, Writer, CitationAudit, Reviewer],
    [Validation placement], [Deterministic citation audit after team termination], [Deterministic citation audit inside the agent loop],
    [In-loop tool calls in frozen trace], [1: literature search], [3: literature search + two citation audits],
    [Revisions], [1], [1],
    [Citation-ID check can affect later behavior], [No], [Yes],
    [Semantic evidence review], [ReviewerAgent], [ReviewerAgent, after deterministic audit],
    [Final state], [REVIEW_APPROVED], [REVIEW_APPROVED],
  ),
  caption: [Architecture and run-behavior comparison of the original and improved MAS.],
  supplement: [Table],
)

The principal improvement is not that Task 2 necessarily produces a higher-scoring research report. It is that a deterministic check is moved into the controllable workflow, where its output becomes explicit context for subsequent decisions. This makes the evidence-validation chain more auditable and gives the system a mechanism to revise after a citation failure.

A direct content-quality comparison must be interpreted carefully. Although both runs used the same topic, model, temperature, and output-token limit, the external Crossref responses were not identical. Task 1 received only metadata for its topic-relevant records, while Task 2 received a complete abstract for `[S5]`. Therefore, the richer technical content in the Task 2 final report cannot be attributed solely to the architecture change. The defensible comparison is the workflow behavior: in-loop tool use, deterministic validation, semantic review, and revision routing.

= Conclusion

Task 1 successfully reproduces and explains the original AutoGen MAS, including a real literature-search tool call, a reviewer rejection, one evidence-bounded revision, and final approval. Task 2 introduces a dedicated citation-audit role and moves deterministic validation from a post-hoc step into the MAS loop. The frozen Task 2 execution confirms that `audit_citations()` is genuinely called, its output is used by a later reviewer, and the report is revised before final approval.

The experiment also shows why multiple validation mechanisms are useful. A registered citation identifier is not sufficient proof that a claim is supported; deterministic citation validation and LLM-based semantic evidence review address different failure modes. The improved MAS makes this distinction explicit in both the architecture and the execution trace.

= Submission Files

The submission package contains the runnable repository with a README, this overall Typst report, two separate Typst research reports, the two terminal screenshots, and the complete frozen Task 1 and Task 2 run artifacts. Real API credentials are intentionally excluded.
