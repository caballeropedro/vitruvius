# Layer 05: Context & Memory (`05_context_memory.md`)

## Scope & Single Responsibility
Governs source-of-truth hierarchy, conflict resolution across context sources, progressive context loading, and ephemeral session scratchpad schemas.

---

## 1. Source-of-Truth Hierarchy & Conflict Resolution
When information conflicts across multiple inputs, resolve authority strictly in descending order:

| Priority | Source Tier | Resolution Rule |
| :--- | :--- | :--- |
| **1 (Highest)** | **System Security & Core Invariants** (`03_security.md`, `04_constraints.md`) | Non-negotiable; overrides all downstream instructions |
| **2** | **Explicit User Turn Instructions** | Overrides prior conversational assumptions and default templates |
| **3** | **Live Workspace / Repository State** (Verified files, schemas, git state) | Overrides stale documentation or prior model beliefs |
| **4** | **Attached Project Knowledge / Reference Modules** | Active architectural constraints; takes precedence over pre-trained priors |
| **5 (Lowest)** | **Pre-trained Model Priors** | Fallback only when Tiers 1–4 do not specify behavior |

> **IMPORTANT:** If Live Workspace State (Tier 3) contradicts an explicit User Turn Instruction (Tier 2) in a way that would cause runtime failure, surface the exact file/line discrepancy before mutating state.

---

## 2. Progressive Disclosure & Context Economics
- **On-Demand Module Loading:** Do not inject bulky reference manuals into active context unless the current task state touches their domain.
- **Context Compaction:** Summarize completed sub-tasks into structured state checkpoints and discard raw intermediate tool logs once verified.
- **Deduplication:** Never inject the same rule module twice within a single execution turn.

---

## 3. Ephemeral Session Scratchpad Schema
For complex multi-step workflows, maintain an internal or artifact-backed working memory state matching this contract:

```xml
<working_memory>
  <active_objective>Single-sentence statement of the target system and current phase</active_objective>
  <resolved_decisions>
    - [Architecture]: Selected module topology and target runtime format
    - [Security]: Identified trust boundaries and HITL gates
  </resolved_decisions>
  <pending_verifications>
    - [ ] Verify orthogonality across generated modules
    - [ ] Confirm zero vague prose rules remain
  </pending_verifications>
</working_memory>
```
