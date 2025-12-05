#!/usr/bin/env bash

# Project-specific run script
# Compiles and runs this Java project

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Create target directory if it doesn't exist
mkdir -p target/classes

print_info "Cleaning previous build..."
rm -rf target/classes/*

print_info "Compiling Java files..."

# Find all Java source files
JAVA_FILES=$(find src/main/java -name "*.java" 2>/dev/null)

if [ -z "$JAVA_FILES" ]; then
    # Fallback to old structure
    JAVA_FILES=$(find src -name "*.java" 2>/dev/null)
fi

if [ -z "$JAVA_FILES" ]; then
    print_error "No Java source files found!"
    exit 1
fi

# Check for external JARs
CLASSPATH="target/classes"
if [ -d "lib" ] && ls lib/*.jar >/dev/null 2>&1; then
    print_info "Found external libraries in lib/"
    LIB_JARS=$(find lib -name "*.jar" | tr '\n' ':')
    CLASSPATH="$CLASSPATH:$LIB_JARS"
fi

# Compile
if javac -d target/classes -cp "$CLASSPATH" $JAVA_FILES; then
    print_success "Compilation successful!"
else
    print_error "Compilation failed!"
    exit 1
fi

echo ""
print_info "Available main classes:"

# Find classes with main method
MAIN_CLASSES=()
for file in $JAVA_FILES; do
    if grep -q "public static void main" "$file"; then
        PACKAGE=$(grep -E "^package " "$file" | sed 's/package //;s/;//' | tr -d ' ')
        CLASS=$(basename "$file" .java)
        if [ -n "$PACKAGE" ]; then
            FULL_CLASS="$PACKAGE.$CLASS"
        else
            FULL_CLASS="$CLASS"
        fi
        MAIN_CLASSES+=("$FULL_CLASS")
        echo "  - $FULL_CLASS"
    fi
done

if [ ${#MAIN_CLASSES[@]} -eq 0 ]; then
    print_error "No classes with main method found!"
    exit 1
fi

echo ""

# Run the main class
if [ ${#MAIN_CLASSES[@]} -eq 1 ]; then
    MAIN_CLASS="${MAIN_CLASSES[0]}"
    print_info "Running: $MAIN_CLASS"
else
    print_info "Multiple main classes found. Choose one:"
    select MAIN_CLASS in "${MAIN_CLASSES[@]}"; do
        if [ -n "$MAIN_CLASS" ]; then
            break
        else
            print_error "Invalid selection!"
        fi
    done
fi

echo ""
print_info "========== Program Output =========="
echo ""

java -cp "$CLASSPATH" "$MAIN_CLASS"

echo ""
print_info "===================================="
print_success "Program executed successfully!"
