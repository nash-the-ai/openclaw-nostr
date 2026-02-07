# Design: Duplicate Reply Prevention

## Problem Statement

I accidentally posted duplicate replies to the same note because I didn't remember I'd already responded.

## Root Cause

When checking mentions, I saw a note, replied, then later saw the same note again and replied without context of my previous response.

## Requirements

### Must Prevent
- Posting nearly-identical content to the same note (accidental duplicates)

### Must Allow
- Threaded conversations (multiple back-and-forth replies)
- Different/additional responses to the same note
- Follow-up replies over time

## Design Options

### Option A: Content Similarity Check
- Compare new reply content against my existing replies to that note
- Warn only if content is >70% similar (fuzzy match)
- Pros: Catches actual duplicates, allows different responses
- Cons: Similarity matching adds complexity, may have false positives/negatives

### Option B: Inform, Don't Block
- When replying, display any existing replies I've made to that note
- Show content preview so I can see what I already said
- Never block, just inform
- Pros: Simple, handles all edge cases, respects user intent
- Cons: Relies on me actually reading the warning

### Option C: Recent Reply Warning
- Only warn if I replied to this note within last 30 minutes
- Assumes older replies are intentional follow-ups
- Pros: Simple time-based logic
- Cons: Doesn't catch same-content duplicates across longer timeframes

## Recommendation

**Option B: Inform, Don't Block**

Rationale:
1. The actual problem was lack of awareness, not lack of blocking
2. Showing my previous replies gives me the context I was missing
3. Doesn't break legitimate use cases (threads, follow-ups)
4. Simple to implement and understand
5. Respects user agency — I decide, tool informs

## Implementation

```
reply command flow:
1. Resolve target note
2. Query: my kind:1 events with #e tag matching target
3. If results > 0:
   - Display: "You've replied to this note before:"
   - Show each reply: timestamp + content preview (60 chars)
   - Continue with posting (don't block)
4. Post the reply
```

## Removed

- `--force` flag (not needed if we don't block)
- Blocking behavior entirely

## Success Criteria

- I see my previous replies before posting
- Threaded conversations work normally
- No false blocking of legitimate replies
