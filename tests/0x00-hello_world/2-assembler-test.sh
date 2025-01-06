#!/bin/bash

# Test script for 2-assembler

echo "Testing 2-assembler script..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 2-assembler exists
if [ ! -f "0x00-hello_world/2-assembler" ]; then
    echo "❌ File 2-assembler is missing."
    exit 1
fi

# Check if the script is 2 lines long
line_count=$(wc -l < "0x00-hello_world/2-assembler")
if [ "$line_count" -ne 2 ]; then
    echo "❌ File 2-assembler must be exactly 2 lines long. Current: $line_count lines."
    exit 1
fi

# Check if the first line contains #!/bin/bash
first_line=$(head -n 1 "0x00-hello_world/2-assembler")
if [ "$first_line" != "#!/bin/bash" ]; then
    echo "❌ The first line of 2-assembler must be '#!/bin/bash'."
    exit 1
fi

# Prepare the test environment
echo "Preparing the test environment..."
mkdir -p tests/0x00-hello_world/outputs
cp tests/0x00-hello_world/sources/2-main.c tests/0x00-hello_world/outputs/main.c
export CFILE=tests/0x00-hello_world/outputs/main.c

# Run the student's script
chmod +x 0x00-hello_world/2-assembler
if ! ./0x00-hello_world/2-assembler; then
    echo "❌ The script './0x00-hello_world/2-assembler' failed to execute."
    exit 1
fi

# Move the generated .s file to the outputs directory
output_file="tests/0x00-hello_world/outputs/$(basename "$CFILE" .c).s"
if [ -f "$(basename "$CFILE" .c).s" ]; then
    mv "$(basename "$CFILE" .c).s" "$output_file"
fi

# Check if the output file with the correct name is generated
if [ ! -f "$output_file" ]; then
    echo "❌ The script did not generate the output file $output_file."
    exit 1
fi

# Validate the assembly output by checking its structure
grep -q ".text" "$output_file" && grep -q ".globl" "$output_file"
if [ $? -ne 0 ]; then
    echo "❌ The output file $output_file does not contain valid assembly code."
    exit 1
fi

# Validate using gcc directly
expected_file="tests/0x00-hello_world/outputs/expected_main.s"
gcc -S "$CFILE" -o "$expected_file" -masm=intel
diff "$output_file" "$expected_file" > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ The generated assembly file does not match the expected output."
    exit 1
fi

# Final success message
echo "✅ All tests passed for 2-assembler!"
exit 0
