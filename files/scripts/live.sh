RunOnFileChange(){
    if ! [ -n "$1" ]; then
          echo "Specify input file"
          return 1
    fi
    if [ ! -f "$1" ] ; then
        echo "File does not exist"
        return 2
    fi
    if ! [ -n "$2" ]; then
          echo "Specify input command"
          return 3
    fi
    eval $2
    while true; do
        inotifywait -q -e modify $1;
        echo $(date +"%T") ": $1 was modified..."
        eval $2
    done;
}
LiveLatex(){
    if [[ $1 != *.tex ]]; then
        echo "Please provide .tex file"
        return 4
    fi
    RunOnFileChange $1 "echo -e '' && pdflatex -halt-on-error $1 && echo -e '\n\n\n'"
}

LiveMd(){
    if [[ $1 != *.md ]]; then
        echo "Please provide .md file"
        return 4
    fi
    filename="$(basename -s .md $1).pdf"
    RunOnFileChange $1 "pandoc $1 -s -o $filename && echo -e 'Rerendered pdf\n'"
}
