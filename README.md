# A Tutorial on Type Theory, Foundations of Programming Languages, and Formal Verification

LaTeX source for a tutorial paper by John Altidor. It introduces type theory as it is used to specify programming languages, by working through a small example language, *MiniLang*. MiniLang has numbers, strings, addition, string concatenation, and `let`.

**Download the PDF:** [typetheory_paper.pdf](https://github.com/jgaltidor/typetheory_paper/releases/latest/download/typetheory_paper.pdf) (latest release; earlier versions are on the [Releases](https://github.com/jgaltidor/typetheory_paper/releases) page).

The paper covers:

- **Syntax**: a grammar and abstract syntax trees for MiniLang
- **Static semantics**: typing rules and derivations, and why some well-formed ASTs are ill-typed
- **Dynamic semantics**: a transition system describing how expressions evaluate
- **Type safety**: proofs of preservation and progress by structural induction
- **Formal verification**: how MiniLang and its proofs are encoded in the [Twelf](https://twelf.org/) proof assistant, including higher-order abstract syntax and hypothetical judgments

The full Twelf encoding of MiniLang is in a separate repository: [jgaltidor/twelf_tutorial](https://github.com/jgaltidor/twelf_tutorial). Line numbers cited in the paper refer to its [`v1.0`](https://github.com/jgaltidor/twelf_tutorial/tree/v1.0) tag.

Two slide decks accompany the paper, each with its LaTeX source and released PDF in its own repository:

- [jgaltidor/typetheory_slides](https://github.com/jgaltidor/typetheory_slides) ([PDF](https://github.com/jgaltidor/typetheory_slides/releases/latest/download/typetheory_slides.pdf)): MiniLang, its semantics, and type safety
- [jgaltidor/twelf_slides](https://github.com/jgaltidor/twelf_slides) ([PDF](https://github.com/jgaltidor/twelf_slides/releases/latest/download/twelf_slides.pdf)): the Twelf encoding of MiniLang, in more detail than the paper

## Building

You need a LaTeX distribution that provides `pdflatex` and `bibtex`, such as TeX Live or MacTeX. A full install has every package the paper uses.

```sh
make            # builds type_theory.pdf
make clean      # removes auxiliary build files
make distclean  # also removes type_theory.pdf
```

For a reproducible build, use the pinned toolchain in `Dockerfile` (a TeX Live 2026 snapshot, pinned by digest). The paper builds with it with no LaTeX warnings:

```sh
docker build -t typetheory-tex .
docker run --rm -v "$PWD":/workdir typetheory-tex          # runs make
docker run --rm -v "$PWD":/workdir typetheory-tex make clean
```

`.devcontainer/` opens the same image in VS Code, with LaTeX Workshop set to build with `make`. It also installs Claude Code (the VS Code extension and the `claude` CLI), whose login and settings persist in a Docker volume.

Spell checking uses `cspell.json` with the project word list `project-words.txt` (names, jargon, and code identifiers); add legitimate new terms there rather than ignoring warnings. Check from the command line with `npx cspell "**/*.tex"`, or in Docker:

```sh
docker run --rm -v "$PWD":/w -w /w node:22-slim npx -y cspell@8 "**/*.tex"
```

It should report 0 issues. In the devcontainer, Code Spell Checker reports spelling and LTeX+ checks grammar; LTeX+'s own spelling rule is disabled so there is a single source of spelling warnings.

GitHub Actions (`.github/workflows/build.yml`) builds the PDF in the pinned image on every push and pull request, and fails if the build reports any LaTeX warning, an overfull or underfull box, a BibTeX warning, or a spelling issue. The built PDF is attached to each run as an artifact.

## Releasing

The PDF is published as a GitHub Release asset, not committed (build outputs are gitignored). Pushing a version tag publishes it: GitHub Actions builds the tag in the pinned image, runs the same checks as every push, and creates the release with the PDF attached. The tag must be annotated; its first line becomes the release title and any further lines become the release notes:

```sh
git tag -a v1.7 -F - <<'EOF'
Type theory tutorial paper v1.7

- What changed in this release.
EOF
git push origin v1.7
```

If a check fails, no release is created. Fix the problem on `master`, then move the tag to the fixed commit and push it again (`git tag -d v1.7`, `git push origin :refs/tags/v1.7`, and tag again).

Keep the asset named `typetheory_paper.pdf`: the README above and the [twelf_tutorial](https://github.com/jgaltidor/twelf_tutorial) README link to `releases/latest/download/typetheory_paper.pdf`, which always serves the newest release.

## Layout

- `type_theory.tex` is the root document. Each section is a separate `.tex` file pulled in with `\input`.
- `figures/` holds the grammar, typing rules, evaluation rules, and example figures.
- `my_macros.tex` defines the project's macros and loads its packages.
- `refs.bib` is the bibliography.

## License

The paper (its text, figures, and LaTeX source) is copyright John Altidor and licensed under the [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/) (CC BY 4.0); see [`LICENSE`](LICENSE). You may share and adapt it, including commercially, as long as you give appropriate credit.

The LaTeX packages it uses, such as `mathpartir`, come from TeX Live and are not part of this repository.
