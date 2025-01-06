#!/bin/bash

# Test script for 100-intel

echo "Testing 100-intel..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 100-intel exists
if [ ! -f "0x00-hello_world/100-intel" ]; then
    echo "❌ File 100-intel is missing."
    exit 1
fi

# Check if the script is exactly 2 lines long
line_count=$(wc -l < "0x00-hello_world/100-intel")
if [ "$line_count" -ne 2 ]; then
    echo "❌ The file 100-intel must be exactly 2 lines long. Found $line_count lines."
    exit 1
fi

# Check if the first line contains the correct shebang
first_line=$(head -n 1 "0x00-hello_world/100-intel")
if [ "$first_line" != "#!/bin/bash" ]; then
    echo "❌ The first line of 100-intel must contain '#!/bin/bash'."
    exit 1
fi

# Prepare the test environment
echo "Preparing the test environment..."
mkdir -p tests/0x00-hello_world/sources tests/0x00-hello_world/outputs

# Create the test C file
cat <<EOF > tests/0x00-hello_world/sources/100-main.c
#include <stdio.h>

/**
 * main - Entry point
 *
 * Return: Always 0 (Success)
 */
int main(void)
{
    printf("Intel Assembly Test\\n");
    return (0);
}
EOF

# Set the CFILE variable and run the student's script
export CFILE=tests/0x00-hello_world/sources/100-main.c
chmod +x 0x00-hello_world/100-intel
if ! ./0x00-hello_world/100-intel; then
    echo "❌ The script './0x00-hello_world/100-intel' failed to execute."
    exit 1
fi

# Check if the output assembly file is generated
output_file="tests/0x00-hello_world/sources/100-main.s"
if [ ! -f "$output_file" ]; then
    echo "❌ The script did not generate the expected output file '$output_file'."
    exit 1
fi

# Check if the output file contains Intel syntax
if ! grep -q ".intel_syntax noprefix" "$output_file"; then
    echo "❌ The generated assembly file does not use Intel syntax."
    exit 1
fi

# Optional: Validate the assembly output format
grep -q ".globl main" "$output_file" && grep -q ".type main, @function" "$output_file"
if [ $? -ne 0 ]; then
    echo "❌ The assembly file '$output_file' does not contain valid function headers."
    exit 1
fi

# Final success message
echo "✅ All tests passed for 100-intel!"
exit 0
