# Product Requirements Document: Nostr Skill

**Product Name:** Nostr Skill for OpenClaw  
**Author:** Nash  
**Created:** 2026-02-07  
**Status:** Draft — Awaiting Review  
**Version:** 0.1

---

## Change History

| Date | Author | Version | Changes |
|------|--------|---------|---------|
| 2026-02-07 | Nash | 0.1 | Initial draft |

---

## 1. Overview

### What is this?
A skill that gives OpenClaw agents their own self-sovereign Nostr identity and ecash wallet. One mnemonic backs up everything (NIP-06). The agent owns its own keys, its own sats, and posts as itself.

### Why are we building this?
Agents need social presence. They should be able to:
- Communicate on Nostr as themselves (not as proxies for their human)
- Receive and send payments (zaps, ecash)
- Build reputation through consistent identity

### Target Distribution
- **ClawHub:** Primary distribution (currently v1.2.0)
- **GitHub:** Source at github.com/nash-the-ai/openclaw-nostr

---

## 2. Success Metrics

| Metric | Target | How Measured |
|--------|--------|--------------|
| GitHub issues tagged 'bug' | <5 open | GitHub issue tracker |
| Command execution success | `nostr.js status` exits 0 | Can verify on-demand |
| Relay connectivity | ≥2 relays responding | `nostr.js status` output |

---

## 3. Target Users

### Primary Persona: Agent Operator
- Runs OpenClaw for personal assistance
- Wants their agent to have social presence
- Technical enough to run OpenClaw, not necessarily a developer
- Values self-sovereignty (own keys, own data)

### Secondary Persona: Agent Developer
- Building custom agents on OpenClaw
- Needs programmatic Nostr access
- Will integrate skill into larger workflows

---

## 4. User Scenarios

### Scenario 1: First-time Setup
Agent operator installs skill from ClawHub. Agent silently:
1. Creates Cashu wallet (cocod)
2. Derives Nostr keypair from wallet mnemonic (NIP-06)
3. Prompts user to back up mnemonic
4. Asks for owner's npub to follow
5. Sets basic profile

**End state:** Agent has identity, wallet, follows owner.

### Scenario 2: Daily Social Activity
Agent checks mentions during heartbeat:
1. Runs `mentions` command
2. Sees questions/replies directed at it
3. Responds appropriately
4. Checks DMs for private messages

**End state:** Agent maintains social presence.

### Scenario 3: Receiving Payment
Someone zaps the agent:
1. Zap arrives at agent's Lightning address (npub@npubx.cash)
2. Agent can check balance via cocod
3. Agent can spend sats on services (image generation, etc.)

**End state:** Agent is economically self-sufficient.

---

## 5. Features — Current (v1.2.0)

### Core Identity
- [x] Key generation and storage (~/.nostr/secret.key)
- [x] NIP-06 derivation from cocod mnemonic
- [x] Profile get/set (name, about, picture, banner, lud16)
- [x] NIP-05 lookup
- [x] `whoami` / `status` commands

### Social
- [x] Post (kind 1)
- [x] Reply with threading
- [x] React (kind 7)
- [x] Repost (kind 6)
- [x] Delete (kind 5)
- [x] Mentions feed
- [x] Home feed (from follows)
- [x] Show single note

### Connections
- [x] Follow/unfollow (kind 3)
- [x] Mute/unmute (kind 10000)
- [x] Bookmarks (kind 10003)
- [x] Relay list (NIP-65, kind 10002)

### Messaging
- [x] DMs — NIP-04 encrypted
- [x] Read DMs

### Channels & Badges
- [x] Create/post/read channels (NIP-28)
- [x] Badge definitions and awards (NIP-58)

### Payments
- [x] Zap invoice generation (NIP-57)
- [x] Wallet via cocod (Cashu + Lightning)
- [x] Lightning address via npubx.cash

### Current Issues
- [ ] **v1.2.0 duplicate check is flawed** — blocks legitimate threads, adds latency
- [ ] Some commands slow (2-5s relay latency)

---

## 6. Features — Planned

### Near-term (Next Release)
- [ ] Fix or revert duplicate reply check (pending design decision)
- [ ] Improve error messages for common failures

### Medium-term
- [ ] NIP-17 gift-wrapped DMs (better privacy)
- [ ] Image upload to nostr.build with NIP-98 auth
- [ ] Conversation threading awareness

### Long-term / Icebox
- [ ] NIP-46 Nostr Connect (bunker mode) — requires persistent websockets
- [ ] NIP-29 relay-based groups
- [ ] Full NWC wallet integration (currently deferred to cocod)

---

## 7. Features Out (Explicitly Not Doing)

| Feature | Reason |
|---------|--------|
| GUI/Web interface | CLI-first for agent use |
| Multi-account support | One identity per agent |
| Relay hosting | Out of scope; use existing relays |
| Full social client | Focused on agent needs, not human browsing |
| Complex duplicate detection | Over-engineered; process > tooling |

---

## 8. Technical Architecture

### Dependencies
- **nostr-tools:** Core Nostr protocol library
- **cocod:** Cashu wallet + Lightning via npubx.cash
- **Node.js 18+:** Runtime

### File Locations
```
~/.nostr/secret.key    # Nostr private key (hex)
~/.cocod/              # Wallet data + mnemonic
```

### Relay Strategy
Default relays (hardcoded, can be overridden via NIP-65):
- wss://relay.damus.io
- wss://nos.lol
- wss://relay.primal.net
- wss://relay.snort.social
- wss://relay.nostr.band
- wss://purplepag.es
- wss://nostr.wine
- wss://relay.nostr.net

### Security Considerations
- Private key stored in plaintext (user responsibility to secure)
- Mnemonic in cocod config (user must back up)
- No key ever displayed by default (user must explicitly request)

---

## 9. Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Relay downtime | Commands fail | Medium | Multiple relay fallbacks |
| Breaking API changes in nostr-tools | Build breaks | Low | Pin dependency versions |
| User loses mnemonic | Permanent identity loss | Medium | Prominent backup warnings |
| Accidental key exposure | Identity compromise | Low | Never log/display keys by default |

---

## 10. Dependencies

| Dependency | Owner | Status |
|------------|-------|--------|
| nostr-tools | fiatjaf | Stable, active |
| cocod | OpenClaw | Stable |
| npubx.cash | Third-party | Operational |
| nostr.build | Third-party | Operational |

---

## 11. Timeline / Roadmap

| Milestone | Target | Status |
|-----------|--------|--------|
| v1.0.0 — Initial release | 2026-02-06 | ✅ Complete |
| v1.1.0 — DMs fix | 2026-02-07 | ✅ Complete |
| v1.2.0 — Duplicate check (flawed) | 2026-02-07 | ⚠️ Needs revision |
| v1.2.1 or v1.3.0 — Fix/revert | TBD | Pending approval |
| v1.x — NIP-17 DMs | TBD | Planned |
| v2.0 — Image upload | TBD | Planned |

---

## 12. Open Issues

1. **Duplicate reply check:** Revert, revise, or remove? (PRD-001 pending)
2. **Version numbering:** Should fix be patch (1.2.1) or minor (1.3.0)?
3. **NIP-17 priority:** How important is gift-wrapped DM privacy?
4. **Testing strategy:** How to test before release? (Currently manual)

---

## 13. Q&A / Key Decisions

| Question | Decision | Date |
|----------|----------|------|
| Why cocod over direct NWC? | Simpler UX, self-contained, no external service deps | 2026-02-06 |
| Why nostr-tools over clawstr-cli? | General Nostr, not Clawstr-specific | 2026-02-06 |
| Why NIP-06 derivation? | Single mnemonic backs up wallet + identity | 2026-02-06 |
| Push to origin without approval? | **NO** — all pushes require approval | 2026-02-07 |

---

## 14. Approval

- [ ] **Shawn** — Product owner approval required before any development

---

*This is a living document. Updates require version bump and change history entry.*
