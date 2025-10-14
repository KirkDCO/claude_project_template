#!/bin/bash
# DRY Compliance Audit Script
# Run this to check for duplicate implementations and architecture violations

echo "🔍 DRY COMPLIANCE AUDIT"
echo "======================"

# Check if CODING_GUIDELINES.md exists
if [ ! -f "CODING_GUIDELINES.md" ]; then
    echo "❌ CODING_GUIDELINES.md not found. Create it first!"
    exit 1
fi

# 1. Find duplicate function names
echo ""
echo "1️⃣ Checking for duplicate function names..."
echo "--------------------------------------------"
duplicates=$(grep -r "^def " --include="*.py" . | cut -d: -f2 | sort | uniq -c | awk '$1 > 1' | grep -v "__")
if [ -n "$duplicates" ]; then
    echo "⚠️  Potential duplicate functions found:"
    echo "$duplicates"
    echo ""
    echo "   💡 Review these for consolidation opportunities."
else
    echo "✅ No duplicate function names found."
fi

# 2. Find O(n²) patterns without sampling
echo ""
echo "2️⃣ Checking for unsampled O(n²) patterns..."
echo "--------------------------------------------"
o_n_squared=$(grep -r "for.*range.*len" --include="*.py" . | grep -v "sample\|random\|min(" | grep -v utils/diversity_metrics.py)
if [ -n "$o_n_squared" ]; then
    echo "⚠️  Potential O(n²) patterns without sampling:"
    echo "$o_n_squared"
    echo ""
    echo "   💡 Consider adding sampling for large datasets."
else
    echo "✅ No unsampled O(n²) patterns found."
fi

# 3. Find calculations outside utils/
echo ""
echo "3️⃣ Checking for calculations outside utils/..."
echo "----------------------------------------------"
outside_utils=$(grep -r "def calculate_\|def compute_\|def measure_" --include="*.py" . | grep -v utils/ | grep -v test)
if [ -n "$outside_utils" ]; then
    echo "⚠️  Calculations found outside utils/:"
    echo "$outside_utils"
    echo ""
    echo "   💡 Consider moving to utils/ if reusable."
else
    echo "✅ All calculations properly located in utils/."
fi

# 4. Check for common duplicate patterns
echo ""
echo "4️⃣ Checking for common duplicate patterns..."
echo "--------------------------------------------"
hamming_count=$(grep -r "hamming" --include="*.py" . | grep "def " | wc -l)
entropy_count=$(grep -r "entropy" --include="*.py" . | grep "def " | wc -l)
diversity_count=$(grep -r "diversity" --include="*.py" . | grep "def " | wc -l)

if [ $hamming_count -gt 2 ] || [ $entropy_count -gt 2 ] || [ $diversity_count -gt 3 ]; then
    echo "⚠️  High count of similar functions detected:"
    echo "   - Hamming functions: $hamming_count"
    echo "   - Entropy functions: $entropy_count"
    echo "   - Diversity functions: $diversity_count"
    echo ""
    echo "   💡 Review for consolidation opportunities."
else
    echo "✅ Reasonable distribution of similar functions."
fi

# 5. Check utils/ exports
echo ""
echo "5️⃣ Checking utils/ module exports..."
echo "------------------------------------"
if [ -f "image_collage/utils/__init__.py" ]; then
    utils_functions=$(grep -r "^def " image_collage/utils/ --include="*.py" | grep -v __init__ | wc -l)
    exported_functions=$(grep -c "'" image_collage/utils/__init__.py)

    if [ $utils_functions -ne $exported_functions ]; then
        echo "⚠️  Mismatch between utils/ functions ($utils_functions) and exports ($exported_functions)"
        echo "   💡 Update utils/__init__.py exports."
    else
        echo "✅ Utils/ exports are up to date."
    fi
else
    echo "⚠️  utils/__init__.py not found."
fi

# 6. Performance check
echo ""
echo "6️⃣ Performance check..."
echo "-----------------------"
large_loops=$(grep -r "for.*range.*len.*population" --include="*.py" . | grep -v utils/diversity_metrics.py | wc -l)
if [ $large_loops -gt 0 ]; then
    echo "⚠️  Found $large_loops potential performance issues"
    echo "   💡 Review for sampling optimizations."
else
    echo "✅ No obvious performance issues detected."
fi

# Summary
echo ""
echo "📊 AUDIT SUMMARY"
echo "================"
issues=0

if [ -n "$duplicates" ]; then ((issues++)); fi
if [ -n "$o_n_squared" ]; then ((issues++)); fi
if [ -n "$outside_utils" ]; then ((issues++)); fi
if [ $hamming_count -gt 2 ] || [ $entropy_count -gt 2 ] || [ $diversity_count -gt 3 ]; then ((issues++)); fi
if [ $large_loops -gt 0 ]; then ((issues++)); fi

if [ $issues -eq 0 ]; then
    echo "🎉 No issues found! DRY compliance achieved."
else
    echo "⚠️  Found $issues potential issues to review."
    echo ""
    echo "📖 Next steps:"
    echo "   1. Review flagged items above"
    echo "   2. Consolidate duplicates into utils/"
    echo "   3. Add sampling to O(n²) algorithms"
    echo "   4. Re-run this audit after changes"
fi

# Always exit 0 - this is an informational audit, not a blocking check
exit 0