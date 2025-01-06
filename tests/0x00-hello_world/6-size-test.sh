#!/bin/bash

# Test script for 6-size.c

echo "Testing 6-size.c..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 6-size.c exists
if [ ! -f "0x00-hello_world/6-size.c" ]; then
    echo "❌ File 6-size.c is missing."
    exit 1
fi

# Prepare the test environment
mkdir -p tests/0x00-hello_world/outputs

# Compile the program for 32-bit architecture
gcc -m32 0x00-hello_world/6-size.c -o tests/0x00-hello_world/outputs/6-size32.out 2> /tmp/size32-errors
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed for 32-bit architecture. Check errors in /tmp/size32-errors."
    exit 1
fi

# Compile the program for 64-bit architecture
gcc -m64 0x00-hello_world/6-size.c -o tests/0x00-hello_world/outputs/6-size64.out 2> /tmp/size64-errors
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed for 64-bit architecture. Check errors in /tmp/size64-errors."
    exit 1
fi

# Run the program for 32-bit and check the output
expected_output_32="Size of a char: 1 byte(s)
Size of an int: 4 byte(s)
Size of a long int: 4 byte(s)
Size of a long long int: 8 byte(s)
Size of a float: 4 byte(s)"
output_32=$(./tests/0x00-hello_world/outputs/6-size32.out)
return_code_32=$?

if [ "$output_32" != "$expected_output_32" ]; then
    echo "❌ Incorrect output for 32-bit architecture."
    echo "Expected: "
    echo "$expected_output_32"
    echo "Got: "
    echo "$output_32"
    exit 1
fi

if [ $return_code_32 -ne 0 ]; then
    echo "❌ The program for 32-bit architecture did not return a SUCCESS value (0)."
    exit 1
fi

# Run the program for 64-bit and check the output
expected_output_64="Size of a char: 1 byte(s)
Size of an int: 4 byte(s)
Size of a long int: 8 byte(s)
Size of a long long int: 8 byte(s)
Size of a float: 4 byte(s)"
output_64=$(./tests/0x00-hello_world/outputs/6-size64.out)
return_code_64=$?

if [ "$output_64" != "$expected_output_64" ]; then
    echo "❌ Incorrect output for 64-bit architecture."
    echo "Expected: "
    echo "$expected_output_64"
    echo "Got: "
    echo "$output_64"
    exit 1
fi

if [ $return_code_64 -ne 0 ]; then
    echo "❌ The program for 64-bit architecture did not return a SUCCESS value (0)."
    exit 1
fi

# Check Betty style for code formatting
if command -v betty >/dev/null 2>&1; then
    betty_output=$(betty 0x00-hello_world/6-size.c 2>&1)
    if echo "$betty_output" | grep -q "ERROR"; then
        echo "❌ Betty style checks failed:"
        echo "$betty_output"
        exit 1
    fi
else
    echo "⚠️  Betty not installed. Skipping style checks."
fi

# Final success message
echo "✅ All tests passed for 6-size!"
exit 0
