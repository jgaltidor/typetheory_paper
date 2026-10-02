# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A LaTeX tutorial paper, "A Tutorial on Type Theory, Foundations of Programming Languages, and Formal Verification" (John Altidor). It defines a small language, $\minilang$ (numbers, strings, `+`, `^` concatenation, `let`), gives its grammar, static semantics, and dynamic semantics, proves preservation and progress, and then walks through a Twelf encoding of it.

## Build

- `make`: runs `pdflatex` → `bibtex` → `pdflatex` ×2 on `type_theory.tex` and produces `type_theory.pdf`
- `make clean`: removes auxiliary files (`.aux`, `.log`, `.bbl`, `.blg`, `.out`, …)
- `make distclean`: also removes the PDF

There are no tests. To verify a change, rebuild and check `type_theory.log` for new errors, undefined references, or undefined citations. Some `hyperref` "Token not allowed in a PDF string" warnings and an `OMS/cmtt` font warning already exist and are expected. Build outputs (`type_theory.{aux,bbl,blg,log,out,pdf}`) are gitignored.

## Document structure

`type_theory.tex` is the root file. It loads the preamble and `\input`s the sections in order:

`intro` → `minilang_grammar` → `static` → `dynamic` → `preservation` → `progress` → `twelf` → `summary`, then `refs.bib` (plain style).

Nested inputs:
- `twelf.tex` → `twelf_syntax.tex` (→ `twelf_syntax_hoas.tex`), `twelf_static.tex` (→ `twelf_higher_judge.tex`), `twelf_wrapup.tex`
- `preservation.tex` → `preservation_proof.tex`
- Figures live in `figures/` and are `\input` from the section that uses them: grammar and example expressions from `minilang_grammar.tex`; type rules, derivation, and failure from `static.tex`; eval rules from `dynamic.tex`; the HOAS Twelf figure from `twelf_syntax_hoas.tex`.

Preamble files actually used: `my_macros.tex` (packages and most project macros), `math-cmds.sty`, `syn-defns07.tex`, and the bundled `mathpartir.sty`. `macros-lncs.tex`, `grammar.tex`, and `obey.tex` (top level, not `figures/grammar.tex`) are leftovers and are **not** included by the root file.

## Conventions (from `my_macros.tex`)

- `\minilang` renders the language name; `\code{...}` is `\texttt`, used for object-language syntax such as `\code{let(x, e1, e2)}`.
- `\infer` (from the `proof` package) is **redefined** so the rule label is typeset via `\code`. `\cinfer[label]{conclusion}{premises}` wraps the conclusion in `\code` and is the usual way to write inference rules in the figures. Rules are labeled `T.n` (typing) and `D.n` (dynamic semantics); proofs refer to them by these labels.
- `\stepto`/`\stepsto` (`\mapsto`, `\mapsto^*`) are the transition relations. `\judge`, `\ftype`, `\aeq`, and `\caseitem` (for proof case analyses) are defined there too. Use these macros instead of writing the notation by hand.
- Sections and figures use `\label{sec:...}` / `\label{fig:...}`.
