# Developer Guidelines - Human Edition

**🎯 Purpose**: Personal workflow and habits to maintain code quality and productive collaboration with Claude Code.

**🧠 Mindset**: These guidelines help YOU stay sharp and avoid common pitfalls when working with AI assistance.

---

## **🚀 Session Startup Ritual**

### **Before Starting ANY Development Session:**
```bash
# 1. Quick mental reset
echo "Starting dev session for: [PROJECT NAME]"

# 2. Review current state
./scripts/dry_audit.sh || echo "No audit script - create one!"

# 3. Check what you were working on
git status
git log --oneline -5

# 4. Review guidelines (this file!)
grep "## 🎯" DEVELOPER_GUIDELINES.md -A 5

# 5. Set session goals
echo "Today I will: [write 1-2 specific goals]"
```

### **Mental Preparation Checklist:**
- [ ] What am I trying to accomplish today?
- [ ] What are the 2-3 most important things to get right?
- [ ] What mistakes do I typically make that I should watch for?
- [ ] Am I feeling rushed? (If yes, slow down and be more explicit with AI)
- [ ] **NEW**: Am I integrating components? (If yes, validate interfaces first)
- [ ] **NEW**: Does this involve coordinate systems? (If yes, verify standard conventions)

---

## **🎯 Collaboration Patterns with Claude Code**

### **High-Quality Request Patterns:**

#### **Instead of:** "Add feature X"
**Use:** "Add feature X. First audit existing similar functionality, then follow CODING_GUIDELINES.md principles, then implement using utils-first pattern."

#### **Instead of:** "Fix this bug"
**Use:** "Debug this issue. Show me what you find, explain the root cause, then propose a fix that follows our architectural patterns."

#### **Instead of:** "Optimize this code"
**Use:** "Analyze this code for performance issues. Look for O(n²) patterns, duplicate calculations, and opportunities to use existing utils/. Then optimize following our guidelines."

### **Red Flag Phrases to Avoid:**
- ❌ "Just quickly add..." (leads to shortcuts and duplication)
- ❌ "Copy this pattern..." (promotes copy-paste instead of abstraction)
- ❌ "Make it work first..." (without mentioning clean architecture)
- ❌ "We can refactor later..." (technical debt accumulation)

### **Green Flag Phrases to Use:**
- ✅ "Following our coding guidelines..."
- ✅ "Using the existing utils pattern..."
- ✅ "Check for similar implementations first..."
- ✅ "Ensure this follows DRY principles..."
- ✅ "Validate the interface before integrating..."
- ✅ "Verify coordinate system consistency..."
- ✅ "Check configuration propagation..."
- ✅ "Test interface assumptions first..."
- ✅ "What's your skeptical opinion on this?"
- ✅ "What could go wrong with this approach?"

---

## **🔬 Scientific Rigor Over Flattery**

### **For AI Assistants - CRITICAL:**

**Prefer honest skepticism over validating enthusiasm.**

When the human proposes an idea:
1. **First instinct should be skepticism**, not agreement
2. **Identify failure modes** before discussing benefits
3. **Ask "what problem does this actually solve?"** - the problem may not exist
4. **Look for simpler alternatives** that make the clever approach unnecessary
5. **Demand empirical validation** before endorsing complex strategies

### **Anti-Patterns to Avoid:**
- ❌ "That's a great insight!" (when it's an obvious idea)
- ❌ "This is a clever approach!" (when it has fatal flaws)
- ❌ "You're right that..." (reflexive agreement without analysis)
- ❌ Listing benefits before critically examining the premise
- ❌ Enthusiasm for complexity when simplicity might work

### **Patterns to Follow:**
- ✅ "Let me push back on this..."
- ✅ "The problem with this approach is..."
- ✅ "Have we established that this problem actually exists?"
- ✅ "A simpler alternative would be..."
- ✅ "Before investing in this, we should verify..."
- ✅ "My skeptical take: [honest concerns]"

### **The Standard for Praise:**
Reserve positive feedback for ideas that survive scrutiny:
- The idea addresses a **verified problem** (not hypothetical)
- It's **simpler than alternatives** (not clever for cleverness sake)
- It has **no obvious fatal flaws** (after genuine attempt to find them)
- It's **empirically testable** (not just theoretically appealing)

If an idea doesn't meet these criteria, say so directly. A dead-end identified early saves hours of wasted effort. Honest skepticism is more valuable than comfortable agreement.

### **For Human Developers:**
- **Ask for skeptical review**: "What's wrong with this idea?"
- **Welcome pushback**: Resistance means the AI is thinking critically
- **Be suspicious of easy agreement**: If the AI immediately loves your idea, it might not be analyzing deeply enough
- **Request failure modes**: "How could this approach fail?"

**Remember**: A good collaborator tells you when your idea won't work. That's more valuable than being told you're brilliant.

---

## **🔌 Interface Integration Discipline**

### **Before ANY System Integration:**
```bash
# 1. Always validate interfaces first
echo "Investigating interface structure..."
python3 -c "
target = TargetClass()
result = target.method()
print(f'Return type: {type(result)}')
print(f'Structure: {result}')
if hasattr(result, 'keys'): print(f'Keys: {list(result.keys())}')
"

# 2. Search for existing usage patterns
grep -r "target_method" . --include="*.py"

# 3. Test with minimal example before full implementation
```

### **Interface Validation Habits:**
- [ ] Never assume data structure without verification
- [ ] Always print actual interface first
- [ ] Search existing codebase for usage patterns
- [ ] Test integration logic with minimal example
- [ ] Document interface dependencies in code

### **Common Integration Mistakes to Avoid:**
- ❌ Assuming key names without checking
- ❌ Not handling missing or changed interfaces
- ❌ Implementing integration without validation
- ❌ Ignoring error handling for interface mismatches

**Remember**: 5 minutes of interface investigation prevents hours of debugging.

---

## **🧪 Quality Control Habits**

### **After Every Significant Change:**
```bash
# 1. Run tests (if they exist)
pytest || python -m unittest || echo "Add tests to this project!"

# 2. Check for violations
./scripts/dry_audit.sh

# 3. Look for new duplicates
grep -r "def.*calculate" . --include="*.py" | cut -d: -f1 | sort | uniq -c | sort -nr

# 4. Commit with clear message
git add . && git commit -m "feat: descriptive message following conventional commits"
```

### **Weekly Architecture Review:**
- [ ] Run full audit and address all violations
- [ ] Review recent commits for patterns that should be extracted to utils/
- [ ] Check if any new guidelines should be added based on recent work
- [ ] Update documentation if patterns have evolved

---

## **💭 Common Human Pitfalls (And How to Avoid Them)**

### **1. "Good Enough" Syndrome**
**Problem**: Accepting working but duplicated/messy code
**Solution**: Always ask "Could this be reused elsewhere?" If yes, move to utils/

### **2. Session Momentum Trap**
**Problem**: Getting caught up in implementation and forgetting architecture
**Solution**: Set 30-minute check-ins to review if you're following guidelines

### **3. Assumption Overload**
**Problem**: Assuming Claude knows your specific patterns without being explicit
**Solution**: Always reference CODING_GUIDELINES.md in requests for significant changes

### **4. Refactor Procrastination**
**Problem**: "I'll clean this up later" (but never do)
**Solution**: Make refactoring part of feature completion, not a separate task

### **5. Context Switching Chaos**
**Problem**: Working on multiple features and losing track of architectural decisions
**Solution**: Use git branches and document decisions in commit messages

### **6. Integration Boundary Neglect**
**Problem**: Assuming interfaces work without validation (causes 75% of critical errors)
**Solution**: Always validate data structures and coordinate systems at component boundaries

### **7. Coordinate System Confusion**
**Problem**: Different components using different coordinate conventions
**Solution**: Establish and enforce single standard with validation functions

### **8. Configuration Drift**
**Problem**: Components using hardcoded values instead of reading from config
**Solution**: Add logging to verify configuration values are properly propagated

---

## **🎨 Effective Communication with AI**

### **When to Be More Explicit:**
- **Starting new features** - Always mention guidelines and patterns
- **Complex refactoring** - Explain the current state and desired end state
- **Performance work** - Specify what "good enough" means for your use case
- **Architecture decisions** - Share your reasoning and constraints
- **Component integration** - Always mention interface validation requirements
- **Coordinate system work** - Explicitly state coordinate conventions
- **Configuration changes** - Request verification of value propagation

### **When You Can Be Less Explicit:**
- **Small bug fixes** that don't affect architecture
- **Adding simple tests** that follow existing patterns
- **Documentation updates** that don't involve code structure

### **Signs You Need to Slow Down:**
- Claude suggests solutions that duplicate existing functionality
- You find yourself saying "that's not what I meant" frequently
- The AI isn't following your established patterns
- You're getting frustrated with the responses
- **NEW**: Integration errors keep occurring (suggests missing interface validation)
- **NEW**: Coordinate system bugs appearing (suggests inconsistent conventions)
- **NEW**: Configuration values not reaching components (suggests hardcoded defaults)

**Solution**: Take a break, re-read your guidelines, and restart with more explicit context.

### **Critical Integration Warning Signs:**
- **KeyError exceptions** during component interaction (interface mismatch)
- **IndexError in array operations** (coordinate system inconsistency)
- **Hardcoded values** being used instead of configuration parameters
- **Different components** reporting different dimensions for same config
- **Performance degradation** without obvious algorithmic changes (configuration drift)

---

## **🔄 Project Evolution Strategies**

### **As Your Project Grows:**

#### **Early Stage (First 2-4 weeks):**
- Focus on establishing utils/ patterns
- Be very explicit about architectural decisions
- Document patterns as they emerge
- Run audit frequently (daily)

#### **Middle Stage (1-3 months):**
- Regular architecture reviews (weekly)
- Extract common patterns to guidelines
- Add project-specific anti-patterns to avoid
- Automate quality checks

#### **Mature Stage (3+ months):**
- Monthly deep architecture reviews
- Share patterns with other projects
- Mentor new team members on guidelines
- Evolve guidelines based on lessons learned

### **Warning Signs Your Process Is Breaking Down:**
- Increasing number of "quick fixes"
- Growing list of "technical debt to address later"
- New team members confused about architecture
- AI assistants suggesting duplicate implementations
- Performance degrading without obvious cause

---

## **📚 Personal Learning and Growth**

### **Skills to Develop:**
- **Pattern recognition**: Spotting duplication before it spreads
- **Architecture thinking**: Designing for reuse from the start
- **Communication clarity**: Getting AI to understand your intent
- **Quality habits**: Making good practices automatic

### **Regular Self-Assessment Questions:**
- Am I being consistent with my own guidelines?
- What mistakes did I make this week that guidelines could prevent?
- How can I communicate more effectively with AI assistants?
- What patterns am I seeing that should be documented?

### **Knowledge Gaps to Fill:**
- Learn your language's best practices deeply
- Understand performance implications of common patterns
- Study good examples of modular architecture
- Practice explaining technical concepts clearly

---

## **🚨 Emergency Procedures**

### **When You Realize You've Created a Mess:**
1. **STOP** - Don't make it worse by rushing
2. **Assess** - Run audit to see the full scope
3. **Plan** - Prioritize the most critical duplications
4. **Execute** - Fix systematically, not all at once
5. **Prevent** - Update guidelines to prevent recurrence

### **When Working Under Pressure:**
- Explicitly mention time constraints to AI
- Ask for "quick but clean" solutions that follow patterns
- Defer optimization but not architecture compliance
- Document any shortcuts for later cleanup

### **When Guidelines Conflict with Deadlines:**
- Discuss with team/stakeholders about technical debt cost
- Choose the guideline violations that are easiest to fix later
- Document all compromises and schedule cleanup
- Never compromise on security or data safety

---

## **🎁 Success Patterns**

### **You Know It's Working When:**
- New features naturally follow established patterns
- AI assistants rarely suggest duplicate implementations
- Code reviews focus on business logic, not architecture
- New team members can contribute quickly
- Performance is predictable and maintainable

### **Celebrate These Wins:**
- Successfully catching a duplication before it's implemented
- A new feature that reuses existing utils perfectly
- An AI assistant that follows your patterns without explicit direction
- A complex feature that's easy to test because of good architecture

---

**🔄 Update this document** as you learn what works and what doesn't for YOUR workflow.

**📅 Review frequency**: Weekly for first month, then monthly
**🎯 Goal**: Make good architecture decisions automatic, not effortful