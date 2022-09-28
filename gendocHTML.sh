#!/bin/bash 

pandoc -f gfm -t html -o doc_html/manual-dark.html --metadata title="termux-gui-bash Manual" --self-contained --template doc_templates/doctemplate.html --css doc_templates/github-markdown-dark.css Manual.md
pandoc -f gfm -t html -o doc_html/manual-light.html --metadata title="termux-gui-bash Manual" --self-contained --template doc_templates/doctemplate.html --css doc_templates/github-markdown-light.css Manual.md
pandoc -f gfm -t html -o doc_html/tutorial-dark.html --metadata title="termux-gui-bash Tutorial" --self-contained --template doc_templates/doctemplate.html --css doc_templates/github-markdown-dark.css TUTORIAL.md
pandoc -f gfm -t html -o doc_html/tutorial-light.html --metadata title="termux-gui-bash Tutorial" --self-contained --template doc_templates/doctemplate.html --css doc_templates/github-markdown-light.css TUTORIAL.md

gzip doc_html/*.html
