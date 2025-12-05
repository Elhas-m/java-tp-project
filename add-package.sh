#!/bin/bash

# Project-specific add-package script
# Adds new packages/classes to this project

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
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Get package name
read -p "Enter new package name (e.g., com.example.utils): " PACKAGE_NAME

if [ -z "$PACKAGE_NAME" ]; then
    print_error "Package name cannot be empty!"
    exit 1
fi

# Validate package name format
if ! [[ "$PACKAGE_NAME" =~ ^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$ ]]; then
    print_warning "Package name should follow Java naming conventions (lowercase, dot-separated)"
    read -p "Continue anyway? (y/n): " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        print_info "Aborting..."
        exit 0
    fi
fi

# Determine package path
if [ -d "src/main/java" ]; then
    PACKAGE_PATH="src/main/java/${PACKAGE_NAME//./\/}"
else
    PACKAGE_PATH="src/${PACKAGE_NAME//./\/}"
fi

if [ -d "$PACKAGE_PATH" ]; then
    print_warning "Package directory already exists: $PACKAGE_PATH"
    read -p "Do you want to add a new class to this package? (y/n): " ADD_CLASS
    if [[ ! "$ADD_CLASS" =~ ^[Yy]$ ]]; then
        print_info "Aborting..."
        exit 0
    fi
else
    print_info "Creating package directory: $PACKAGE_PATH"
    mkdir -p "$PACKAGE_PATH"
fi

# Ask for class name
read -p "Enter class name (leave empty to skip): " CLASS_NAME

if [ -z "$CLASS_NAME" ]; then
    print_success "Package directory created: $PACKAGE_PATH"
    print_info "You can now create classes manually in this directory"
    exit 0
fi

# Validate class name
if ! [[ "$CLASS_NAME" =~ ^[A-Z][a-zA-Z0-9_]*$ ]]; then
    print_warning "Class name should start with an uppercase letter"
    read -p "Continue anyway? (y/n): " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        print_info "Aborting..."
        exit 0
    fi
fi

CLASS_FILE="$PACKAGE_PATH/$CLASS_NAME.java"

if [ -f "$CLASS_FILE" ]; then
    print_error "Class file already exists: $CLASS_FILE"
    exit 1
fi

# Ask for class type
echo ""
print_info "Select class type:"
echo "  1) Regular class"
echo "  2) Class with main method"
echo "  3) Interface"
echo "  4) Abstract class"
echo "  5) Enum"
read -p "Enter choice (1-5) [1]: " CLASS_TYPE
CLASS_TYPE=${CLASS_TYPE:-1}

print_info "Creating $CLASS_FILE..."

case $CLASS_TYPE in
    1)
        cat > "$CLASS_FILE" << CLASSEOF
package $PACKAGE_NAME;

/**
 * $CLASS_NAME
 */
public class $CLASS_NAME {
    
    public $CLASS_NAME() {
        // Constructor
    }
    
}
CLASSEOF
        ;;
    2)
        cat > "$CLASS_FILE" << CLASSEOF
package $PACKAGE_NAME;

/**
 * $CLASS_NAME
 */
public class $CLASS_NAME {
    
    public static void main(String[] args) {
        System.out.println("Running $CLASS_NAME");
    }
    
}
CLASSEOF
        ;;
    3)
        cat > "$CLASS_FILE" << CLASSEOF
package $PACKAGE_NAME;

/**
 * $CLASS_NAME interface
 */
public interface $CLASS_NAME {
    
    // Define interface methods here
    
}
CLASSEOF
        ;;
    4)
        cat > "$CLASS_FILE" << CLASSEOF
package $PACKAGE_NAME;

/**
 * $CLASS_NAME abstract class
 */
public abstract class $CLASS_NAME {
    
    public $CLASS_NAME() {
        // Constructor
    }
    
    // Define abstract methods here
    
}
CLASSEOF
        ;;
    5)
        cat > "$CLASS_FILE" << CLASSEOF
package $PACKAGE_NAME;

/**
 * $CLASS_NAME enum
 */
public enum $CLASS_NAME {
    // Define enum constants here
}
CLASSEOF
        ;;
    *)
        print_error "Invalid choice!"
        exit 1
        ;;
esac

print_success "Class created: $CLASS_FILE"
echo ""
print_info "You can now edit it with: nvim $CLASS_FILE"
print_info "Compile and run with: ./run.sh"
