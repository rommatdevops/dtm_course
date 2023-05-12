#!/usr/bin/bash


arguments_count () {  
    shift
    echo "Argument count is $#"
    if [ $# -le 5 ]
    then 
        echo "Ok, let\`s see what we have here..."
        select_one_name "$@"
    else
        echo "Hey, not all at once. Set less then 6"
        exit 1
    fi 
}

select_one_name () {
    echo "..watching list of names..."
    echo "$@"
    new_array=()
    for name in "$@"
    do 
        check_name_in_list "$name"
        
    done
    
}

check_name_in_list () {
    case $1 in 

        Harry)
            echo "$1 is good, come in"
            push_ups "$1"
            ;;

        John | Marry)
            echo "Hmm, $1, you can come in too"
            push_ups "$1"
            ;;
        
        Wayne)
            echo "Sorry, $1, you can\`t come in"
            echo "You must run a few minutes"
            run "$1"
            ;;

        *)
            echo "$1, you are not in list, sorry"
            ;;

    esac
}

push_ups () {
    push_ups=$((1 + $RANDOM % 10))
    echo "Ok, $1, do $push_ups push_ups"
    i=0
    echo "$1 do:"
    while [ $i -le $push_ups ]
    do 
        echo -n "..$i.."
        i=$(( $i+1 ))
    done
    printf " $1 finish excercise\n"
}

run () {
    seconds=5
    i=0
    echo "$1 do run:"
    until [ $i -gt $seconds ]
    do
        echo -n "..$i minute run.. "
        i=$(( $i+1 ))
    done
    printf " $1 finish excercise\n"
}

select_func() {
    echo "Select name, what do you like more:"
    select name in Frank Lisa Steven Cody Walton
    do
        echo "You have chosen $name"
        return
    done
    
}

shift_func () {
    echo "Show all arguments: $@"
    echo "That\`s not good, let\`s try something else"
    shift
    echo "Show all arguments: $@"
    echo "Great, that\`s shift"
}

read_file () {

}

usage () {
    if [ $# -le 1 ]
    then 
        echo "Usage: ./args.sh -a [SET SOME NAMES AS ARGUMENTS TO CHEK PROGRAM RESULT]"
        echo "OR"
        echo "Usage: ./args.sh -b [ANY]"
        return
    fi
}

main () {
    if [ $# -le 1 ] && [ $# != 1 ]
    then 
        usage "$#"
    else
        arguments_count "$@"
        
    fi
}

while getopts "a:b:" opt; do
  case $opt in
    a)
        a_arg="$OPTARG"
        echo "Used parameter -a"

        shift_func $@
        if [ $# == 2 ]
        then            
            main "$2"
        else
            main "$@"
        fi
        ;;
    b)
        b_arg="$OPTARG"
        echo "Used parameter -b"
        select_func
        ;;
    \?)
        echo "Unknown parameter: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Parameter -$OPTARG need an argument" >&2
        exit 1
        ;;
    *)
        echo "Something went wrong" >&2
        exit 1
        ;;
  esac
done

if [[ -z "$a_arg" ]] || [[ -z "$b_arg" ]]
then
  usage "$@"
  exit 1
fi
