# Makefile for The Unix Workbench - Guessing Game Project
# Version: 2.0.0

.PHONY: all build clean test install uninstall help lint check run

# Default target
all: build

# Build the project (generate README)
build:
	@echo "Building project..."
	@./makefile.sh
	@echo "Build complete!"

# Generate README.md
readme:
	@./makefile.sh

# Run tests
test:
	@if [ -f test_guessinggame.sh ]; then \
		echo "Running tests..."; \
		bash test_guessinggame.sh; \
	else \
		echo "Warning: test_guessinggame.sh not found. Skipping tests."; \
	fi

# Run the game
run:
	@./guessinggame.sh

# Install the game to /usr/local/bin
install:
	@echo "Installing guessinggame to /usr/local/bin..."
	@install -m 755 guessinggame.sh /usr/local/bin/guessinggame
	@echo "Installation complete! You can now run 'guessinggame' from anywhere."

# Uninstall the game from /usr/local/bin
uninstall:
	@echo "Uninstalling guessinggame..."
	@rm -f /usr/local/bin/guessinggame
	@echo "Uninstall complete!"

# Check script syntax
check:
	@echo "Checking bash syntax..."
	@bash -n guessinggame.sh && echo "✓ guessinggame.sh syntax OK"
	@bash -n makefile.sh && echo "✓ makefile.sh syntax OK"
	@if [ -f test_guessinggame.sh ]; then \
		bash -n test_guessinggame.sh && echo "✓ test_guessinggame.sh syntax OK"; \
	fi

# Lint bash scripts using shellcheck if available
lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "Running shellcheck..."; \
		shellcheck guessinggame.sh makefile.sh; \
		if [ -f test_guessinggame.sh ]; then \
			shellcheck test_guessinggame.sh; \
		fi; \
		echo "Linting complete!"; \
	else \
		echo "Warning: shellcheck not installed. Install with: apt-get install shellcheck"; \
	fi

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@rm -f README.md~
	@echo "Clean complete!"

# Display help information
help:
	@echo "Unix Workbench - Guessing Game Project"
	@echo ""
	@echo "Available targets:"
	@echo "  make              - Build the project (generate README)"
	@echo "  make build        - Build the project"
	@echo "  make readme       - Generate README.md"
	@echo "  make test         - Run automated tests"
	@echo "  make run          - Run the guessing game"
	@echo "  make check        - Check bash script syntax"
	@echo "  make lint         - Lint scripts with shellcheck"
	@echo "  make install      - Install game to /usr/local/bin"
	@echo "  make uninstall    - Remove game from /usr/local/bin"
	@echo "  make clean        - Clean generated files"
	@echo "  make help         - Display this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make && make test - Build and test"
	@echo "  make run          - Play the game"
	@echo "  sudo make install - Install system-wide"
