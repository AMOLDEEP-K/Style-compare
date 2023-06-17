#!/usr/bin/env bash
# Amoldeep Kaur Phull (23208223)

if [[ $# -eq 0 ]] || [[ $# -gt 1 ]]
then
    echo "enter text file" > /dev/stderr
    exit 1
fi

# remove double hyphens 
sed 's/--/ /g' $1 | sed 's/-/h/g' | sed "s/'/m/g" > temp

#find and count occurances of comjunctions
words=(also although and as because before but for if nor of or since that though until when whenever whereas which while yet)
for i in "${words[@]}"
do
    w="$i"
    a=$(cat temp | grep -Eo -w -i "$w") 
    
    if [[ -z "$a" ]]
    then
        echo "$w: 0"
    else
        ans=$(cat temp | grep -Eo -w -i  "$w" | grep -v "[a-zA-Z]\+'[-'a-zA-Z]\+" | sort -f | uniq -i -c | awk '{print  $1 }')
        echo "$w: $ans"
    fi
    
done
rm temp

#count others , words, sentences etc
sed 's/--/ /g' $1 > test

#count commas
comm=$(grep -o -E , test | sed 's/,/comma/g' | uniq -c)
if [[ -z "$comm" ]]
then
    echo "semi_colon: 0"
else
    grep -o -E , test | sed 's/,/comma/g' | uniq -c | awk '{print $2": "$1}'
fi

#count semi colons
semi=$(grep -o -E \; test | sed 's/\;/semi_colon/g' | uniq -c)
if [[ -z "$semi" ]]
then
    echo "semi_colon: 0"
else
    grep -o -E \; test | sed 's/\;/semi_colon/g' | uniq -c | awk '{print $2": "$1}'
fi

#count compound words
comp=$(grep -o "[-a-zA-Z']\+\-['a-zA-Z\-]\+" test | wc -w)
if [[ -z "$comp" ]]
then
    echo "compound_word: 0"
else
    echo "compound_word: $comp"
fi

#count contractions
contract=$(grep -o "[a-zA-Z]\+'[-'a-zA-Z]\+" test | grep -v "[a-zA-Z]*[a-zA-Z]'['s]" | wc -w)
if [[ -z "$contract" ]]
then
    echo "contraction: 0"
else
    echo "contraction: $contract"
fi

#count words
words=$(grep -o "[a-zA-Z][-'a-zA-Z]*" test | wc -l)
echo "word: $words"

#count sentences
sent=$(grep -o '[/./?/!]'  test | wc -l)
echo "sentence: $sent"

rm test
