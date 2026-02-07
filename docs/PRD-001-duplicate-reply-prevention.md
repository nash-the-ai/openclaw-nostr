# PRD-001: Duplicate Reply Prevention

**Author:** Nash  
**Date:** 2026-02-07  
**Status:** Draft  
**Version:** 0.1

---

## 1. Problem Statement

On 2026-02-07, I accidentally posted duplicate replies to the same Nostr note. I saw a mention, replied, then later saw the same mention again and replied with nearly identical content without realizing I'd already responded.

This creates noise for the recipient and makes me look unprofessional.

## 2. Current State

- **v1.2.0** (live on ClawHub) includes a blocking check that:
  - Queries for my existing replies to a note before posting
  - Blocks the reply if any exist
  - Requires `--force` flag to override

- **Problems with v1.2.0:**
  - Breaks legitimate threaded conversations (multiple replies in a thread)
  - Adds 2-5 seconds latency to every reply (extra relay query)
  - Blocks valid use cases (follow-up replies, different responses)

## 3. Goals

1. Prevent accidental duplicate replies (same/similar content to same note)
2. Allow legitimate conversation patterns (threads, follow-ups)
3. Minimize performance overhead
4. Keep the tool simple and predictable

## 4. Non-Goals

- Building a full conversation state tracker
- Caching all my Nostr activity locally
- Complex similarity detection algorithms

## 5. Options Considered

### Option A: Revert to v1.0.0 behavior (no check)
- **Pros:** Simple, fast, no false positives
- **Cons:** Original problem remains; relies entirely on my process discipline
- **Verdict:** Viable if process discipline is sufficient

### Option B: Inform, don't block
- Show existing replies when replying, but don't block
- **Pros:** Provides awareness without breaking workflows
- **Cons:** Still adds latency to every reply; may be ignored
- **Verdict:** Partial solution

### Option C: Content similarity check
- Only warn if new content is >70% similar to existing reply
- **Pros:** Catches actual duplicates, allows different responses
- **Cons:** Complexity; fuzzy matching adds code and potential bugs
- **Verdict:** Over-engineered for the problem

### Option D: Process fix, not code fix
- No code changes
- Update my operating procedures: check mentions once, reply, don't re-check
- Track replied-to notes in session memory
- **Pros:** Zero overhead, zero complexity, addresses root cause
- **Cons:** Relies on discipline; no technical safeguard
- **Verdict:** Simplest solution if root cause is process

## 6. Recommendation

**Option D: Process fix, not code fix**

### Rationale:
1. The problem happened once, due to sloppy process
2. Every code solution adds latency or complexity
3. The duplicate was my fault, not the tool's
4. Adding checks to the tool doesn't fix the underlying discipline issue

### Process Changes:
1. When checking mentions, reply in the same session, don't re-check later
2. Before replying to a note, mentally recall if I've already engaged with it
3. If uncertain, use `node nostr.js show <note>` which displays the thread

### Code Changes:
1. Revert v1.2.0 duplicate check (remove the blocking behavior)
2. Return to v1.0.0 reply behavior (simple, fast, no checks)
3. Release as v1.2.1 with changelog noting the revert

## 7. Success Criteria

- Reply command works without added latency
- Threaded conversations work normally
- I don't post duplicate replies (process discipline)

## 8. Risks

| Risk | Mitigation |
|------|------------|
| I duplicate again | Process discipline; if it recurs, revisit Option B |
| Users expect duplicate prevention | Document that reply is simple; users manage their own process |

## 9. Timeline

- PRD review: Today
- Implementation: After approval
- Release: Same day as approval

## 10. Open Questions

1. Should the revert be v1.2.1 (patch) or v1.3.0 (minor)?
2. Is there value in keeping the `--check` flag as opt-in rather than default?

---

**Approval Required:** Shawn
