#!/bin/bash
# Install Guidelines Script
# Adds Claude Code guidelines and tools to an existing project

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$TEMPLATE_ROOT/templates"
GUIDELINES_DIR="$TEMPLATE_ROOT/guidelines"

echo "📋 Installing Claude Code Guidelines to Existing Project"
echo "========================================================="
echo ""
echo "Current directory: $(pwd)"
echo ""

# Confirm with user
read -p "Install guidelines to current directory? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Installation cancelled"
    exit 1
fi

# Check if this is a git repository
if [ ! -d ".git" ]; then
    echo "⚠️  Warning: This doesn't appear to be a git repository"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Installation cancelled"
        exit 1
    fi
fi

# Copy core guidelines
echo ""
echo "📋 Copying core guidelines..."
cp "$GUIDELINES_DIR/CODING_GUIDELINES.md" .
cp "$GUIDELINES_DIR/DEVELOPER_GUIDELINES.md" .
cp "$GUIDELINES_DIR/SESSION_STARTUP.md" .
echo "   ✅ CODING_GUIDELINES.md"
echo "   ✅ DEVELOPER_GUIDELINES.md"
echo "   ✅ SESSION_STARTUP.md"

# Create CLAUDE.md from template if it doesn't exist
if [ ! -f "CLAUDE.md" ]; then
    echo ""
    echo "📝 Creating CLAUDE.md from template..."
    PROJECT_NAME=$(basename "$(pwd)")
    sed "s/\[PROJECT_NAME\]/$PROJECT_NAME/g; s|/path/to/your/project|$(pwd)|g" "$TEMPLATE_DIR/CLAUDE.md.template" > CLAUDE.md
    echo "   ✅ CLAUDE.md created"
    echo "   ⚠️  Please edit CLAUDE.md to add project-specific details"
else
    echo ""
    echo "⚠️  CLAUDE.md already exists, skipping..."
    echo "   You can manually review the template at: $TEMPLATE_DIR/CLAUDE.md.template"
fi

# Copy audit script
echo ""
echo "🔧 Setting up audit script..."
mkdir -p scripts
cp "$SCRIPT_DIR/dry_audit.sh" scripts/
chmod +x scripts/dry_audit.sh
echo "   ✅ scripts/dry_audit.sh"

# Create CHANGELOG.md if it doesn't exist
if [ ! -f "CHANGELOG.md" ]; then
    echo ""
    echo "📄 Creating CHANGELOG.md..."
    cp "$TEMPLATE_DIR/CHANGELOG.md.template" CHANGELOG.md
    echo "   ✅ CHANGELOG.md"
else
    echo ""
    echo "⚠️  CHANGELOG.md already exists, skipping..."
fi

# Offer to create .gitignore additions
echo ""
echo "🔒 Checking .gitignore..."
if [ -f ".gitignore" ]; then
    if ! grep -q "# Claude Code" .gitignore; then
        echo "   Adding Claude Code entries to existing .gitignore"
        cat >> .gitignore << 'EOF'

# Claude Code
.claude_code/
*.swp
*~
EOF
        echo "   ✅ Updated .gitignore"
    else
        echo "   ✅ .gitignore already has Claude Code entries"
    fi
else
    echo "   Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Claude Code
.claude_code/
*.swp
*~

# Common ignores
.DS_Store
*.pyc
__pycache__/
.env
.venv/
node_modules/
EOF
    echo "   ✅ Created .gitignore"
fi

# Offer to set up pre-commit hooks
echo ""
read -p "Set up pre-commit hooks for DRY compliance? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f ".pre-commit-config.yaml" ]; then
        echo "   ⚠️  .pre-commit-config.yaml already exists"
        echo "   You can manually add hooks from: $TEMPLATE_DIR/.pre-commit-config.yaml.template"
    else
        echo "   Creating .pre-commit-config.yaml..."
        cp "$TEMPLATE_DIR/.pre-commit-config.yaml.template" .pre-commit-config.yaml
        echo "   ✅ .pre-commit-config.yaml created"
        echo "   Run 'pre-commit install' to activate hooks"
    fi
fi

# Create utils/ directory if it doesn't exist (Python projects)
echo ""
read -p "Create utils/ directory structure? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ ! -d "utils" ]; then
        mkdir -p utils
        touch utils/__init__.py
        echo "   ✅ Created utils/ directory with __init__.py"
    else
        echo "   ✅ utils/ directory already exists"
    fi
fi

# Summary
echo ""
echo "✅ Installation Complete!"
echo "========================"
echo ""
echo "📋 Files installed:"
echo "   • CODING_GUIDELINES.md"
echo "   • DEVELOPER_GUIDELINES.md"
echo "   • SESSION_STARTUP.md"
echo "   • scripts/dry_audit.sh"
if [ -f "CLAUDE.md" ]; then
    echo "   • CLAUDE.md"
fi
echo ""
echo "📋 Next steps:"
echo "1. Edit CLAUDE.md to add project-specific context"
echo "2. Run ./scripts/dry_audit.sh to check current state"
echo "3. Review CODING_GUIDELINES.md and DEVELOPER_GUIDELINES.md"
echo "4. Set up the session startup alias:"
echo "   echo 'alias cstart=\"claude \\\"Review SESSION_STARTUP.md and follow the instructions.\\\"\"' >> ~/.bashrc"
echo "5. Start a Claude Code session with: cstart"
echo ""
echo "🚀 Ready to use Claude Code with enforced guidelines!"
