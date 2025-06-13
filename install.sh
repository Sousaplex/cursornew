#!/bin/bash

set -e

# Ensure the cursornew script exists in the current directory
if [ ! -f "cursornew" ]; then
    echo "Error: 'cursornew' script not found in the current directory."
    echo "Please run this installer from the same directory as the 'cursornew' script."
    exit 1
fi

if [ ! -d "templates" ]; then
    echo "Error: 'templates' directory not found in the current directory."
    echo "Please ensure the templates are present before installation."
    exit 1
fi

INSTALL_DIR="/usr/local/bin"
TARGET_EXECUTABLE="${INSTALL_DIR}/cursornew"
TEMPLATE_DEST_DIR="/usr/local/share/cursornew"

echo "This script will install the 'cursornew' command and its templates."

# Make the cursornew script executable
chmod +x cursornew

# Check if the installation directory exists and is in the PATH
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Installation directory ${INSTALL_DIR} does not exist."
    echo "Attempting to create it with sudo..."
    sudo mkdir -p "$INSTALL_DIR"
fi

if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
  echo "Warning: ${INSTALL_DIR} is not in your PATH. You might need to add it."
  echo 'You can do this by adding `export PATH="/usr/local/bin:$PATH"` to your ~/.zshrc or ~/.bash_profile'
fi

# Move the script using sudo if necessary
echo "Attempting to install 'cursornew' to ${TARGET_EXECUTABLE}"
if [ -w "$INSTALL_DIR" ]; then
    mv cursornew "$TARGET_EXECUTABLE"
else
    echo "Write permission denied. Using sudo to move the file."
    sudo mv cursornew "$TARGET_EXECUTABLE"
fi

# Install templates
echo "Installing templates to ${TEMPLATE_DEST_DIR}"
if [ -d "$TEMPLATE_DEST_DIR" ]; then
    echo "Template directory already exists. Removing old templates."
    sudo rm -rf "$TEMPLATE_DEST_DIR"
fi
sudo mkdir -p "$TEMPLATE_DEST_DIR"
sudo cp -r templates/* "$TEMPLATE_DEST_DIR/"


# Verify installation
if [ -f "$TARGET_EXECUTABLE" ] && [ -d "$TEMPLATE_DEST_DIR" ]; then
    echo ""
    echo "'cursornew' and its templates installed successfully!"
    echo "You can now use it by running: cursornew <project-directory>"
    echo "For example: cursornew my-awesome-project"
else
    echo "Installation failed. Please check permissions and paths."
    exit 1
fi 