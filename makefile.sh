#!/usr/bin/env bash
# File: makefile.sh
# Description: Build script to generate project documentation
# Version: 2.0.0

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly GAME_SCRIPT="${SCRIPT_DIR}/guessinggame.sh"

# Color codes
if [[ -t 1 ]]; then
    readonly GREEN='\033[0;32m'
    readonly BLUE='\033[0;34m'
    readonly YELLOW='\033[1;33m'
    readonly NC='\033[0m'
else
    readonly GREEN=''
    readonly BLUE=''
    readonly YELLOW=''
    readonly NC=''
fi

# Error handling
error_exit() {
    echo -e "${YELLOW}Error: $1${NC}" >&2
    exit 1
}

# Count lines in the main game script
count_lines() {
    if [[ ! -f "$GAME_SCRIPT" ]]; then
        error_exit "Game script not found: $GAME_SCRIPT"
    fi
    wc -l < "$GAME_SCRIPT" | tr -d ' '
}

# Generate README.md
generate_readme() {
    local line_count
    local current_date

    line_count=$(count_lines)
    current_date=$(date '+%B %d, %Y at %H:%M:%S %Z')

    echo -e "${BLUE}Generating README.md...${NC}"

    cat > "${SCRIPT_DIR}/README.md" << EOF
# The Unix Workbench - Guessing Game Project

A fun and interactive command-line guessing game written in Bash.

## Project Information

- **Project Name:** GuessingGame
- **Generated:** ${current_date}
- **Lines of Code:** ${line_count} lines in \`guessinggame.sh\`

## Description

This project is part of The Unix Workbench course. It features an interactive guessing game where players try to guess the number of files in a directory.

## Features

- 🎮 Interactive command-line gameplay
- 🎨 Colorized output for better user experience
- ✅ Input validation and error handling
- 🔧 Configurable game settings (custom directories, attempt limits)
- 📊 Attempt tracking and statistics
- 🚪 Graceful exit handling

## Installation

Clone this repository:

\`\`\`bash
git clone <repository-url>
cd The-Unix-Workbench
\`\`\`

Make the script executable:

\`\`\`bash
chmod +x guessinggame.sh
\`\`\`

## Usage

Run the game with default settings:

\`\`\`bash
./guessinggame.sh
\`\`\`

View available options:

\`\`\`bash
./guessinggame.sh --help
\`\`\`

### Options

- \`-h, --help\` - Display help message
- \`-v, --version\` - Display version information
- \`-d, --dir DIR\` - Specify a directory to count files in
- \`-m, --max NUM\` - Set maximum number of attempts (0 for unlimited)

### Examples

Play with unlimited attempts:

\`\`\`bash
./guessinggame.sh --max 0
\`\`\`

Play with a specific directory:

\`\`\`bash
./guessinggame.sh --dir /path/to/directory
\`\`\`

Limit to 5 attempts:

\`\`\`bash
./guessinggame.sh --max 5
\`\`\`

## How to Play

1. Run the script
2. Read the rules and see how many attempts you have
3. Guess the number of files in the directory
4. Get hints if your guess is too high or too low
5. Win by guessing correctly!
6. Type 'q', 'quit', or 'exit' to quit anytime

## Building

To regenerate this README and build the project:

\`\`\`bash
make
\`\`\`

Or run the build script directly:

\`\`\`bash
./makefile.sh
\`\`\`

## Testing

Run the automated tests:

\`\`\`bash
make test
\`\`\`

Or run tests directly:

\`\`\`bash
./test_guessinggame.sh
\`\`\`

## Requirements

- Bash 4.0 or higher
- Standard Unix utilities (find, wc, date)

## License

MIT License - See LICENSE file for details

## Author

Created as part of The Unix Workbench course

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

*This README was automatically generated on ${current_date}*
EOF

    echo -e "${GREEN}✓ README.md generated successfully${NC}"
}

# Main function
main() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Unix Workbench Project Build Script${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    generate_readme

    echo ""
    echo -e "${GREEN}Build completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Note:${NC} README.md has been generated."
    echo -e "      To commit changes, run: ${BLUE}git add . && git commit -m 'Your message'${NC}"
}

main "$@"
