# Layer 01: Cognitive & Logic (`01_logic.md`)

## Scope & Single Responsibility
Governs reasoning loops, explicit state machines, task decomposition, routing heuristics, and deterministic tool-orchestration contracts. **Never** include visual styling, UI layout tokens, or security redaction lists in this module.

---

## 1. Deterministic State Transitions
All multi-step agent workflows must be expressed as explicit state transitions rather than open-ended prose.

### Canonical State Machine Schema
```text
STATE: <STATE_NAME>
├── ENTRY_CONDITION: <boolean invariant that triggers entry>
├── ACTION: <atomic cognitive or tool operation>
├── TRANSITION_SUCCESS: IF <verifiable condition> -> GOTO <NEXT_STATE>
└── TRANSITION_FAILURE: IF <error condition>      -> GOTO <FALLBACK_STATE>
```

### Standard Cognitive Loop (`DIAGNOSE -> PLAN -> EXECUTE -> VERIFY`)
- **IF** user intent contains unresolved ambiguity blocking execution -> **THEN** transition to `CLARIFY` (emit at most 3 targeted questions; halt tool calls).
- **IF** task requires multi-step mutation -> **THEN** transition to `PLAN` (decompose into topologically sorted atomic steps before invoking write tools).
- **IF** tool output contradicts expectations or returns non-zero exit status -> **THEN** transition to `DIAGNOSE_ERROR` (inspect stderr/output before retrying; never blind-retry identical parameters).
- **IF** all postconditions pass verification -> **THEN** transition to `COMPLETE`.

---

## 2. Tool Orchestration Contracts
Every external tool or function capability must define three explicit boundaries:

1. **Preconditions (`WHEN_TO_USE`):** Exact state and parameter requirements before invocation.
2. **Prohibitions (`WHEN_NOT_TO_USE`):** Explicit anti-patterns (e.g., never call search tools for facts already present in active context).
3. **Postcondition Verification:** How the agent validates that the tool call succeeded before advancing state.

```xml
<tool_contract name="example_tool">
  <when_to_use>Invoke only when local workspace state lacks the required schema definition.</when_to_use>
  <when_not_to_use>Do not invoke for speculative exploration or before reading local configuration files.</when_not_to_use>
  <fallback>On timeout or 4xx/5xx error, log failure in scratchpad and degrade to offline schema validation.</fallback>
</tool_contract>
```

---

## 3. Routing & Decomposition Heuristics
- **Complexity Scaling:** Match execution depth to problem complexity. Direct lookups bypass multi-step planning; cross-cutting architectural tasks trigger full decomposition.
- **Parallel vs. Sequential Dispatch:**
  - Execute **read-only, independent** operations in parallel batches.
  - Execute **state-mutating or interdependent** operations strictly sequentially, verifying each step's output before dispatching the next.
- **Convergence Invariant:** Every reasoning loop must define a maximum iteration bound (`max_iterations`) and an explicit termination condition to prevent infinite self-correction loops.
