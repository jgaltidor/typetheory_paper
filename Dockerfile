# Frozen LaTeX toolchain for rebuilding the paper.
#
# Pinned to a TeX Live 2026 weekly snapshot (scheme-full) from the Island of
# TeX images, by digest, so the toolchain can never change underneath the
# document. The paper builds with this image with no LaTeX warnings and no
# overfull/underfull boxes.
#
# Build the PDF:
#   docker build -t typetheory-tex .
#   docker run --rm -v "$PWD":/workdir typetheory-tex
FROM registry.gitlab.com/islandoftex/images/texlive:TL2026-2026-09-20-full@sha256:7334b00bf8e7a0996f7ddd65482363aaf7711d372e569f3ea78509619e3083ff

WORKDIR /workdir
CMD ["make"]
