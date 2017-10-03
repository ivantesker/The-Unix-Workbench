#!/usr/bin/env bash
# File: makefile.sh
echo "GuessingGame project    " >> README.md
date >> README.md
echo '    ' >> README.md
echo "Number of lines in project    " >> README.md
cat guessinggame.sh | wc -l >> README.md
git add README.md
git add guessinggame.sh
git add makefile.sh
git commit -m "README"
git push -u origin master --force
