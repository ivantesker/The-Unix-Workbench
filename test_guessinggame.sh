#!/usr/bin/env bash
# File: test_guessinggame.sh
# Description: Automated test suite for guessinggame.sh
# Version: 1.0.0

set -euo pipefail

# Color codes for test output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test script path
readonly GAME_SCRIPT="./guessinggame.sh"

# Setup test environment
setup() {
    # Make sure the game script is executable
    chmod +x "$GAME_SCRIPT"
}

# Cleanup test environment
cleanup() {
    # Remove any temporary test files
    rm -f test_*.tmp 2>/dev/null || true
}

# Print test header
print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Guessing Game Test Suite${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Print test result
print_result() {
    local test_name="$1"
    local result="$2"
    local message="${3:-}"

    ((TESTS_RUN++))

    if [[ "$result" == "PASS" ]]; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓ PASS${NC} - $test_name"
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗ FAIL${NC} - $test_name"
        if [[ -n "$message" ]]; then
            echo -e "  ${YELLOW}Reason: $message${NC}"
        fi
    fi
}

# Test 1: Script exists and is executable
test_script_exists() {
    local test_name="Script exists and is executable"

    if [[ -x "$GAME_SCRIPT" ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Script not found or not executable"
    fi
}

# Test 2: Help option works
test_help_option() {
    local test_name="Help option (--help)"
    local output

    output=$("$GAME_SCRIPT" --help 2>&1) || true

    if [[ "$output" == *"Usage:"* ]] && [[ "$output" == *"Options:"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Help output doesn't contain expected text"
    fi
}

# Test 3: Version option works
test_version_option() {
    local test_name="Version option (--version)"
    local output

    output=$("$GAME_SCRIPT" --version 2>&1) || true

    if [[ "$output" == *"version"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Version output doesn't contain 'version'"
    fi
}

# Test 4: Invalid option handling
test_invalid_option() {
    local test_name="Invalid option handling"
    local output
    local exit_code=0

    output=$("$GAME_SCRIPT" --invalid-option 2>&1) || exit_code=$?

    if [[ $exit_code -ne 0 ]] && [[ "$output" == *"Error"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Script should exit with error for invalid option"
    fi
}

# Test 5: Script handles correct answer
test_correct_answer() {
    local test_name="Correct answer on first try"
    local output
    local file_count

    # Count files in current directory
    file_count=$(find . -maxdepth 1 -type f | wc -l)

    # Provide the correct answer
    output=$(echo "$file_count" | timeout 5 "$GAME_SCRIPT" 2>&1) || true

    if [[ "$output" == *"Congratulations"* ]] || [[ "$output" == *"correct"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Script didn't recognize correct answer"
    fi
}

# Test 6: Script handles wrong answer (too high)
test_wrong_answer_high() {
    local test_name="Wrong answer (too high) feedback"
    local output

    # Provide an answer that's definitely too high
    output=$(echo "999999" | timeout 5 "$GAME_SCRIPT" --max 1 2>&1) || true

    if [[ "$output" == *"high"* ]] || [[ "$output" == *"Game Over"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Script didn't provide 'too high' feedback"
    fi
}

# Test 7: Script handles wrong answer (too low)
test_wrong_answer_low() {
    local test_name="Wrong answer (too low) feedback"
    local output

    # Provide an answer that's definitely too low
    output=$(echo "0" | timeout 5 "$GAME_SCRIPT" --max 1 2>&1) || true

    if [[ "$output" == *"low"* ]] || [[ "$output" == *"Game Over"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Script didn't provide 'too low' feedback"
    fi
}

# Test 8: Max attempts option works
test_max_attempts() {
    local test_name="Max attempts option (--max)"
    local output

    # Try with max 1 attempt
    output=$(echo "0" | timeout 5 "$GAME_SCRIPT" --max 1 2>&1) || true

    if [[ "$output" == *"Game Over"* ]] || [[ "$output" == *"maximum"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Max attempts not working correctly"
    fi
}

# Test 9: Invalid directory handling
test_invalid_directory() {
    local test_name="Invalid directory handling"
    local output
    local exit_code=0

    output=$("$GAME_SCRIPT" --dir /nonexistent/directory/path 2>&1) || exit_code=$?

    if [[ $exit_code -ne 0 ]] && [[ "$output" == *"Error"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Script should error on invalid directory"
    fi
}

# Test 10: Valid directory option
test_valid_directory() {
    local test_name="Valid directory option (--dir)"
    local output

    output=$(echo "q" | timeout 5 "$GAME_SCRIPT" --dir /tmp 2>&1) || true

    if [[ "$output" == *"/tmp"* ]] || [[ "$output" == *"Thanks"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Directory option not working"
    fi
}

# Test 11: Quit command works
test_quit_command() {
    local test_name="Quit command (q, quit, exit)"
    local output

    output=$(echo "q" | timeout 5 "$GAME_SCRIPT" 2>&1) || true

    if [[ "$output" == *"Thanks"* ]] || [[ "$output" == *"quit"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Quit command not working"
    fi
}

# Test 12: Bash syntax check
test_bash_syntax() {
    local test_name="Bash syntax validation"
    local output
    local exit_code=0

    output=$(bash -n "$GAME_SCRIPT" 2>&1) || exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Syntax errors found: $output"
    fi
}

# Test 13: ShellCheck (if available)
test_shellcheck() {
    local test_name="ShellCheck linting"

    if ! command -v shellcheck &> /dev/null; then
        echo -e "${YELLOW}⊘ SKIP${NC} - $test_name (shellcheck not installed)"
        return
    fi

    local output
    local exit_code=0

    output=$(shellcheck "$GAME_SCRIPT" 2>&1) || exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "ShellCheck issues found"
        echo "$output"
    fi
}

# Test 14: Script has proper shebang
test_shebang() {
    local test_name="Proper shebang line"
    local first_line

    first_line=$(head -n 1 "$GAME_SCRIPT")

    if [[ "$first_line" == "#!/usr/bin/env bash" ]] || [[ "$first_line" == "#!/bin/bash" ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Shebang line is: $first_line"
    fi
}

# Test 15: Multiple wrong attempts
test_multiple_attempts() {
    local test_name="Multiple attempts handling"
    local output
    local file_count

    file_count=$(find . -maxdepth 1 -type f | wc -l)

    # Try wrong answer twice, then correct
    output=$(printf "999999\n0\n%s\n" "$file_count" | timeout 10 "$GAME_SCRIPT" --max 5 2>&1) || true

    if [[ "$output" == *"Congratulations"* ]] && [[ "$output" == *"3"* ]]; then
        print_result "$test_name" "PASS"
    else
        print_result "$test_name" "FAIL" "Multiple attempts not tracked correctly"
    fi
}

# Print test summary
print_summary() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Test Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Total tests run:    $TESTS_RUN"
    echo -e "${GREEN}Tests passed:       $TESTS_PASSED${NC}"

    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo -e "${RED}Tests failed:       $TESTS_FAILED${NC}"
        echo ""
        echo -e "${RED}Some tests failed!${NC}"
        echo ""
        return 1
    else
        echo -e "${RED}Tests failed:       $TESTS_FAILED${NC}"
        echo ""
        echo -e "${GREEN}All tests passed!${NC}"
        echo ""
        return 0
    fi
}

# Main test execution
main() {
    # Setup
    print_header
    setup

    # Run all tests
    echo -e "${YELLOW}Running tests...${NC}"
    echo ""

    test_script_exists
    test_bash_syntax
    test_shebang
    test_help_option
    test_version_option
    test_invalid_option
    test_invalid_directory
    test_valid_directory
    test_quit_command
    test_correct_answer
    test_wrong_answer_high
    test_wrong_answer_low
    test_max_attempts
    test_multiple_attempts
    test_shellcheck

    # Print summary
    print_summary
    local result=$?

    # Cleanup
    cleanup

    exit $result
}

# Run tests
main "$@"
