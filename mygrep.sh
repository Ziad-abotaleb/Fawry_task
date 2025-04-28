#!/bin/bash 

help() {
echo "Usage: ./mygrep [Options] search for a string in a file "
echo "Options : "
echo " -n                show the line numbers "
echo " -v                invert match (show lines that do not match) "
echo " --help            show this help message "

} 
# Check for --help flag
if [[ "$1" == "--help" ]]; then
    help
    exit 0
fi

# Check for enough arguments
if [[ $# -lt 2 ]]; then
    echo "Error: Not enough arguments."
    print_help
    exit 1
fi

# Initialize flags
show_line_numbers=false
invert_match=false

# Handle options
while [[ "$1" == -* ]]; do
    case "$1" in
        -n)
            show_line_numbers=true
            ;;
        -v)
            invert_match=true
            ;;
        -vn|-nv)
            show_line_numbers=true
            invert_match=true
            ;;
        *)
            echo "Error: Unknown option $1"
            print_help
            exit 1
            ;;
    esac
    shift
done

# Now, $1 is the search string, $2 is the filename
search_string="$1"
file="$2"

# Validate search string and file
if [[ -z "$search_string" || -z "$file" ]]; then
    echo "Error: Missing search string or file."
    print_help
    exit 1
fi

if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' does not exist."
    exit 1
fi

# Read and search the file
line_number=0
while IFS= read -r line; do
    ((line_number++))
    # Case-insensitive comparison
    if echo "$line" | grep -iq "$search_string"; then
        match=true
    else
        match=false
    fi

    if $invert_match; then
        match=$(! $match && echo true || echo false)
    fi

    if [[ "$match" == "true" ]]; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
