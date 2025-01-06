#!/bin/bash

# Test script for 101-quote.c

echo "Testing 101-quote.c..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 101-quote.c exists
if [ ! -f "0x00-hello_world/101-quote.c" ]; then
    echo "❌ File 101-quote.c is missing."
    exit 1
fi

# Compile the program with all required flags
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 0x00-hello_world/101-quote.c -o tests/0x00-hello_world/outputs/101-quote.out 2> /tmp/101-quote-errors
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed for 101-quote.c. Check errors in /tmp/101-quote-errors."
    exit 1
fi

# Run the compiled program and capture the output to standard error
output=$(./tests/0x00-hello_world/outputs/101-quote.out 2>&1 >/dev/null)
return_code=$?

# Check if the program produces the correct output
expected_output='and that piece of art is useful" - Dora Korpar, 2015-10-19'
if [ "$output" != "$expected_output" ]; then
    echo "❌ The program output is incorrect."
    echo "Expected: '$expected_output'"
    echo "Got: '$output'"
    exit 1
fi

# Check if the program exits with FAILURE (1)
if [ $return_code -ne 1 ]; then
    echo "❌ The program did not return a FAILURE value (1)."
    exit 1
fi

# Check if the allowed function 'write' is used with ltrace
ltrace_output=$(ltrace -e write ./tests/0x00-hello_world/outputs/101-quote.out 2>&1 | grep write)
if [ -z "$ltrace_output" ]; then
    echo "❌ The function 'write' was not used in the program."
    exit 1
fi

# Ensure no other prohibited functions are used
if grep -qE "printf|puts" 0x00-hello_world/101-quote.c; then
    echo "❌ Prohibited functions 'printf' or 'puts' were used in the program."
    exit 1
fi

# Check Betty style for code formatting
if command -v betty >/dev/null 2>&1; then
    betty_output=$(betty 0x00-hello_world/101-quote.c 2>&1)
    if echo "$betty_output" | grep -q "ERROR"; then
        echo "❌ Betty style checks failed:"
        echo "$betty_output"
        exit 1
    fi
else
    echo "⚠️  Betty not installed. Skipping style checks."
fi

# Final success message
echo "✅ All tests passed for 101-quote!"
exit 0
