# PostDaily for Claude Code

Draft, schedule and publish social media posts from Claude Code with
[PostDaily](https://www.postdaily.app) — Instagram, Facebook, TikTok, YouTube,
LinkedIn, X, Threads, Pinterest, Bluesky and Mastodon. Ask in plain words,
check a post against every network's rules before it is saved, upload images
and videos from your computer, and turn a release into posts, with a
confirmation before anything is published, deleted or canceled.

You need a PostDaily account — every plan includes AI agent access.

## Install

```bash
claude plugin marketplace add mehedihasan2810/postdaily-claude-plugin
claude plugin install postdaily@postdaily
```

Then, in Claude Code, run `/mcp`, choose `plugin:postdaily:postdaily` and
authenticate. PostDaily opens in your browser: pick the workspaces Claude Code
may use and what it can do (Full access, Drafts only or Read only). Change or
revoke it any time in PostDaily under **Settings → AI agents**.

## What you get

- **PostDaily's MCP server** (`https://mcp.postdaily.app/mcp`): up to 20 tools
  for channels, posts, the queue, media and analytics, plus prompts such as
  planning a week of posts.
- **Skills**
  - `posting` — drafts by default, one text per network, validation before
    saving, and a clear yes before anything goes out now.
  - `local-media` — attach an image, video or PDF from your computer by
    uploading it straight to PostDaily.
  - `release-posts` — turn your repository's recent changes into per-network
    drafts announcing a release.
- **A confirmation hook**: Claude Code asks you before a call publishes
  immediately, retries a failed post, deletes or cancels a post, or schedules
  a batch — even when PostDaily's tools are otherwise allowed.

## What this plugin runs and sends

- **MCP server:** the only network destination is PostDaily's own server,
  `https://mcp.postdaily.app/mcp`, reached after you sign in with OAuth. It
  receives the requests Claude makes with PostDaily's tools and nothing else.
- **Hook:** `hooks/confirm-publish.sh` runs locally before PostDaily tool
  calls. It reads the tool name and arguments Claude Code passes it, prints a
  permission decision, and sends nothing anywhere. It uses only `sh`, `sed`
  and `grep`.
- **Skills:** instructions only. The `local-media` skill asks Claude to read a
  file's size and type (`wc`, `file`) and upload it with `curl` to the
  one-time URL PostDaily returns; `release-posts` reads your repository with
  `git` and, when available, `gh`. Claude Code asks before running those
  commands under your usual permission settings.
- No telemetry, no credentials stored by the plugin, no other downloads.

## Try it

- "What's scheduled on my LinkedIn this week?"
- "Draft a post for Bluesky and LinkedIn about the new export feature."
- "Announce the v2.3 release."
- "Attach ./screenshots/dashboard.png and schedule it for tomorrow at 9am."

## Help and privacy

- [Connecting AI apps to PostDaily](https://www.postdaily.app/help/connect-ai-apps)
- [Privacy policy](https://www.postdaily.app/privacy) (section 6 covers AI
  apps you connect)
- support@postdaily.app

## Development

This repository is published from PostDaily's main codebase, where the
plugin is kept in step with the MCP server it wraps. The repository root is
both the plugin (`.claude-plugin/plugin.json`) and a one-plugin marketplace
(`.claude-plugin/marketplace.json`). To check it:

```bash
claude plugin validate --strict .
claude --plugin-dir . plugin details postdaily
```

Feed the hook an event to see its decision:

```bash
printf '%s' '{"tool_name":"mcp__plugin_postdaily_postdaily__create_post","tool_input":{"mode":"now","confirmPublish":true}}' \
  | sh hooks/confirm-publish.sh
```

It prints `"permissionDecision":"ask"` for publish-now, retries, deletes,
cancels and batches, and nothing (proceed normally) for everything else.

## License

[MIT](./LICENSE)
