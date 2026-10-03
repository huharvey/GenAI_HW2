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
      #align(center)[Agent & Multi-Agent Systems: Task 1 Research Report]
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

#align(center)[
  #v(2.4cm)
  #text(size: 17pt, weight: "bold")[Gen AI · Assignment 2]
  #v(1cm)
  #text(size: 27pt, weight: "bold")[Task 1 Research Report]
  #v(0.8cm)
  #text(size: 16pt)[Reinforcement Learning for Quadrotor Trajectory Tracking]
  #v(9cm)
  #set text(size: 13pt)
  #table(
    columns: (6cm, 7cm),
    stroke: none,
    inset: (x: 8pt, y: 9pt),
    align: (right, left),
    [Name:], [Hanwen Hu],
    [Student ID:], [3240104699],
    [Frozen run:], [`advanced_20261003_213736`],
    [Date:], [October 3, 2026],
  )
  #set text(size: 11pt)
]
#pagebreak()

= Scope and Provenance

Related documents: #link("HW2_Report.pdf")[Overall Assignment Report] and #link("HW2_Task2_Research_Report.pdf")[Task 2 Research Report]. Code and run instructions: #link("https://github.com/huharvey/GenAI_HW2")[GitHub repository]. Keep the three extracted PDFs in the same directory to use the document links.

This report presents an edited English version of the final research report from Task 1, run `advanced_20261003_213736`. It preserves the run's evidence and conclusions while clarifying that missing abstracts are a limitation of the retrieved records. The original Chinese output, review, and trace remain in the frozen-output directory. No additional literature was retrieved for this edition. Citation identifiers such as `[S1]` refer only to this run's evidence registry.

= Research Question

The intended survey asks how reinforcement learning is used for quadrotor trajectory tracking, how these approaches compare with proportional-integral-derivative (PID) and model predictive control (MPC), and what evidence exists for their practical use. Addressing these questions requires descriptions of the controllers and their evaluation conditions. The material retrieved in this run supports only a preliminary account of relevant research topics.

= Retrieved Evidence

The search returns eight records. Four are course-database summaries about LLM-based multi-agent systems: software-development collaboration, PLC code generation and verification, multi-agent conversation, and an MAS survey \[S1\]\[S2\]\[S3\]\[S4\]. These records do not address quadrotor tracking and cannot support the intended controller comparison.

The four Crossref records are relevant at the title level. They concern reinforcement learning for anti-interference trajectory tracking \[S5\], a composite MPC-INDI control framework \[S6\], off-policy reinforcement learning for optimal tracking \[S7\], and deep reinforcement learning for trajectory control in virtual environments \[S8\]. These titles identify candidate directions for further reading, but the retrieved records contain no abstracts, method descriptions, or experimental results. This does not establish that such information is absent from the publications themselves.

= Comparison and Interpretation

The available records do not support a comparison of tracking accuracy, disturbance rejection, computational cost, or deployment conditions. In particular, the presence of RL and MPC-related titles in the same result set does not provide a common experimental basis for comparing the methods. No controller parameters, trajectory definitions, or numerical performance measures were available to the writer.

The defensible result is therefore an evidence gap: the search identifies relevant publications, but the information needed to answer the research questions remains missing. Constructing an algorithm taxonomy or ranking the methods from these titles would go beyond the retrieved evidence.

= Limitations

The run uses one search call and returns only four topic-relevant records. There is no full-text retrieval or further search during revision. The local course database contributes no relevant control evidence, and the Crossref response provides only bibliographic metadata for the relevant items. These constraints limit this report; they do not establish a shortage of research in the field.

= Conclusion

The retrieved evidence is insufficient for a technical comparison of reinforcement-learning-based quadrotor tracking methods. The next necessary step is to obtain abstracts or full texts of the relevant records and extract their controller designs, evaluation settings, and reported results. Until then, the outcome of this run is a scoped account of what the search found and what remains unanswered.

= Review Outcome

The baseline reviewer rejected the first draft because its technical claims exceeded the evidence. After one revision, it returned `REVIEW_APPROVED`. The separate post-run audit confirmed that all eight citation identifiers in the Chinese report were registered. Together these records show that the workflow accepted a report acknowledging insufficient evidence; they do not demonstrate completion of the intended technical survey.

= Evidence Registry

The titles and links below reproduce the saved registry. Links identify the retrieved records; their target pages and full texts were not newly reviewed for this report.

#figure(
  {
  set text(size: 10pt)
  table(
    columns: (0.7cm, 1.7cm, 1fr, 3.0cm),
    align: left,
    inset: (x: 6pt, y: 6pt),
    stroke: (bottom: 0.5pt + rgb("#d7dce2")),
    fill: (x, y) => if y == 0 { rgb("#eef4f9") } else { none },
    table.header([*ID*], [*Origin*], [*Record title and year*], [*Evidence retrieved*]),
    [S1], [Course DB], [#link("https://arxiv.org/abs/2308.00352")[MetaGPT: Meta Programming for A Multi-Agent Collaborative Framework] (2023)], [Course summary; off-topic],
    [S2], [Course DB], [#link("https://arxiv.org/abs/2410.14209")[Agents4PLC: Automating Closed-loop PLC Code Generation and Verification] (2024)], [Course summary; off-topic],
    [S3], [Course DB], [#link("https://arxiv.org/abs/2308.08155")[AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation] (2023)], [Course summary; off-topic],
    [S4], [Course DB], [#link("https://link.springer.com/article/10.1007/s44336-024-00009-2")[A survey on LLM-based multi-agent systems] (2024)], [Course summary; off-topic],
    [S5], [Crossref], [#link("https://doi.org/10.2139/ssrn.4757475")[Anti-interference trajectory tracking control of quadrotor UAV based on reinforcement learning] (2024)], [Metadata only; no abstract],
    [S6], [Crossref], [#link("https://doi.org/10.1109/isset70600.2026.11682280")[A Composite MPC-INDI Control Framework for Quadrotor Trajectory Tracking] (2026)], [Metadata only; no abstract],
    [S7], [Crossref], [#link("https://doi.org/10.1109/hora61326.2024.10550704")[Optimal Trajectory Tracking Control for a Quadrotor UAV Based on Off-Policy Reinforcement Learning] (2024)], [Metadata only; no abstract],
    [S8], [Crossref], [#link("https://doi.org/10.17771/pucrio.acad.54178")[DEEP REINFORCEMENT LEARNING FOR QUADROTOR TRAJECTORY CONTROL IN VIRTUAL ENVIRONMENTS] (year not recorded)], [Metadata only; no abstract],
  )
  },
  caption: [Evidence returned in Task 1; titles link to the saved source URLs.],
  supplement: [Table],
)
