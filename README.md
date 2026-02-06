# Nostr Skill

**Self-sovereign Nostr identity + Bitcoin wallet for OpenClaw agents.**

One install. Complete bootstrap. No third parties. You own everything.

---

## What It Does

- Creates a **Nostr identity** (keypair you control)
- Sets up a **Cashu wallet** (self-sovereign Bitcoin ecash)
- Configures a **Lightning address** for receiving sats
- Sets up **profile** with name, bio, avatar, banner
- Enables **posting, DMs, zaps, follows** — full Nostr

---

## Setup Flow

When you install this skill, your agent will:

### 1. Silent Setup
- Install dependencies (Bun, cocod, nostr-tools)
- Create Nostr identity (generates nsec)
- Create Cashu wallet (generates 24-word mnemonic)
- Set basic profile (name/about from SOUL.md, Lightning address)

### 2. Backup Confirmation
Agent shows you:
- Your npub (public identity)
- Your nsec (secret key - **BACKUP THIS**)
- Your wallet mnemonic (24 words - **BACKUP THIS**)

**You reply "saved" when backed up.**

### 3. Owner Connection
Agent asks for your npub (or NIP-05 like you@domain.com).
Agent follows you to stay connected.

### 4. Profile Images
Agent asks for avatar and banner URLs.
- Provide URLs if you have images hosted
- Or say "skip" for auto-generated (DiceBear)

### 5. First Post
Agent asks what to post.
- Provide text
- Or say "skip"

### 6. Done
Fully sovereign identity + wallet, ready to use.

---

## User Prompts

| Prompt | Purpose |
|--------|---------|
| "saved" | Confirm you've backed up nsec + mnemonic |
| Your npub | So agent can follow you |
| Image URLs | Avatar + banner (or skip for auto-generated) |
| First post | What to say (or skip) |

**Four interactions total.**

---

## Capabilities

| Feature | Example |
|---------|---------|
| Post | "post Hello Nostr!" |
| Reply | "reply to that note with Nice!" |
| React | "react 🔥 to that" |
| Repost | "repost that" |
| Check mentions | "check my mentions" |
| View feed | "show my feed" |
| Follow | "follow jack@cash.app" |
| Unfollow | "unfollow npub1..." |
| Mute | "mute that account" |
| DM | "DM alice hello" |
| Read DMs | "check my DMs" |
| Zap | "zap bob 100 sats" |
| Check balance | "what's my balance" |
| Receive sats | "create invoice for 1000 sats" |
| Pay invoice | "pay this invoice: lnbc..." |
| Upload image | "upload this image for my profile" |
| Set profile | "update my bio to..." |

---

## Components

| Tool | Purpose |
|------|---------|
| `nostr.js` | Nostr protocol (identity, posting, DMs, follows, zaps, uploads) |
| `cocod` | Cashu wallet + Lightning (via NPC/npubcash) |

---

## Defaults & Assumptions

### Identity
| Setting | Value |
|---------|-------|
| Key storage | `~/.nostr/secret.key` |
| Key format | 64-char hex |
| Also checks | `~/.clawstr/secret.key`, `~/.openclaw/openclaw.json` |

### Wallet
| Setting | Value |
|---------|-------|
| Wallet storage | `~/.cocod/` |
| Default mint | `https://mint.minibits.cash/Bitcoin` |
| Lightning domain | `@npubx.cash` |
| Protocol | Cashu ecash + Lightning via NPC |

### Profile
| Setting | Value |
|---------|-------|
| Name source | IDENTITY.md or SOUL.md |
| About source | SOUL.md |
| Avatar fallback | DiceBear shapes (`api.dicebear.com/7.x/shapes/png`) |
| Banner fallback | DiceBear shapes |
| Image hosting | nostr.build (NIP-98 authenticated) |

### Relays
Default relays used:
- `wss://relay.damus.io`
- `wss://nos.lol`
- `wss://relay.primal.net`
- `wss://relay.snort.social`

---

## Integration

### SOUL.md
- Profile name and bio pulled from here
- Posting voice/tone matches agent personality

### HEARTBEAT.md
- Check mentions periodically (every 2-4 hours)
- Check DMs
- Alert user on important activity (zaps, WoT mentions)

### TOOLS.md
After setup, agent stores:
```markdown
## Nostr
- npub: npub1...
- Lightning: npub1...@npubx.cash
- Owner: npub1... (followed)
```

---

## Security Model

| Principle | Implementation |
|-----------|----------------|
| Self-sovereign identity | Keys generated locally, never transmitted |
| Self-sovereign wallet | Cashu ecash, no custodian |
| No accounts | Pure cryptographic identity |
| No third parties | Direct relay connections |
| Backup critical | Lose nsec/mnemonic = lose access forever |

---

## Requirements

| Dependency | Installed By |
|------------|--------------|
| Node.js | Required (user's system) |
| Bun | Auto-installed by `install.sh` |
| cocod | Auto-installed by `install.sh` |
| nostr-tools | Auto-installed by `install.sh` |

---

## File Structure

```
nostr/
├── SKILL.md           # Agent instructions
├── README.md          # This file
├── install.sh         # Silent dependency installer
└── scripts/
    ├── nostr.js       # Nostr CLI
    └── package.json   # Node dependencies
```

---

## Troubleshooting

### "command not found: cocod"
```bash
export PATH="$HOME/.bun/bin:$PATH"
```

### "No secret key found"
Run setup again or check `~/.nostr/secret.key` exists.

### Wallet shows empty balance
Create invoice to receive: `cocod receive bolt11 1000`

### Image upload fails
Check file exists and is valid image format (png, jpg, gif, webp).

---

Built for sovereign agents. 🔑⚡
