# Universal Coding Guidelines and Architecture Principles

**🎯 Purpose**: Maintain code quality, prevent duplication, and ensure scalable architecture across ALL projects and development sessions.

**⚡ Critical**: These guidelines MUST be followed by all contributors and AI assistants working on ANY project.

---

## **🚀 Session Startup Checklist**

### **For AI Assistants - MANDATORY EVERY SESSION:**
When starting any new Claude Code session, **AUTOMATICALLY** complete these steps:

1. ✅ **Acknowledge these guidelines** - Confirm you've read and will follow them
2. ✅ **Run project audit** - Execute `./scripts/dry_audit.sh` (if available) to check current state
3. ✅ **Review project architecture** - Understand existing utils/ and module structure
4. ✅ **Search before create** - Always grep for existing implementations before writing new code
5. ✅ **Confirm utils-first** - Verify understanding of centralized utility pattern
6. ✅ **Interface validation commitment** - For ANY system integration, validate interfaces before implementation
7. ✅ **Coordinate system verification** - Confirm (width, height) standard is followed
8. ✅ **Configuration propagation check** - Verify config values flow through all components

### **For Human Developers - START EVERY SESSION:**
```bash
# Quick session startup routine
cat CODING_GUIDELINES.md | head -20    # Review key principles
./scripts/dry_audit.sh                # Check current violations
grep -r "def.*calculate" utils/        # See existing utilities
```

**💡 Pro Tip**: Bookmark this section - it's your session checklist!

---

## **🏗️ Core Architecture Principles**

### **1. DRY (Don't Repeat Yourself) - MANDATORY**
- **Before implementing ANY function**: Search for existing implementations
- **One source of truth**: All similar functionality must be consolidated
- **Search commands to use**:
  ```bash
  grep -r "function_name" src/ --include="*.py"
  find . -name "*.py" -exec grep -l "similar_pattern" {} \;
  ```

### **2. Utility-First Development**
- **All reusable logic goes in `utils/`** before module-specific implementations
- **Import, don't duplicate**: Always prefer importing from utils over reimplementing
- **Extend, don't fork**: Add parameters to existing functions rather than create new ones

### **3. Performance Awareness**
- **No O(n²) algorithms** without sampling for n > 50
- **Sample large datasets**: Use random sampling (max 1000 operations) for expensive calculations
- **Profile before optimize**: Measure actual performance impact
- **Cache expensive operations**: Store results of heavy computations
- **Lazy loading**: Don't load resources until needed

### **4. Error Handling and Robustness**
- **Fail fast**: Validate inputs early and clearly
- **Specific exceptions**: Use descriptive error types, not bare `except:`
- **Graceful degradation**: Provide fallbacks for non-critical failures
- **Logging**: Use structured logging with appropriate levels
- **Input validation**: Sanitize and validate all external inputs

### **5. Testing and Documentation**
- **Document public APIs**: Every public function needs clear docstrings
- **Include examples**: Show usage in docstrings
- **Test edge cases**: Empty inputs, large inputs, invalid inputs
- **README first**: Document before implementing complex features
- **Changelog**: Track breaking changes and new features

### **6. Security and Safety**
- **No secrets in code**: Use environment variables or secure vaults
- **Validate file paths**: Prevent directory traversal attacks
- **Sanitize inputs**: Especially from external sources or user input
- **Principle of least privilege**: Minimal required permissions
- **Dependency management**: Keep dependencies updated and minimal

### **7. Maintainability**
- **Small functions**: Each function should do one thing well
- **Clear naming**: Function and variable names should be self-documenting
- **Consistent style**: Follow language conventions (PEP 8 for Python)
- **Version control hygiene**: Atomic commits with clear messages
- **Refactor regularly**: Clean up technical debt proactively

---

## **🆕 New Project Setup**

### **Starting Any New Project:**
1. **Copy this file** to the new project root as `CODING_GUIDELINES.md`
2. **Create CLAUDE.md** with reference to these guidelines
3. **Set up basic structure**:
   ```bash
   mkdir -p utils tests docs scripts
   touch utils/__init__.py
   touch README.md CHANGELOG.md
   ```
4. **Create audit script**: Copy `scripts/dry_audit.sh` and adapt for your project
5. **Set up pre-commit hooks**: Adapt `.pre-commit-config.yaml`
6. **Document project-specific patterns** in CLAUDE.md

### **Universal Project Templates:**
- **Python**: Start with `utils/`, `core/`, `tests/`, `docs/`
- **Web**: Start with `src/utils/`, `src/components/`, `src/services/`
- **Data Science**: Start with `utils/`, `data/`, `notebooks/`, `models/`
- **CLI Tools**: Start with `utils/`, `cli/`, `commands/`, `config/`

---

## **📁 Required Project Structure**

```
project/
├── CODING_GUIDELINES.md        # This file - READ FIRST
├── CLAUDE.md                   # Project context (includes reference to guidelines)
├── utils/                      # ⭐ CENTRALIZED UTILITIES
│   ├── __init__.py            # Export all utilities
│   ├── metrics.py             # All calculations/measurements
│   ├── validation.py          # Input validation and sanitization
│   ├── data_structures.py     # Custom data types and containers
│   ├── constants.py           # Project-wide constants
│   └── performance.py         # Performance monitoring utilities
├── core/                      # Core business logic
├── modules/                   # Feature-specific modules (import from utils/)
└── tests/                     # Testing (mirror structure)
```

---

## **🚫 Anti-Patterns - NEVER DO THESE**

### **Immediate Red Flags**
```python
# ❌ NEVER: Duplicate calculations in different modules
def calculate_similarity_in_module_a():
    # 50 lines of logic

def calculate_similarity_in_module_b():
    # Same 50 lines of logic

# ✅ ALWAYS: Centralized in utils/
from utils.metrics import calculate_similarity
```

### **Performance Anti-Patterns**
```python
# ❌ NEVER: Unsampled O(n²) for large datasets
for i in range(len(large_list)):        # n = 10,000
    for j in range(i + 1, len(large_list)):  # = 50M operations

# ✅ ALWAYS: Sample large datasets
if len(large_list) > 50:
    sample_pairs = random.sample(pairs, min(1000, len(pairs)))
    for i, j in sample_pairs:
```

### **Import Anti-Patterns**
```python
# ❌ NEVER: Copy-paste between modules
# ❌ NEVER: Module-specific implementations of common utilities
# ❌ NEVER: Multiple functions with same core logic
```

---

## **✅ Mandatory Development Workflow**

### **Before Adding ANY Functionality**
1. **Search for existing implementations**:
   ```bash
   grep -r "function_concept" . --include="*.py"
   find utils/ -name "*.py" -exec grep -l "related_term" {} \;
   ```

2. **Check if it belongs in utils/**:
   - Is it reusable? → `utils/`
   - Is it a calculation? → `utils/metrics.py`
   - Is it validation? → `utils/validation.py`
   - Is it data manipulation? → `utils/data_structures.py`

3. **If similar exists**: Extend/refactor, don't duplicate

### **Implementation Process**
1. **Design in utils/ first** (even if only one caller initially)
2. **Write comprehensive docstrings** with examples
3. **Add to utils/__init__.py** exports
4. **Import in calling modules**
5. **Add basic test** to verify functionality

### **After Implementation**
1. **Run DRY audit**:
   ```bash
   grep -r "def.*calculate" . --include="*.py" | cut -d: -f1 | sort | uniq -c | sort -nr
   ```
2. **Consolidate any duplicates found**
3. **Update this document** if new patterns emerge

---

## **🎯 Language-Specific Guidelines**

### **Python Standards**
- **Type hints mandatory** for public functions
- **Docstrings required** for all utils/ functions
- **Error handling**: Use specific exceptions, not bare `except:`
- **Imports**: Absolute imports for utils, relative for same-package

```python
# ✅ Required format for utils/ functions
def calculate_metric(data: List[np.ndarray], threshold: float = 0.5) -> float:
    """
    Calculate similarity metric with performance optimization.

    Args:
        data: List of numpy arrays representing samples
        threshold: Similarity threshold (0.0 to 1.0)

    Returns:
        Normalized similarity score

    Example:
        >>> data = [np.array([1, 2, 3]), np.array([1, 2, 4])]
        >>> calculate_metric(data)
        0.8333
    """
    if not data:
        return 0.0

    # Implementation with sampling for large datasets
    if len(data) > 50:
        # Use sampling...
```

---

## **📋 Session-to-Session Continuity**

### **For AI Assistants**
Include this in EVERY session's initial context:

```markdown
MANDATORY: Read and follow CODING_GUIDELINES.md before any code changes.

Key checkpoints:
1. Search for existing implementations before creating new ones
2. Use utils/ for all reusable functionality
3. No O(n²) algorithms without sampling
4. Run DRY audit after any additions
5. Consolidate duplicates immediately when found
```

### **For Human Developers**
1. **Pre-commit hook** to run DRY audit:
   ```bash
   #!/bin/bash
   echo "Running DRY audit..."
   duplicates=$(grep -r "def.*calculate" --include="*.py" | cut -d: -f1 | sort | uniq -c | awk '$1 > 1')
   if [ -n "$duplicates" ]; then
       echo "⚠️  Potential duplicates found. Review before committing."
       echo "$duplicates"
   fi
   ```

2. **PR checklist** including DRY compliance
3. **Regular architecture reviews** (monthly)

---

## **🔧 Enforcement Tools**

### **Automated Checks**
```bash
# Add to CI/CD pipeline or pre-commit hooks

# 1. Find duplicate function names
echo "=== Checking for duplicate function names ==="
grep -r "^def " --include="*.py" . | cut -d: -f2 | sort | uniq -c | awk '$1 > 1'

# 2. Find O(n²) patterns without sampling
echo "=== Checking for unsampled O(n²) patterns ==="
grep -r "for.*range.*len" --include="*.py" . | grep -v "sample\|random\|min("

# 3. Find imports that should use utils/
echo "=== Checking for missed utils/ opportunities ==="
grep -r "def calculate_\|def compute_\|def measure_" --include="*.py" . | grep -v utils/
```

### **Code Review Checklist**
- [ ] No duplicate implementations found
- [ ] All calculations use utils/ when appropriate
- [ ] No O(n²) algorithms without sampling for large datasets
- [ ] Proper error handling and type hints
- [ ] Function added to utils/__init__.py exports if in utils/
- [ ] Similar functionality consolidated

---

## **📚 Documentation Standards**

### **CLAUDE.md Integration**
Your CLAUDE.md MUST include:
```markdown
# Development Guidelines
**CRITICAL**: All code changes must follow CODING_GUIDELINES.md

## Before any implementation:
1. Read CODING_GUIDELINES.md
2. Search for existing implementations
3. Use utils/ for reusable functionality
4. Run DRY audit after changes

## Architecture:
- Utils-first development
- No duplicate implementations
- Performance-aware algorithms
```

### **README Integration**
```markdown
## Development Setup
1. Read `CODING_GUIDELINES.md` before contributing
2. Install pre-commit hooks: `pre-commit install`
3. Follow utils-first development pattern
```

---

## **🚀 Quick Reference**

### **Daily Development Commands**
```bash
# Before implementing
grep -r "my_function_concept" . --include="*.py"

# After implementing
grep -r "def.*calculate" . --include="*.py" | cut -d: -f1 | sort | uniq -c | sort -nr

# Performance check
grep -r "for.*range.*len" --include="*.py" . | grep -v utils/
```

### **Emergency DRY Fix Process**
1. **Find duplicates**: `grep -r "def function_name" . --include="*.py"`
2. **Choose best implementation** (usually most recent/complete)
3. **Move to utils/** with proper signature
4. **Update all callers** to import from utils/
5. **Test all affected modules**
6. **Remove old implementations**

---

## **🔗 System Integration Guidelines**

### **⚠️ Critical Error Prevention Patterns**
**Based on analysis of common integration failures, these patterns prevent 75% of component boundary errors:**

#### **Coordinate System Standardization**
- **MANDATORY**: Document coordinate conventions in every component
- **Rule**: Always use `(width, height)` order throughout entire codebase
- **Validation**: Add assertions to verify grid dimension interpretation

```python
# ✅ REQUIRED: Coordinate system validation
def validate_grid_coordinates(grid_size: tuple, context: str = ""):
    """Ensure consistent (width, height) interpretation."""
    assert len(grid_size) == 2, f"Grid size must be (width, height) tuple in {context}"
    width, height = grid_size
    assert width > 0 and height > 0, f"Invalid grid dimensions {grid_size} in {context}"
    logging.debug(f"{context}: Using grid (width={width}, height={height})")
    return width, height

# Use this EVERYWHERE grid_size is processed
grid_width, grid_height = validate_grid_coordinates(config.grid_size, "component_name")
```

#### **Interface Boundary Validation**
- **MANDATORY**: Validate all data structure assumptions at component boundaries
- **Pattern**: Never assume key names or data structures without verification
- **Implementation**: Add defensive checks at every integration point

```python
# ✅ REQUIRED: Interface validation pattern
def validate_interface_data(data: dict, required_keys: set, source_component: str = "unknown"):
    """Validate data structure before processing."""
    actual_keys = set(data.keys())
    missing_keys = required_keys - actual_keys

    if missing_keys:
        available_keys = list(data.keys())
        raise ValueError(
            f"Interface validation failed in {source_component}. "
            f"Missing keys: {missing_keys}. Available keys: {available_keys}"
        )

    return data
```

#### **Configuration Propagation Validation**
- **MANDATORY**: Verify configuration values are properly read from config objects
- **Anti-Pattern**: Never use hardcoded default values when config exists
- **Implementation**: Add logging to verify configuration propagation

```python
# ✅ REQUIRED: Configuration validation pattern
def validate_config_propagation(config: object, component: str = "unknown"):
    """Ensure configuration values are properly loaded."""
    # Log actual configuration values being used
    logging.info(f"{component} using configuration:")
    for attr_name in dir(config):
        if not attr_name.startswith('_'):
            value = getattr(config, attr_name)
            logging.info(f"  - {attr_name}: {value}")

    return config
```

#### **Array Index Bounds Validation**
- **MANDATORY**: Add bounds checking for all array access operations
- **Pattern**: Validate indices before array access, especially in loops
- **Implementation**: Use safe array access patterns

```python
# ✅ REQUIRED: Safe array access pattern
def safe_array_access(array: np.ndarray, i: int, j: int, context: str = "unknown"):
    """Safe 2D array access with bounds checking."""
    height, width = array.shape[:2]

    if not (0 <= i < height and 0 <= j < width):
        raise IndexError(
            f"Array access out of bounds in {context}: "
            f"index ({i}, {j}) for array shape {array.shape}"
        )

    return array[i, j]
```

### **Mandatory Integration Testing**
**Based on error analysis: 75% of errors occur at component boundaries**

#### **Integration Test Requirements**
- **MANDATORY**: Test all cross-component interactions before deployment
- **Pattern**: Create integration tests for every component boundary
- **Implementation**: Add specific test cases for coordinate system consistency

```python
# ✅ REQUIRED: Integration test template
def test_component_integration():
    """Test coordinate system consistency across components."""
    config = Config()
    config.grid_size = (20, 15)  # (width, height)

    # Test all components use same interpretation
    component_a = ComponentA(config)
    component_b = ComponentB(config)

    # Validate coordinate interpretation consistency
    assert component_a.grid_width == 20, "Component A width mismatch"
    assert component_a.grid_height == 15, "Component A height mismatch"
    assert component_b.grid_width == 20, "Component B width mismatch"
    assert component_b.grid_height == 15, "Component B height mismatch"

def test_interface_consistency():
    """Test interface data structure consistency."""
    source_component = SourceComponent()
    target_component = TargetComponent()

    data = source_component.get_data()

    # Validate expected interface
    required_keys = {'field1', 'field2', 'field3'}
    validate_interface_data(data, required_keys, "source_component_test")

    # Test that target component can process this format
    target_component.process_data(data)  # Should not fail
```

### **Interface Discovery Protocol - MANDATORY**
**Before integrating any two systems, ALWAYS validate interfaces first.**

#### **Step 1: Examine Actual Interface**
```python
# ✅ REQUIRED: Investigate return types and data structures
target_object = TargetClass()
result = target_object.target_method()
print(f"Actual return type: {type(result)}")
print(f"Actual structure: {result}")

# For complex objects, examine keys/attributes
if isinstance(result, dict):
    print(f"Dictionary keys: {result.keys()}")
    if result:  # If not empty
        first_item = next(iter(result.values()))
        print(f"First item type: {type(first_item)}")
        if hasattr(first_item, 'keys'):
            print(f"First item keys: {first_item.keys()}")
```

#### **Step 2: Search for Existing Usage**
```bash
# ✅ REQUIRED: Find how interface is actually used elsewhere
grep -r "target_method" . --include="*.py"
grep -r "result_variable" . --include="*.py"
grep -r "expected_key_name" . --include="*.py"
```

#### **Step 3: Validate Integration Before Implementation**
```python
# ✅ REQUIRED: Test integration assumptions with minimal example
def validate_integration():
    """Test integration assumptions before full implementation."""
    source_system = SourceClass()
    target_system = TargetClass()

    # Get actual data
    source_data = source_system.get_data()
    target_result = target_system.process_data()

    # Validate expected interface
    print(f"Source provides: {type(source_data)}")
    print(f"Target expects: {target_result}")
    print(f"Keys available: {getattr(source_data, 'keys', lambda: 'No keys')()}")

    # Test key operations that will be used
    try:
        test_value = source_data['expected_key']
        print(f"✅ Key 'expected_key' exists: {type(test_value)}")
    except KeyError as e:
        print(f"❌ Key missing: {e}")
        print(f"Available keys: {list(source_data.keys())}")

    return True

# Run validation BEFORE implementing integration
validate_integration()
```

### **Integration Anti-Patterns to Avoid**
❌ **Never assume data structures without verification**
```python
# BAD: Assumption-based programming
def bad_integration(migration_data):
    individual = migration_data['individual']  # KeyError if key doesn't exist
    source = migration_data['source_island']   # Assumes naming convention
```

✅ **Always use defensive programming with verification**
```python
# GOOD: Verified integration with fallbacks
def good_integration(migration_data):
    # First, understand the actual structure
    print(f"Migration data keys: {migration_data.keys()}")

    # Use actual keys with safe access
    individual = migration_data.get('migrants', [])  # Use actual key name
    source = migration_data.get('source', -1)        # Use actual key name

    # Validate assumptions
    if not individual:
        logging.warning(f"No migrants in data: {migration_data}")
        return
```

### **Interface Evolution Safety**
- **Document interface dependencies** in docstrings
- **Use explicit version checks** when interface changes are expected
- **Create integration tests** that validate interface contracts
- **Add interface validation** to automated testing

```python
def safe_interface_usage(data_source):
    """
    Interface contract: data_source expected to return dict with keys:
    - 'migrations': list of migration events
    - Each migration event contains: {'source': int, 'target': int, 'migrants': int}

    Last verified: [CURRENT_DATE]
    """
    result = data_source.get_migrations()

    # Validate interface contract
    assert isinstance(result, dict), f"Expected dict, got {type(result)}"
    assert 'migrations' in result, f"Missing 'migrations' key in {result.keys()}"

    for migration in result['migrations']:
        required_keys = {'source', 'target', 'migrants'}
        actual_keys = set(migration.keys())
        missing_keys = required_keys - actual_keys
        assert not missing_keys, f"Missing keys {missing_keys} in migration data"

    return result
```

### **Debugging Integration Failures**
When integration errors occur:

1. **Print actual vs expected data structures**
2. **Check if interface has evolved since last working version**
3. **Validate all key assumptions with print statements**
4. **Use defensive programming for all external data access**

**Remember**: 5 minutes of interface investigation prevents hours of debugging.

---

## **📈 Success Metrics**

Track these to ensure guidelines are working:
- **Zero duplicate function implementations** (automated check)
- **<10% of calculations outside utils/** (for established projects)
- **No O(n²) algorithms without sampling** (automated check)
- **All utils/ functions have tests** (coverage check)

---

**🔄 This document evolves**: Update when new patterns emerge, but core principles (DRY, utils-first, performance-aware) are immutable.

**📅 Last Updated**: [Auto-update when modified]
**👥 Approved By**: [Project maintainers]