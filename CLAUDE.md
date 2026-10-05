# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A LaTeX tutorial paper, "A Tutorial on Type Theory, Foundations of Programming Languages, and Formal Verification" (John Altidor). It defines a small language, $\minilang$ (numbers, strings, `+`, `^` concatenation, `let`), gives its grammar, static semantics, and dynamic semantics, proves preservation and progress, and then walks through a Twelf encoding of it.

## Build

- `make`: runs `pdflatex` → `bibtex` → `pdflatex` ×2 on `type_theory.tex` and produces `type_theory.pdf`
- `make clean`: removes auxiliary files (`.aux`, `.log`, `.bbl`, `.blg`, `.out`, …)
- `make distclean`: also removes the PDF
- Pinned toolchain: `docker build -t typetheory-tex .` then `docker run --rm -v "$PWD":/workdir typetheory-tex` (runs `make`). The `Dockerfile` pins the same TeX Live 2026 image as the dissertation repo, by digest; `.devcontainer/` uses it too.

Spell check: `docker run --rm -v "$PWD":/w -w /w node:22-slim npx -y cspell@8 "**/*.tex"` must report 0 issues; add legitimate new terms to `project-words.txt`.

CI: `.github/workflows/build.yml` runs the Docker build, then fails if `type_theory.log` has a warning or an overfull or underfull box or `type_theory.blg` has a BibTeX warning, or if cspell reports an issue. Keep the build clean, or the push turns red; if a new message is genuinely expected, change the check in the workflow and the note here together. Dependabot (`.github/dependabot.yml`) opens monthly pull requests to bump the SHA-pinned GitHub Actions.

There are no tests. To verify a change, rebuild and check `type_theory.log` for new errors, undefined references, or undefined citations. The build currently has no LaTeX, package, or pdfTeX warnings and no overfull/underfull boxes, so any such message is new. Wide inference-rule derivations in figures use `\small` to fit the text width. Math in a section heading triggers hyperref "Token not allowed in a PDF string" warnings, so write it as `\texorpdfstring{$\minilang$}{MiniLang}`. Build outputs (`type_theory.{aux,bbl,blg,log,out,pdf}`) are gitignored.

The paper is licensed CC BY 4.0 (`LICENSE`). Don't add third-party files (style files, macro files) to the repo: use packages from TeX Live, and write any project macros in `my_macros.tex`.

Bibliography: BibTeX's log (`type_theory.blg`) must also have 0 warnings, so every entry without an `author` needs a `key` field (the plain style sorts by it). `refs.bib` holds only cited entries, and every URL was checked and working on 2026-10-02 (all `https`). The old Twelf wiki at `twelf.plparty.org` is gone; its pages now live at `https://twelf.org/wiki/<lowercase-hyphenated-title>/` (the site's sitemap lists them all). MIT Press blocks automated requests (HTTP 403), so the TAPL entry links to Pierce's own book page instead.

Grammar: LTeX+ (in the devcontainer) uses the `ltex.*` settings in `.devcontainer/devcontainer.json`. Its remaining notes are known false positives or deliberate style (e.g., "an `\code{exp}`", the parallel "Rule T.n says…" sentences, "all of the").

## Document structure

`type_theory.tex` is the root file. It loads the preamble and `\input`s the sections in order:

`intro` → `minilang_grammar` → `static` → `dynamic` → `preservation` → `progress` → `twelf` → `summary`, then `refs.bib` (plain style).

Nested inputs:
- `twelf.tex` → `twelf_syntax.tex` (→ `twelf_syntax_hoas.tex`), `twelf_static.tex` (→ `twelf_higher_judge.tex`), `twelf_wrapup.tex`
- `preservation.tex` → `preservation_proof.tex`
- Figures live in `figures/` and are `\input` from the section that uses them: grammar and example expressions from `minilang_grammar.tex`; type rules, derivation, and failure from `static.tex`; eval rules from `dynamic.tex`; the HOAS Twelf figure from `twelf_syntax_hoas.tex`.

The only preamble file is `my_macros.tex` (packages and all project macros, including the grammar symbols `\bnfdef` and `\bnfalt`); `mathpartir` comes from TeX Live. `hyperref` is loaded in `type_theory.tex` after every other package; keep it last, since packages loaded after it break its figure and footnote link targets (duplicate `figure.n` / missing `Hfootnote.n` pdfTeX warnings). The preamble also loads `\usepackage[T1]{fontenc}` and `lmodern` (with the default OT1 encoding, `\{`/`\}` inside `\code` fall back to math-font braces and an `OMS/cmtt` font warning), and `xurl` just before `hyperref` (lets bibliography URLs break anywhere, avoiding underfull lines).

## Conventions (from `my_macros.tex`)

- `\minilang` renders the language name; `\code{...}` is `\texttt`, used for object-language syntax such as `\code{let(x, e1, e2)}`.
- `\infer` (from the `proof` package) is **redefined** so the rule label is typeset via `\code`. `\cinfer[label]{conclusion}{premises}` wraps the conclusion in `\code` and is the usual way to write inference rules in the figures. Rules are labeled `T.n` (typing) and `D.n` (dynamic semantics); proofs refer to them by these labels.
- `\stepto`/`\stepsto` (`\mapsto`, `\mapsto^*`) are the transition relations. `\judge`, `\ftype`, `\aeq`, and `\caseitem` (for proof case analyses) are defined there too. Use these macros instead of writing the notation by hand.
- Sections and figures use `\label{sec:...}` / `\label{fig:...}`.

## Twelf code in the paper

The `twelf*.tex` files quote and cite code from the twelf_tutorial repo (github.com/jgaltidor/twelf_tutorial; locally `~/Documents/mywork/repos/twelf_tutorial`). The citations refer to its tag `v1.0`, which `refs.bib` (`twelf-tutorial`) and the README link to. The slide decks are cited too (`typetheory-slides`, `twelf-slides` in `refs.bib`), pointing at the `v1.0` releases of github.com/jgaltidor/typetheory_slides and github.com/jgaltidor/twelf_slides; the README links their latest releases.

- Cited line numbers (find them with `grep -n -i 'line' twelf*.tex`): `syntax.elf` 4, 7, 10–12, 15–27, 26, 34–37, 39–40, 43–44; `typing.elf` 5, 8, 21, 25–26; `preservation.elf` 23–27; `progress.elf` 11–12, 153–154. After any change to those files, recheck every cited line against the code.
- Quoted Twelf output must come from Twelf itself, never be written by hand. Run it in twelf_tutorial's Docker image (`./check.sh` prints the full output). Current Twelf prints derivations with implicit arguments omitted (`D2 = of/add of/nat of/nat`), so the paper shows the fully applied forms separately.
- The coverage error in `twelf_wrapup.tex` was produced by deleting lines 23–27 of `preservation.elf` in a scratch copy and running `./check.sh`; Twelf reports it at the `%total` line (98.8–98.11 after the deletion).
- If the `.elf` files change in a way that moves cited lines or quoted code: update the paper, tag the new twelf_tutorial version, point `refs.bib` and the README at the new tag, and publish a new paper release (see README, "Releasing").
