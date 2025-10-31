#!/usr/bin/env bash
# File: guessinggame.sh
# Description: A fun guessing game where users guess the number of files in a directory
# Version: 2.0.0

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Global variables
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly VERSION="2.0.0"
ATTEMPTS=0
MAX_ATTEMPTS=10
PARSED_DIR="."

# Color codes for better UX (if terminal supports it)
if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m' # No Color
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly NC=''
fi

# Trap to handle script interruption
trap 'echo -e "\n${YELLOW}Game interrupted. Thanks for playing!${NC}"; exit 130' INT TERM

# Display usage information
usage() {
    cat << EOF
${BLUE}Usage:${NC} ${SCRIPT_NAME} [OPTIONS]

${BLUE}Description:${NC}
    A guessing game where you try to guess the number of files in the current directory.

${BLUE}Options:${NC}
    -h, --help         Display this help message
    -v, --version      Display version information
    -d, --dir DIR      Specify a directory to count files in (default: current directory)
    -m, --max NUM      Maximum number of attempts (default: 10, 0 for unlimited)

${BLUE}Examples:${NC}
    ${SCRIPT_NAME}
    ${SCRIPT_NAME} --dir /path/to/directory
    ${SCRIPT_NAME} --max 5

EOF
    exit 0
}

# Display version information
version() {
    echo "${SCRIPT_NAME} version ${VERSION}"
    exit 0
}

# Error handling function
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Parse command line arguments
parse_args() {
    PARSED_DIR="."

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -v|--version)
                version
                ;;
            -d|--dir)
                if [[ -z "${2:-}" ]]; then
                    error_exit "Option --dir requires a directory argument"
                fi
                PARSED_DIR="$2"
                shift 2
                ;;
            -m|--max)
                if [[ -z "${2:-}" ]]; then
                    error_exit "Option --max requires a number argument"
                fi
                if ! [[ "$2" =~ ^[0-9]+$ ]]; then
                    error_exit "Max attempts must be a positive number"
                fi
                MAX_ATTEMPTS="$2"
                shift 2
                ;;
            *)
                error_exit "Unknown option: $1. Use --help for usage information."
                ;;
        esac
    done

    # Validate directory
    if [[ ! -d "$PARSED_DIR" ]]; then
        error_exit "Directory does not exist: $PARSED_DIR"
    fi
}

# Count files in directory
count_files() {
    local dir="$1"
    local count

    # Count only files (not directories) in the specified directory
    count=$(find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l)

    if [[ -z "$count" ]]; then
        error_exit "Failed to count files in directory: $dir"
    fi

    echo "$count"
}

# Validate user input
validate_input() {
    local input="$1"

    # Check if input is empty
    if [[ -z "$input" ]]; then
        return 1
    fi

    # Check if input is a positive integer
    if ! [[ "$input" =~ ^[0-9]+$ ]]; then
        return 1
    fi

    return 0
}

# Get user input
get_user_input() {
    local response

    while true; do
        read -r -p "$(echo -e "${BLUE}Your guess:${NC} ")" response

        # Handle empty input
        if [[ -z "$response" ]]; then
            echo -e "${YELLOW}Please enter a number.${NC}"
            continue
        fi

        # Handle quit command
        if [[ "$response" =~ ^(q|quit|exit)$ ]]; then
            echo -e "${YELLOW}Thanks for playing!${NC}"
            exit 0
        fi

        # Validate input
        if validate_input "$response"; then
            echo "$response"
            return 0
        else
            echo -e "${YELLOW}Invalid input. Please enter a positive number.${NC}"
        fi
    done
}

# Main game loop
play_game() {
    local target_dir="$1"
    local correct_answer
    local user_guess

    correct_answer=$(count_files "$target_dir")

    # Display welcome message
    cat << EOF
${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}
${GREEN}       Welcome to the File Guessing Game!${NC}
${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}

${BLUE}Rules:${NC}
  • Guess the number of files in the directory
  • You'll get hints if your guess is too high or low
  • Type 'q', 'quit', or 'exit' to quit anytime
EOF

    if [[ $MAX_ATTEMPTS -gt 0 ]]; then
        echo -e "  • You have ${GREEN}${MAX_ATTEMPTS}${NC} attempts\n"
    else
        echo -e "  • Unlimited attempts\n"
    fi

    echo -e "${BLUE}Directory:${NC} $(cd "$target_dir" && pwd)"
    echo ""

    # Game loop
    while true; do
        ((ATTEMPTS++))

        # Check max attempts
        if [[ $MAX_ATTEMPTS -gt 0 && $ATTEMPTS -gt $MAX_ATTEMPTS ]]; then
            echo -e "\n${RED}Game Over!${NC} You've reached the maximum number of attempts."
            echo -e "The correct answer was: ${GREEN}${correct_answer}${NC}"
            exit 1
        fi

        # Show attempt number
        if [[ $MAX_ATTEMPTS -gt 0 ]]; then
            echo -e "${YELLOW}Attempt ${ATTEMPTS}/${MAX_ATTEMPTS}${NC}"
        else
            echo -e "${YELLOW}Attempt ${ATTEMPTS}${NC}"
        fi

        user_guess=$(get_user_input)

        # Check the guess
        if [[ $user_guess -eq $correct_answer ]]; then
            echo ""
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${GREEN}  🎉 Congratulations! Your answer is correct! 🎉${NC}"
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "You guessed it in ${GREEN}${ATTEMPTS}${NC} attempt(s)!"
            echo ""
            exit 0
        elif [[ $user_guess -gt $correct_answer ]]; then
            echo -e "${RED}Too high!${NC} Try a smaller number.\n"
        else
            echo -e "${RED}Too low!${NC} Try a larger number.\n"
        fi
    done
}

# Main function
main() {
    local target_dir

    # Parse command line arguments and get the directory
    # Note: parse_args may exit for --help or --version
    parse_args "$@"
    target_dir="${PARSED_DIR:-.}"

    # Start the game
    play_game "$target_dir"
}

# Run main function
main "$@"