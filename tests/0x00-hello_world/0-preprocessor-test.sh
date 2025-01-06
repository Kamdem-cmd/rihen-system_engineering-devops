#!/bin/bash

# Test script for 0-preprocessor

echo "Testing 0-preprocessor script..."

# Check if the file README.md exists
if [ ! -f "0x00-hello_world/README.md" ]; then
    echo "❌ File README.md is missing."
    exit 1
fi

# Check if the file 0-preprocessor exists
if [ ! -f "0x00-hello_world/0-preprocessor" ]; then
    echo "❌ File 0-preprocessor is missing."
    exit 1
fi

# Check if the script is 2 lines long
line_count=$(wc -l < "0x00-hello_world/0-preprocessor")
if [ "$line_count" -ne 2 ]; then
    echo "❌ File 0-preprocessor must be exactly 2 lines long. Current: $line_count lines."
    exit 1
fi

# Check if the first line contains #!/bin/bash
first_line=$(head -n 1 "0x00-hello_world/0-preprocessor")
if [ "$first_line" != "#!/bin/bash" ]; then
    echo "❌ The first line of 0-preprocessor must be '#!/bin/bash'."
    exit 1
fi

# Prepare the test environment
echo "Preparing the test environment..."
mkdir -p tests/0x00-hello_world/outputs
cp tests/0x00-hello_world/sources/0-main.c tests/0x00-hello_world/outputs/main.c
export CFILE=tests/0x00-hello_world/outputs/main.c

# Run the student's script
chmod +x 0x00-hello_world/0-preprocessor
if ! ./0x00-hello_world/0-preprocessor; then
    echo "❌ The script './0x00-hello_world/0-preprocessor' failed to execute."
    exit 1
fi

# Move the output file 'c' to the correct directory
mv c tests/0x00-hello_world/outputs/c

# Check if the output file 'c' is generated
if [ ! -f "tests/0x00-hello_world/outputs/c" ]; then
    echo "❌ The script did not generate the output file 'c'."
    exit 1
fi

# Validate the output using the preprocessor directly
gcc -E tests/0x00-hello_world/outputs/main.c -o tests/0x00-hello_world/outputs/expected_c
diff tests/0x00-hello_world/outputs/c tests/0x00-hello_world/outputs/expected_c > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ The output file 'c' does not match the expected preprocessed output."
    exit 1
fi

# Final success message
echo "✅ All tests passed for 0-preprocessor!"
exit 0
