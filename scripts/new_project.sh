#!/bin/bash
# New Project Setup Script
# Sets up a new project with proper guidelines and structure

if [ $# -eq 0 ]; then
    echo "Usage: $0 <project_name> [project_type]"
    echo "Project types: python, web, data_science, cli_tool"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_TYPE=${2:-python}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$TEMPLATE_ROOT/templates"
GUIDELINES_DIR="$TEMPLATE_ROOT/guidelines"

echo "🚀 Setting up new project: $PROJECT_NAME"
echo "📁 Project type: $PROJECT_TYPE"
echo ""

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Copy universal guidelines
echo "📋 Copying coding guidelines..."
mkdir -p guidelines
cp "$GUIDELINES_DIR/CODING_GUIDELINES.md" guidelines/
cp "$GUIDELINES_DIR/DEVELOPER_GUIDELINES.md" guidelines/
cp "$GUIDELINES_DIR/SESSION_STARTUP.md" guidelines/

# Create CLAUDE.md from template
echo "📝 Creating CLAUDE.md..."
sed "s/\[PROJECT_NAME\]/$PROJECT_NAME/g; s|/path/to/your/project|$(pwd)|g" "$TEMPLATE_DIR/CLAUDE.md.template" > CLAUDE.md

# Create basic project structure based on type
echo "🏗️ Creating project structure..."
case $PROJECT_TYPE in
    python)
        mkdir -p tests docs scripts specifications
        mkdir -p "$PROJECT_NAME"/{utils,core,config,cli}
        touch "$PROJECT_NAME"/__init__.py
        touch "$PROJECT_NAME/utils/__init__.py"
        echo "# $PROJECT_NAME" > README.md
        ;;
    web)
        mkdir -p src/{utils,components,services,styles} tests docs scripts specifications
        touch src/utils/index.js
        echo "# $PROJECT_NAME" > README.md
        ;;
    data_science)
        mkdir -p data notebooks models tests docs scripts specifications
        mkdir -p "$PROJECT_NAME"/{utils,analysis}
        touch "$PROJECT_NAME"/__init__.py
        touch "$PROJECT_NAME/utils/__init__.py"
        echo "# $PROJECT_NAME" > README.md
        ;;
    cli_tool)
        mkdir -p tests docs scripts specifications
        mkdir -p "$PROJECT_NAME"/{utils,cli,commands,config}
        touch "$PROJECT_NAME"/__init__.py
        touch "$PROJECT_NAME/utils/__init__.py"
        echo "# $PROJECT_NAME" > README.md
        ;;
    *)
        echo "⚠️ Unknown project type, creating basic structure"
        mkdir -p tests docs scripts specifications
        mkdir -p "$PROJECT_NAME"/utils
        touch "$PROJECT_NAME"/__init__.py
        touch "$PROJECT_NAME/utils/__init__.py"
        echo "# $PROJECT_NAME" > README.md
        ;;
esac

# Copy and adapt audit script
echo "🔧 Setting up audit script..."
mkdir -p scripts
cp "$SCRIPT_DIR/dry_audit.sh" scripts/
chmod +x scripts/dry_audit.sh

# Create basic files
echo "📄 Creating basic files..."
echo "# Changelog\n\nAll notable changes to this project will be documented in this file.\n" > CHANGELOG.md
echo ".DS_Store\n*.pyc\n__pycache__/\n.env\n.venv/\nnode_modules/\n" > .gitignore

# Initialize git
echo "🔄 Initializing git repository..."
git init
git add .
git commit -m "feat: initial project setup with coding guidelines"

# Create pre-commit config
echo "⚙️ Setting up pre-commit hooks..."
cat > .pre-commit-config.yaml << EOF
# Pre-commit hooks for DRY compliance and code quality
repos:
  - repo: local
    hooks:
      - id: dry-audit
        name: DRY Compliance Audit
        entry: scripts/dry_audit.sh
        language: script
        pass_filenames: false
        always_run: true

      - id: coding-guidelines-check
        name: Check guidelines/CODING_GUIDELINES.md exists
        entry: sh -c 'test -f guidelines/CODING_GUIDELINES.md || (echo "❌ guidelines/CODING_GUIDELINES.md missing!" && exit 1)'
        language: system
        pass_filenames: false
        always_run: true
EOF

# Add language-specific hooks
case $PROJECT_TYPE in
    python)
        cat >> .pre-commit-config.yaml << EOF

  - repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
      - id: black
        language_version: python3

  - repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8
        args: [--max-line-length=100, --ignore=E203,W503]
EOF
        ;;
    web)
        cat >> .pre-commit-config.yaml << EOF

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v3.0.0
    hooks:
      - id: prettier
        types_or: [javascript, jsx, ts, tsx, json, css, scss, html]

  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.44.0
    hooks:
      - id: eslint
        files: \.(js|jsx|ts|tsx)$
EOF
        ;;
esac

echo ""
echo "✅ Project setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. Edit CLAUDE.md to add project-specific details"
echo "3. Add project specifications to specifications/ directory"
echo "   (See specifications/PROJECT_SPECIFICATIONS.md in template repo for examples)"
echo "4. Review guidelines/CODING_GUIDELINES.md and guidelines/DEVELOPER_GUIDELINES.md"
echo "5. Set up the session startup alias:"
echo "   echo \"alias cstart='claude \\\"Review guidelines/SESSION_STARTUP.md and follow the instructions.\\\"'\" >> ~/.bashrc"
echo "6. Run ./scripts/dry_audit.sh to verify setup"
echo "7. Start developing with utils-first approach!"
echo ""
echo "🚀 To start a Claude Code session: use 'cstart' alias or:"
echo "   claude \"Review guidelines/SESSION_STARTUP.md and follow the instructions.\""