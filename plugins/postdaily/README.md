# PostDaily for Claude Code

Draft, schedule and publish social media posts from Claude Code with
[PostDaily](https://www.postdaily.app) — Instagram, Facebook, TikTok, YouTube,
LinkedIn, X, Threads, Pinterest, Bluesky and Mastodon.

## What it adds

- **The PostDaily MCP server** (`https://mcp.postdaily.app/mcp`): up to 20
  tools, depending on the access level you grant, for channels, posts, the
  queue, media and analytics, plus prompts such as planning a week of posts. You sign in with your PostDaily account; no key
  to copy.
- **Skills**
  - `posting` — how to draft, check, schedule and publish well: drafts by
    default, one text per network, validation before saving, and a clear yes
    before anything goes out now.
  - `local-media` — attach an image, video or PDF from this machine by
    uploading it straight to PostDaily.
  - `release-posts` — turn the repository's recent changes into per-network
    drafts announcing a release.
- **A confirmation hook**: Claude Code asks you before a call publishes
  immediately, retries a failed post, deletes or cancels a post, or schedules
  a batch — even when PostDaily's tools are otherwise allowed.

## Install

```bash
claude plugin marketplace add mehedihasan2810/postdaily-claude-plugin
claude plugin install postdaily@postdaily
```

## Sign in

After installing, run `/mcp`, choose `plugin:postdaily:postdaily` and
authenticate. PostDaily opens in your browser: pick the workspaces Claude Code
may use and an access level (Full access, Drafts only or Read only). Change
or revoke it any time in PostDaily under **Settings → AI agents**.

## Try it

- "What's scheduled on my LinkedIn this week?"
- "Draft a post for Bluesky and LinkedIn about the new export feature."
- "Announce the v2.3 release." (uses `release-posts`)
- "Attach ./screenshots/dashboard.png and schedule it for tomorrow at 9am."

## Help

[Connecting AI apps to PostDaily](https://www.postdaily.app/help/connect-ai-apps)
· support@postdaily.app
