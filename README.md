# The Unix Workbench - Guessing Game Project

A fun and interactive command-line guessing game written in Bash.

## Project Information

- **Project Name:** GuessingGame
- **Generated:** October 31, 2025 at 06:45:50 UTC
- **Lines of Code:** 248 lines in `guessinggame.sh`

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

```bash
git clone <repository-url>
cd The-Unix-Workbench
```

Make the script executable:

```bash
chmod +x guessinggame.sh
```

## Usage

Run the game with default settings:

```bash
./guessinggame.sh
```

View available options:

```bash
./guessinggame.sh --help
```

### Options

- `-h, --help` - Display help message
- `-v, --version` - Display version information
- `-d, --dir DIR` - Specify a directory to count files in
- `-m, --max NUM` - Set maximum number of attempts (0 for unlimited)

### Examples

Play with unlimited attempts:

```bash
./guessinggame.sh --max 0
```

Play with a specific directory:

```bash
./guessinggame.sh --dir /path/to/directory
```

Limit to 5 attempts:

```bash
./guessinggame.sh --max 5
```

## How to Play

1. Run the script
2. Read the rules and see how many attempts you have
3. Guess the number of files in the directory
4. Get hints if your guess is too high or too low
5. Win by guessing correctly!
6. Type 'q', 'quit', or 'exit' to quit anytime

## Building

To regenerate this README and build the project:

```bash
make
```

Or run the build script directly:

```bash
./makefile.sh
```

## Testing

Run the automated tests:

```bash
make test
```

Or run tests directly:

```bash
./test_guessinggame.sh
```

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

*This README was automatically generated on October 31, 2025 at 06:45:50 UTC*
