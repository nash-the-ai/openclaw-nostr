# Changelog

All notable changes to the Nostr skill.

## [1.1.0] - 2026-02-07

### Fixed
- DMs command broken: `pool.querySync` takes single filter, not array. Now queries sent/received separately and combines results.

## [1.0.0] - 2026-02-06

### Added
- Initial release
- Social: post, reply, react, repost, delete
- Connections: follow, unfollow, mute, unmute
- DMs: NIP-04 encrypted direct messages
- Bookmarks: bookmark, unbookmark, list
- Relays: NIP-65 relay list management
- Channels: NIP-28 public channels
- Badges: NIP-58 badge definitions and awards
- Zaps: NIP-57 zap invoice generation
- Wallet: cocod integration for Cashu + Lightning
- Identity: NIP-06 key derivation from wallet mnemonic
