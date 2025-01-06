#!/bin/bash

# Test script for 1-compiler

echo "Testing 1-compiler script..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 1-compiler exists
if [ ! -f "0x00-hello_world/1-compiler" ]; then
    echo "❌ File 1-compiler is missing."
    exit 1
fi

# Check if the script is 2 lines long
line_count=$(wc -l < "0x00-hello_world/1-compiler")
if [ "$line_count" -ne 2 ]; then
    echo "❌ File 1-compiler must be exactly 2 lines long. Current: $line_count lines."
    exit 1
fi

# Check if the first line contains #!/bin/bash
first_line=$(head -n 1 "0x00-hello_world/1-compiler")
if [ "$first_line" != "#!/bin/bash" ]; then
    echo "❌ The first line of 1-compiler must be '#!/bin/bash'."
    exit 1
fi

# Prepare the test environment
echo "Preparing the test environment..."
mkdir -p tests/0x00-hello_world/outputs
cp tests/0x00-hello_world/sources/1-main.c tests/0x00-hello_world/outputs/main.c
export CFILE=tests/0x00-hello_world/outputs/main.c

# Run the student's script
chmod +x 0x00-hello_world/1-compiler
if ! ./0x00-hello_world/1-compiler; then
    echo "❌ The script './0x00-hello_world/1-compiler' failed to execute."
    exit 1
fi

# Move the generated .o file to the outputs directory
output_file="tests/0x00-hello_world/outputs/$(basename "$CFILE" .c).o"
if [ -f "$(basename "$CFILE" .c).o" ]; then
    mv "$(basename "$CFILE" .c).o" "$output_file"
fi

# Check if the output file with the correct name is generated
if [ ! -f "$output_file" ]; then
    echo "❌ The script did not generate the output file $output_file."
    exit 1
fi

# Validate the output file
file "$output_file" | grep -q "ELF"
if [ $? -ne 0 ]; then
    echo "❌ The output file $output_file is not a valid object file."
    exit 1
fi

# Validate using gcc directly
expected_file="tests/0x00-hello_world/outputs/expected_main.o"
gcc -c "$CFILE" -o "$expected_file"
diff "$output_file" "$expected_file" > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ The generated object file does not match the expected output."
    exit 1
fi

# Final success message
echo "✅ All tests passed for 1-compiler!"
exit 0
