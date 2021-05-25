#!/bin/bash
# autor: Domink Švač

RED='\033[0;31m';
BLUE='\033[0;34m';
NC=$'\e[0m';
GREEN=$'\e[0;32m';

if [ $# -eq 0 ];then 
    echo "Example: ./test.sh [program] [testy]";
    exit 0;    
fi;

prog=$1;
path=$2;

if ! test -f "${path}/test0.in" ; then
        echo "Nenájdený test: ${path}/test0.in";
        exit 0; 
fi

number=0;
good=0;
echo " =======================================";
echo -e "|\t${GREEN}Testovanie${NC}: ${prog}\t\t|";
echo " =======================================";
while [ True ]
do
    if ! test -f "${path}/test${number}.in" ; then
        echo " =======================================";
        if [ $number == $good ]; then
            echo -e "${GREEN}RESULT:${NC} ${good}/${number} ${GREEN}passed${NC}";
        else
            echo -e "${RED}RESULT:${NC} ${good}/${number} ${RED}passed${NC}";
        fi
        rm -r "${path}/test.temp";
        exit 0; 
    fi

    file1="${path}/test${number}.in";
    file2="${path}/test${number}.out";
    fileTmp="${path}/test.temp";
    
    "./${prog}" < "${file1}" > "${fileTmp}";

    if ! test -f "${file2}" ; then
        echo "Nenájdený test: ${file2}";
        exit 0; 
    fi

    if [[ $(< ${file2}) != $(< ${fileTmp}) ]]; then
        echo -e "${BLUE}Test${NC}: ${file1} ${RED}BAD${NC}";
    else
        echo -e "${BLUE}Test${NC}: ${file1} ${GREEN}OK${NC}";
        good=$((good+1));
    fi
    number=$((number+1));
done


