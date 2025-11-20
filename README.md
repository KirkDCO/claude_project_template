# Claude Code Project Template

**🎯 Purpose**: A complete starter template for new projects with built-in code quality guidelines and AI collaboration best practices.

## **🚀 Quick Start**

### **Recommended: Install Template Globally**
```bash
# Clone this template to a standard location
git clone <repo-url> ~/.local/share/claude-templates

# Or copy to your preferred location
cp -r claude_project_template ~/.local/share/claude-templates
```

### **For New Projects:**
```bash
# Create new project from template (run from anywhere)
~/.local/share/claude-templates/scripts/new_project.sh my-project python

# Project types: python, web, data_science, cli_tool

# Or add to your PATH for easier access
echo 'export PATH="$HOME/.local/share/claude-templates/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Then simply:
new_project.sh my-project python
```

### **For Existing Projects:**
```bash
# Navigate to your existing project
cd /path/to/your/project

# Run the installation script
~/.local/share/claude-templates/scripts/install_guidelines.sh

# Follow the interactive prompts to:
# - Copy core guidelines
# - Set up audit script
# - Create CLAUDE.md from template
# - Configure pre-commit hooks (optional)
```

## **📁 Repository Structure**

```
claude_project_template/
├── README.md                    # This file - usage instructions
├── CHANGELOG.md                 # Template repository changes
├── LICENSE                      # Template license
│
├── guidelines/                  # Core files copied to every project
│   ├── CODING_GUIDELINES.md        # Universal architecture principles
│   ├── DEVELOPER_GUIDELINES.md     # Human workflow patterns
│   └── SESSION_STARTUP.md          # AI session startup protocol
│
├── templates/                   # Customizable templates
│   ├── CLAUDE.md.template          # Project context template
│   ├── README.md.template          # Project README template
│   ├── CHANGELOG.md.template       # Project changelog template
│   └── .pre-commit-config.yaml.template
│
└── scripts/                     # Template management scripts
    ├── dry_audit.sh                # DRY compliance checker (copied to projects)
    ├── new_project.sh              # Create new project from template
    └── install_guidelines.sh       # Add guidelines to existing project
```

## **📦 What Gets Installed in Your Project**

When you create a new project or add guidelines to an existing one:

### **Core Guidelines (copied from `guidelines/`):**
- **`CODING_GUIDELINES.md`** - Universal architecture principles (DRY, performance, security)
- **`DEVELOPER_GUIDELINES.md`** - Human workflow and AI collaboration patterns
- **`SESSION_STARTUP.md`** - Session startup protocol for AI assistants

### **Generated from Templates:**
- **`CLAUDE.md`** - Project-specific context (from template, customized with project name)
- **`CHANGELOG.md`** - Project changelog (from template)
- **`.pre-commit-config.yaml`** - Pre-commit hooks (optional, from template)

### **Scripts and Tools:**
- **`scripts/dry_audit.sh`** - Automated code quality and DRY compliance checking
- **`.gitignore`** - Common ignore patterns (created or updated)

### **Project Structures (based on type):**
- **Python**: `utils/`, `<project_name>/`, `tests/`, `docs/`, `scripts/`
- **Web**: `src/utils/`, `src/components/`, `src/services/`, `tests/`, `docs/`, `scripts/`
- **Data Science**: `utils/`, `data/`, `notebooks/`, `models/`, `tests/`, `docs/`, `scripts/`
- **CLI Tools**: `utils/`, `cli/`, `commands/`, `config/`, `tests/`, `docs/`, `scripts/`

## **✅ Benefits**

### **Immediate Quality Improvements:**
- ✅ No duplicate function implementations
- ✅ Consistent utils-first architecture
- ✅ Performance-optimized algorithms (O(n²) with sampling)
- ✅ Automated violation detection
- ✅ Session-to-session consistency

### **AI Collaboration:**
- ✅ Claude Code automatically follows project patterns
- ✅ Built-in session startup checklist for AI assistants
- ✅ Guidelines prevent common AI collaboration pitfalls
- ✅ Clear communication patterns for complex requests

### **Developer Experience:**
- ✅ Personal workflow guidelines
- ✅ Quality control habits
- ✅ Emergency procedures for technical debt
- ✅ Project evolution strategies

## **🔧 Usage Patterns**

### **Starting a Claude Code Session:**
**CRITICAL**: Claude does NOT automatically read guidelines! Use the session startup protocol:

**Option 1 - Recommended Alias:**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias cstart='claude "Review SESSION_STARTUP.md and follow the instructions."'

# Then start sessions with:
cstart
```

**Option 2 - Manual Command:**
```bash
claude "Review SESSION_STARTUP.md and follow the instructions."
```

### **Human Developer Workflow:**
1. Use `cstart` alias (or manual command) to start every Claude session
2. Review `DEVELOPER_GUIDELINES.md` session startup ritual periodically
3. Run `./scripts/dry_audit.sh` to check current state before major work
4. Follow quality control habits after changes
5. Use effective AI collaboration patterns from guidelines

## **🎯 Success Metrics**

You know it's working when:
- New features naturally follow established patterns
- AI assistants rarely suggest duplicate implementations
- Code reviews focus on business logic, not architecture
- Performance is predictable and maintainable
- New team members can contribute quickly

## **📚 Advanced Usage**

### **Customizing for Your Team:**
1. Add team-specific patterns to `CODING_GUIDELINES.md`
2. Update `CLAUDE.md.template` with your common project patterns
3. Enhance `dry_audit.sh` with domain-specific checks
4. Add team conventions to `DEVELOPER_GUIDELINES.md`

### **Multi-Project Consistency:**
- Use the same template across all projects
- Share learnings by updating the template
- Regular architecture reviews using the audit tools
- Cross-project pattern sharing

## **🔄 Maintenance**

### **Keeping Guidelines Current:**
- Update guidelines as you learn what works
- Share improvements back to the template
- Regular review of audit script effectiveness
- Document new anti-patterns as they're discovered

### **Template Evolution:**
This template should evolve based on real-world usage. Consider:
- Adding new project types to the setup script
- Enhancing the audit script with new checks
- Documenting domain-specific patterns
- Adding language-specific guidelines

---

**💡 Remember**: The goal is to make good architecture decisions automatic, not effortful. These guidelines should feel helpful, not burdensome.

**🔄 Last Updated**: Auto-updated when template changes
**📧 Feedback**: Update this template based on what works in practice!
