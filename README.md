# cursornew

`cursornew` is a simple command-line tool to quickly scaffold a new project with a `.cursor` directory structure.

It creates:
- `.cursor/rules/` (with example rule)
- `.cursor/plans/` (with example plan)
- `.cursor/settings.json`
- `.cursor/.cursorignore`
- `.env.local`

After creating the files and directories, it will attempt to open the new project directory in Cursor.

## Installation

1.  Clone this repository to your local machine.
2.  Navigate into the cloned directory in your terminal.
3.  Run the installer script:
    ```bash
    ./install.sh
    ```
    The script will move the `cursornew` command to `/usr/local/bin`. It may ask for your password to do so (`sudo`).

## Usage

To create a new project in a new directory, run:

```bash
cursornew my-awesome-project
```

This will create a new directory named `my-awesome-project`, initialize the `.cursor` structure inside it, and open it with Cursor.

To initialize a project in the current directory, run:

```bash
cursornew .
```

## Prerequisites

- This script is designed for macOS and Linux environments.
- For the auto-open feature to work, you must have the `cursor` command-line tool installed and available in your system's PATH. 