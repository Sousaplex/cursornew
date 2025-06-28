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

# --- Auto-install 'cursor' command-line tool ---
if ! command -v cursor &> /dev/null; then
    echo "'cursor' command not found. Attempting to install it for you."
    
    CURSOR_APP_PATH="/Applications/Cursor.app"
    CURSOR_CLI_PATH="${CURSOR_APP_PATH}/Contents/Resources/app/bin/cursor"
    TARGET_LINK_PATH="/usr/local/bin/cursor"

    if [ -d "$CURSOR_APP_PATH" ]; then
        if [ -f "$CURSOR_CLI_PATH" ]; then
            echo "Found Cursor.app. Creating symlink for 'cursor' command..."
            if [ -L "$TARGET_LINK_PATH" ]; then
                echo "Removing existing broken symlink at ${TARGET_LINK_PATH}"
                sudo rm "$TARGET_LINK_PATH"
            fi
            sudo ln -s "$CURSOR_CLI_PATH" "$TARGET_LINK_PATH"
            echo "'cursor' command installed successfully."
        else
            echo "Error: Found Cursor.app, but the command-line executable was not at the expected path."
            echo "Please try installing the 'cursor' command from within the Cursor app."
            echo "(Cmd+Shift+P -> 'Install 'cursor' command in PATH')"
        fi
    else
        echo "Warning: Cursor application not found at ${CURSOR_APP_PATH}."
        echo "Could not auto-install the 'cursor' command."
        echo "Please install it from within the app to enable the project auto-open feature."
    fi
    echo # Newline for readability
else
    echo "'cursor' command is already installed. Skipping."
    echo # Newline for readability
fi
# --- End auto-install ---

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
    cp cursornew "$TARGET_EXECUTABLE"
else
    echo "Write permission denied. Using sudo to copy the file."
    sudo cp cursornew "$TARGET_EXECUTABLE"
fi

# Install templates
echo "Installing templates to ${TEMPLATE_DEST_DIR}"
if [ -d "$TEMPLATE_DEST_DIR" ]; then
    echo "Template directory already exists. Removing old templates."
    sudo rm -rf "$TEMPLATE_DEST_DIR"
fi
sudo mkdir -p "$TEMPLATE_DEST_DIR"
sudo cp -r templates/* "$TEMPLATE_DEST_DIR/"

# Set read permissions for all users on the copied templates
sudo chmod -R a+r "$TEMPLATE_DEST_DIR"


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