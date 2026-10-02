# A Tutorial on Type Theory, Foundations of Programming Languages, and Formal Verification

LaTeX source for a tutorial paper by John Altidor. It introduces type theory as it is used to specify programming languages, by working through a small example language, *MiniLang*. MiniLang has numbers, strings, addition, string concatenation, and `let`.

The paper covers:

- **Syntax**: a grammar and abstract syntax trees for MiniLang
- **Static semantics**: typing rules and derivations, and why some well-formed ASTs are ill-typed
- **Dynamic semantics**: a transition system describing how expressions evaluate
- **Type safety**: proofs of preservation and progress by structural induction
- **Formal verification**: how MiniLang and its proofs are encoded in the [Twelf](http://twelf.org) proof assistant, including higher-order abstract syntax and hypothetical judgments

The full Twelf encoding of MiniLang is in a separate repository: [jgaltidor/twelf_tutorial](https://github.com/jgaltidor/twelf_tutorial). Line numbers cited in the paper refer to its [`v1.0`](https://github.com/jgaltidor/twelf_tutorial/tree/v1.0) tag.

## Building

You need a LaTeX distribution that provides `pdflatex` and `bibtex`, such as TeX Live or MacTeX. A full install has every package the paper uses. `mathpartir.sty` and `math-cmds.sty` are included in this repository.

```sh
make            # builds type_theory.pdf
make clean      # removes auxiliary build files
make distclean  # also removes type_theory.pdf
```

## Layout

- `type_theory.tex` is the root document. Each section is a separate `.tex` file pulled in with `\input`.
- `figures/` holds the grammar, typing rules, evaluation rules, and example figures.
- `my_macros.tex` defines the project's macros and loads its packages.
- `refs.bib` is the bibliography.
