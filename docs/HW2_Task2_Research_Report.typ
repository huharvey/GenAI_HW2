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

#align(center)[
  #v(2.4cm)
  #text(size: 17pt, weight: "bold")[Gen AI · Assignment 2]
  #v(1cm)
  #text(size: 27pt, weight: "bold")[Task 2 Research Report]
  #v(0.8cm)
  #text(size: 16pt)[Reinforcement Learning for Quadrotor Trajectory Tracking]
  #v(6.2cm)
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
]
#pagebreak()

= Report Note

This document is an English rendering of the final research report produced by the frozen Task 2 improved MAS. The original Chinese output and complete trace are preserved in the submitted frozen-output directory. The `[S#]` identifiers below refer only to the evidence registry from that run. The final report was produced after one `REVISION_REQUIRED` cycle, two in-loop calls to `audit_citations()`, and a final `REVIEW_APPROVED`.

= Problem Definition

Quadrotor trajectory tracking is a classical control task in which the UAV is required to follow a predefined reference trajectory accurately. The retrieved source [S5] describes the relevant control problem as being affected by parameter uncertainty, external disturbances, channel coupling, and the nonlinear dynamics of the quadrotor. It also motivates adaptive parameter adjustment because manual tuning can be cumbersome across changing flight environments [S5].

= Main Findings

The retrieved records cover several related directions. Three records provide only titles and bibliographic metadata: deep-reinforcement-learning-based quadrotor trajectory control in virtual environments [S2], reinforcement-learning-based anti-interference trajectory tracking [S3], and off-policy reinforcement learning for optimal quadrotor trajectory tracking [S4]. Because no abstracts were retrieved for these records, the report does not infer their detailed architectures or experimental conclusions.

A more informative record is [S5], whose Crossref entry includes a full abstract. The study combines Q-learning with a nonsingular terminal sliding-mode controller. It defines a tracking-error-based quadrotor model, converts channel coupling and external interference into lumped disturbances, and uses extended-state observers in the outer-loop position subsystem and inner-loop attitude subsystem to estimate and compensate those disturbances. A fuzzy-strategy Q-learning algorithm then adapts key controller and observer parameters by iteratively updating Q values through a reward function and using the trained Q table for control [S5].

= Method Comparison

According to the simulation and comparison results reported in [S5], the reinforcement-learning-assisted hybrid controller avoids part of the manual parameter-tuning process and adapts key parameters to different flight environments and flight states. The reported simulation shows a closer fit to the reference trajectory and good robustness [S5]. These claims are restricted to the evidence explicitly present in the retrieved abstract.

= Limitations

The evidence base remains narrow. Sources [S2], [S3], and [S4] expose only research titles, so they cannot support detailed method or performance claims. Source [S5] provides substantive technical evidence, but the retrieved abstract reports simulation and comparison experiments; no real-flight validation information is present in the retrieved evidence [S5]. Consequently, the current report should not be treated as a comprehensive survey of the field.

= Conclusion

The retrieved evidence indicates that reinforcement learning can be integrated with conventional nonlinear control to provide adaptive parameter tuning for quadrotor trajectory tracking. The Q-learning plus nonsingular terminal sliding-mode approach in [S5] reports improved trajectory fitting and robustness in simulation. However, the retrieved evidence remains limited, and broader studies with accessible method descriptions and real-flight validation are needed before strong field-wide conclusions can be drawn.

= Evidence Registry

#figure(
  table(
    columns: (0.9cm, 2.4cm, 7.2cm, 3.3cm),
    [*ID*], [*Source*], [*Title*], [*Evidence available*],
    [S1], [Course DB], [Agents4PLC: Automating Closed-loop PLC Code Generation and Verification], [Course summary; off-topic],
    [S2], [Crossref], [DEEP REINFORCEMENT LEARNING FOR QUADROTOR TRAJECTORY CONTROL IN VIRTUAL ENVIRONMENTS], [Bibliographic metadata only],
    [S3], [Crossref], [Anti-interference trajectory tracking control of quadrotor UAV based on reinforcement learning], [Bibliographic metadata only],
    [S4], [Crossref], [Optimal Trajectory Tracking Control for a Quadrotor UAV Based on Off-Policy Reinforcement Learning], [Bibliographic metadata only],
    [S5], [Crossref], [ANTI-INTERFERENCE TRAJECTORY TRACKING CONTROL OF QUADROTOR UAV BASED ON REINFORCEMENT LEARNING], [Full abstract available],
  ),
  caption: [Evidence available to the frozen Task 2 MAS run.],
  supplement: [Table],
)

= Final Review

The first Task 2 draft passed deterministic citation-ID validation but failed semantic review because some title-only sources were being used to support conclusions that their retrieved records did not contain. After revision, the detailed technical claims were restricted to [S5], the title-only sources were described only at title level, `audit_citations()` passed again, and the reviewer returned `REVIEW_APPROVED`.
