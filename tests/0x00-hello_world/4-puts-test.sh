#!/bin/bash

# Test script for 4-puts.c

echo "Testing 4-puts.c..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 4-puts.c exists
if [ ! -f "0x00-hello_world/4-puts.c" ]; then
    echo "❌ File 4-puts.c is missing."
    exit 1
fi

# Prepare the test environment
mkdir -p tests/0x00-hello_world/outputs

# Compile the program with all required flags
gcc -Wall -Werror -Wextra -pedantic -std=gnu89 0x00-hello_world/4-puts.c -o tests/0x00-hello_world/outputs/4-puts.out
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed for 4-puts.c."
    exit 1
fi

# Run the compiled program and capture the output
output=$(./tests/0x00-hello_world/outputs/4-puts.out)
return_code=$?

# Check if the program produces the correct output
expected_output="Programming is like building a multilingual puzzle"
if [ "$output" != "$expected_output" ]; then
    echo "❌ The program output is incorrect."
    echo "Expected: '$expected_output'"
    echo "Got: '$output'"
    exit 1
fi

# Check if the program exits with SUCCESS (0)
if [ $return_code -ne 0 ]; then
    echo "❌ The program did not return a SUCCESS value (0)."
    exit 1
fi

# Check if the allowed functions are used with ltrace
if command -v ltrace >/dev/null 2>&1; then
    ltrace_output=$(ltrace -e puts,write,putchar ./tests/0x00-hello_world/outputs/4-puts.out 2>&1 | grep puts)
    if [ -z "$ltrace_output" ]; then
        echo "❌ The function 'puts' was not used in the program."
        exit 1
    fi
else
    echo "⚠️  ltrace not installed. Skipping function usage checks."
fi

# Check Betty style for code formatting
if command -v betty >/dev/null 2>&1; then
    betty_output=$(betty 0x00-hello_world/4-puts.c 2>&1)
    if echo "$betty_output" | grep -q "ERROR"; then
        echo "❌ Betty style checks failed:"
        echo "$betty_output"
        exit 1
    fi
else
    echo "⚠️  Betty not installed. Skipping style checks."
fi

# Final success message
echo "✅ All tests passed for 4-puts!"
exit 0
