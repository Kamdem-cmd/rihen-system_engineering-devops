#!/bin/bash

# Test script for 0-positive_or_negative.c

echo "Testing 0-positive_or_negative.c..."

# Check if README.md exists and is not empty
if [ ! -f "0x01-variables_if_else_while/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

if [ ! -s "0x01-variables_if_else_while/README.md" ]; then
    echo "❌ README.md is empty."
    exit 1
fi

# Check if the source file exists
if [ ! -f "0x01-variables_if_else_while/0-positive_or_negative.c" ]; then
    echo "❌ File 0-positive_or_negative.c is missing."
    exit 1
fi

# Compile the program
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 0x01-variables_if_else_while/0-positive_or_negative.c -o tests/outputs/0-positive_or_negative.out
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed for 0-positive_or_negative.c."
    exit 1
fi

# Run the program multiple times to test different outputs
echo "Running tests for various values of n..."

test_cases=(
    "positive"
    "negative"
    "zero"
)

outputs=()
return_codes=()

for i in {1..10}; do
    output=$(./tests/outputs/0-positive_or_negative.out 2>&1)
    return_code=$?

    outputs+=("$output")
    return_codes+=("$return_code")
done

# Check outputs for different cases
found_positive=false
found_negative=false
found_zero=false

for output in "${outputs[@]}"; do
    if [[ "$output" == *"is positive" ]]; then
        found_positive=true
    elif [[ "$output" == *"is negative" ]]; then
        found_negative=true
    elif [[ "$output" == *"is zero" ]]; then
        found_zero=true
    fi
done

if ! $found_positive; then
    echo "❌ Program did not output a positive case."
    exit 1
fi

if ! $found_negative; then
    echo "❌ Program did not output a negative case."
    exit 1
fi

if ! $found_zero; then
    echo "❌ Program did not output a zero case."
    exit 1
fi

# Check return code for success
for return_code in "${return_codes[@]}"; do
    if [ $return_code -ne 0 ]; then
        echo "❌ Program did not return a SUCCESS value (0)."
        exit 1
    fi
done

# Check if the allowed functions are used with ltrace
ltrace_output=$(ltrace -e puts,write,printf,putchar,rand,srand,time ./tests/outputs/0-positive_or_negative.out 2>&1)
if [[ -z "$ltrace_output" ]]; then
    echo "❌ The program did not use allowed functions."
    exit 1
fi

# Check Betty style for code formatting
if command -v betty >/dev/null 2>&1; then
    betty_output=$(betty 0x01-variables_if_else_while/0-positive_or_negative.c 2>&1)
    if echo "$betty_output" | grep -q "ERROR"; then
        echo "❌ Betty style checks failed:"
        echo "$betty_output"
        exit 1
    fi
else
    echo "⚠️  Betty not installed. Skipping style checks."
fi

# Final success message
echo "✅ All tests passed for 0-positive_or_negative!"
exit 0
