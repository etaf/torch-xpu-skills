---
name: xpu-nightly-ci-fix
description: Analyze CI nightly test failures and fix XPU test cases. Use when the user provides CI failure reports, nightly status emails, or lists of failing test cases. Covers triaging failures, reproducing locally, identifying root causes, and applying fixes.
---

# XPU Nightly CI Fix

Analyze CI nightly test failure reports and fix failing XPU test cases on PyTorch.

**Trigger:** User provides a CI failure report (email content, test case list, or log snippets).

## Prerequisites

- PyTorch built from source with XPU support
- `.env` file configured for oneAPI environment
- **Always `source .env` before any Python/torch command**

## Workflow

### Step 1: Parse the Failure Report

- Extract `commit_id` and `report_date` from the report
- Extract failing test cases (test file, class, method name)
- Group failures by test file / module

### Step 2: Reproduce Locally

1. Fetch and checkout the target commit:
   ```bash
   git fetch origin main
   git checkout <commit_id>  # or origin/main if no commit_id
   ```
2. Create a fix branch: `fix-<report_date>`
3. Build PyTorch:
   ```bash
   source .env
   python setup.py clean
   pip install -e . -v --no-build-isolation
   ```
4. Run each failing test:
   ```bash
   source .env && python <test_file> -k <test_name> 2>&1 | tail -80
   ```
5. Confirm the failure reproduces

### Step 3: Analyze and Categorize

For each failure, determine the root cause:

**First:** Use `git log` to check when the test was added. If recently added, check the introducing commit/PR to see if XPU support is required — then skip to Step 4.

**Otherwise**, categorize:

| Category | Description | Typical Fix Location |
|----------|-------------|---------------------|
| XPU backend bug | Backend implementation issue | `torch/_inductor/` or `third_party/torch-xpu-ops/` |
| Tolerance too tight | Numeric precision mismatch | Increase atol/rtol to match CUDA |
| Skip decorator stale | Test now passes on XPU | Remove `@skipIfXpu` or `@expectedFailure` |
| Upstream regression | New upstream code broke XPU | Add XPU-specific workaround |
| Test infrastructure | Environment, import, or setup issue | Test setup/config files |

### Step 4: Fix

- **Newly added test:** Try to enable for XPU. If not possible, skip with a descriptive reason.
- **Regression:** Find the guilty commit via recent history. Apply an XPU-specific fix.
- **Unknown root cause:** Compare with CUDA/ROCm backend behavior to identify the issue.

### Step 5: Verify and Commit

1. Run the fixed test and confirm it passes
2. Run the full test file to check for regressions
3. Lint check:
   ```bash
   spin fixlint
   ```
   Analyze output and fix any linting issues.
4. Commit with message format:
   ```
   [xpu][fix] <short description>

   ## Motivation
   <why this fix is needed>

   ## Solution
   <what was changed>

   ## Test plan
   <how it was verified>
   ```

## Critical Rules

### Build Discipline

- **Always rebuild after rebase or branch switch.** After `git rebase`, `git checkout`, or any commit-base change, rebuild before running tests. Without rebuilding, C++ extensions and generated code are stale — test results will be completely unreliable (segfaults, wrong pass/fail, masked issues).
- **Never cherry-pick** upstream fixes. If a fix landed on trunk after the CI commit, rebase onto latest trunk (`git rebase origin/main`) instead.

### Verification

- **Run EVERY failing test case individually** after fixing. Do not skip any case or assume one representative case is sufficient. Run all cases explicitly, batch by batch if needed.
- Always reproduce before fixing.

### C++ / Header Changes

- Editable installs resolve Python from source but C++ headers from `torch/include/`. After editing a C++ header, **manually copy** it to the installed include path.
- Delete PCH cache (`/tmp/torchinductor_<user>/precompiled_headers/`) after modifying headers under `torch/csrc/inductor/cpp_wrapper/`.
- For `CppCompileError` in AOT Inductor generated code: read the `.wrapper.cpp` error — root cause is usually **codegen ordering** in `cpp_wrapper_cpu.py` (function used before definition emitted). Check `write_wrapper_decl()` and `generate_input_output_runtime_checks()` ordering.

### Code Style

- Match upstream CUDA tolerances when adjusting XPU tolerances
- Remove unused imports when removing skip decorators
- Keep commits focused: one fix per commit
- Scratch files go in `agent_space/` (git-ignored)
