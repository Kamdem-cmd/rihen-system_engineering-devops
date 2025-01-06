#!/bin/bash

# Test script for 3-name

echo "Testing 3-name script..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 3-name exists
if [ ! -f "0x00-hello_world/3-name" ]; then
    echo "❌ File 3-name is missing."
    exit 1
fi

# Check if the script is 2 lines long
line_count=$(wc -l < "0x00-hello_world/3-name")
if [ "$line_count" -ne 2 ]; then
    echo "❌ File 3-name must be exactly 2 lines long. Current: $line_count lines."
    exit 1
fi

# Check if the first line contains #!/bin/bash
first_line=$(head -n 1 "0x00-hello_world/3-name")
if [ "$first_line" != "#!/bin/bash" ]; then
    echo "❌ The first line of 3-name must be '#!/bin/bash'."
    exit 1
fi

# Prepare the test environment
echo "Preparing the test environment..."
mkdir -p tests/0x00-hello_world/outputs
cp tests/0x00-hello_world/sources/3-main.c tests/0x00-hello_world/outputs/main.c
export CFILE=tests/0x00-hello_world/outputs/main.c

# Run the student's script
chmod +x 0x00-hello_world/3-name
if ! ./0x00-hello_world/3-name; then
    echo "❌ The script './0x00-hello_world/3-name' failed to execute."
    exit 1
fi

# Move the generated executable to the outputs directory
executable_file="tests/0x00-hello_world/outputs/cisfun"
if [ -f "cisfun" ]; then
    mv cisfun "$executable_file"
fi

# Check if the executable named cisfun is generated
if [ ! -f "$executable_file" ]; then
    echo "❌ The script did not generate an executable named 'cisfun'."
    exit 1
fi

# Validate the executable by running it
if ! "$executable_file"; then
    echo "❌ The executable 'cisfun' did not run successfully."
    exit 1
fi

# Optional: Check the output (if specific output is expected)
output=$("$executable_file")
expected_output=""
if [ "$output" != "$expected_output" ]; then
    echo "❌ The output of the executable 'cisfun' is incorrect."
    echo "Expected: '$expected_output'"
    echo "Got: '$output'"
    exit 1
fi

# Final success message
echo "✅ All tests passed for 3-name!"
exit 0
