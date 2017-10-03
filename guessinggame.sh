#!/usr/bin/env bash
# File: guessinggame.sh
O="$(ls | wc -l)"
echo "Welcome to the game!"
echo "Rules are simple."
echo "You should answer the question."
echo "If you are correct, you win."
echo "If not, try again."
echo "How many files are in this directory?"
function resp {
  read respond
}
resp
while [[ $respond -ne $O ]]
do
if [[ $respond -gt $O ]]
then
  echo "You entered: $respond, bigger than I was looking for. Please try again."
else
  echo "You entered: $respond, less than I was looking for. Please try again."
fi
resp
done
echo "Congrats! Your answer is finally right!"