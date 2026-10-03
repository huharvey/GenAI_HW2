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
      #align(center)[Agent & Multi-Agent Systems: Task 2 Research Report]
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
  #text(size: 27pt, weight: "bold")[Task 2 Research Report]
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
    [Frozen run:], [`advanced_20261003_212723`],
    [Date:], [October 3, 2026],
  )
  #set text(size: 11pt)
]
#pagebreak()

= Scope and Provenance

Related documents: #link("HW2_Report.pdf")[Overall Assignment Report] and #link("HW2_Task1_Research_Report.pdf")[Task 1 Research Report]. Code and run instructions: #link("https://github.com/huharvey/GenAI_HW2")[GitHub repository]. Keep the three extracted PDFs in the same directory to use the document links.

This report is an edited English version of the final output from the improved MAS, run `advanced_20261003_212723`. The run includes one writer revision, two in-loop citation audits, and final reviewer approval. The original Chinese report and complete trace are preserved in the frozen-output directory.

This edition narrows the approved draft's overstatements about publication availability and controller performance to the evidence actually retrieved. No sources or results are added. Citation identifiers are local to this run and differ from those in Task 1.

= Research Question

Quadrotor trajectory tracking requires a vehicle to follow a reference trajectory. This report examines the role reinforcement learning can play in adapting the controller. The one retrieved abstract with substantive method information addresses parameter uncertainty, channel coupling, and external disturbances through a combination of Q-learning, sliding-mode control, and disturbance observers \[S5\].

= Findings from the Retrieved Records

== Research topics identifiable from titles

Three Crossref records contain bibliographic metadata without abstracts. Their titles concern deep reinforcement learning for quadrotor trajectory control in virtual environments \[S2\], reinforcement learning for anti-interference tracking \[S3\], and off-policy reinforcement learning for optimal tracking \[S4\]. They identify relevant research directions, but do not establish particular policy architectures, controller performance, or real-flight validation. The remaining course-database record, \[S1\], concerns PLC code generation and is outside the scope of this survey.

== Q-learning-assisted sliding-mode control

The abstract in \[S5\] describes a controller that combines Q-learning with nonsingular terminal sliding-mode control. A tracking-error model groups channel coupling and external interference into lumped disturbances. Extended-state observers in the outer position loop and inner attitude loop estimate these disturbances for compensation. A Q-learning algorithm based on a fuzzy strategy adjusts key controller and observer parameters, using a reward function to update Q values and a trained Q table for control \[S5\].

= Method Comparison

The authors of \[S5\] report reduced manual tuning effort, adaptation to changing flight conditions, closer agreement with the reference trajectory in simulation comparisons, and good robustness. These are qualitative claims from the retrieved abstract. It supplies no numerical tracking errors, disturbance magnitudes, named comparison controllers, or statistical results, so neither the size of the improvement nor superiority over PID or MPC can be assessed here.

= Limitations

Only one of the four topic-relevant records includes an abstract with method details. The other three cannot support detailed technical comparisons. The abstract in \[S5\] mentions simulation and comparison experiments but gives no real-flight validation information. This limits what this report can conclude about deployment; it does not prove that no such validation exists elsewhere in the publication or literature.

The evidence registry also contains two similarly titled anti-interference records, \[S3\] and \[S5\], with different DOIs and author lists. They are retained as separate retrieval records, but their relationship was not verified. Record counts should therefore not be interpreted as a count of independent research contributions. No quadrotor simulation or controller experiment was conducted as part of this MAS assignment.

= Conclusion

The retrieved abstract provides one concrete example of reinforcement learning used for parameter adaptation in quadrotor trajectory tracking: Q-learning combined with sliding-mode control and disturbance observers \[S5\]. Its qualitative simulation findings motivate further examination, but the current evidence does not support a quantitative performance comparison or conclusions about real-flight effectiveness. This report is a limited evidence summary, not a comprehensive survey.

= Review Outcome

Both in-loop audits passed for the four cited sources `[S2]`, `[S3]`, `[S4]`, and `[S5]`. The reviewer nevertheless rejected the first draft because some claims exceeded the retrieved evidence. The writer revised the draft and the reviewer then returned `REVIEW_APPROVED`.

The approved draft still required the editorial corrections stated in the scope note. Approval and citation-ID validity alone did not establish that every claim was supported.

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
    [S1], [Course DB], [#link("https://arxiv.org/abs/2410.14209")[Agents4PLC: Automating Closed-loop PLC Code Generation and Verification] (2024)], [Course summary; off-topic],
    [S2], [Crossref], [#link("https://doi.org/10.17771/pucrio.acad.54178")[DEEP REINFORCEMENT LEARNING FOR QUADROTOR TRAJECTORY CONTROL IN VIRTUAL ENVIRONMENTS] (year not recorded)], [Metadata only; no abstract],
    [S3], [Crossref], [#link("https://doi.org/10.2139/ssrn.4757475")[Anti-interference trajectory tracking control of quadrotor UAV based on reinforcement learning] (2024)], [Metadata only; no abstract],
    [S4], [Crossref], [#link("https://doi.org/10.1109/hora61326.2024.10550704")[Optimal Trajectory Tracking Control for a Quadrotor UAV Based on Off-Policy Reinforcement Learning] (2024)], [Metadata only; no abstract],
    [S5], [Crossref], [#link("https://doi.org/10.61784/jcsee3115")[ANTI-INTERFERENCE TRAJECTORY TRACKING CONTROL OF QUADROTOR UAV BASED ON REINFORCEMENT LEARNING] (2026)], [Abstract available],
  )
  },
  caption: [Evidence returned in Task 2; titles link to the saved source URLs.],
  supplement: [Table],
)
