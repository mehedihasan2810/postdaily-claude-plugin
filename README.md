# PostDaily for Claude

Draft, schedule and publish social media posts with
[PostDaily](https://www.postdaily.app) — Instagram, Facebook, TikTok, YouTube,
X, Threads, Pinterest, Bluesky and Mastodon — in Claude on the web, the desktop
and mobile apps, Cowork and Claude Code. Ask in plain words, check a post
against each network's limits before it is saved, attach images and videos,
and turn release notes into posts. Publishing a post immediately always asks
for your confirmation first.

You need a PostDaily account with at least one connected social channel.

## Install and connect

- **Claude (web, desktop, mobile) and Cowork:** add PostDaily from the
  directory under **Customize → Plugins**, then open the plugin's
  **Connectors** tab and connect PostDaily.
- **Claude Code:** install it from the directory, or from this repository:

  ```bash
  claude plugin marketplace add mehedihasan2810/postdaily-claude-plugin
  claude plugin install postdaily@postdaily
  ```

  Then run `/mcp`, choose `plugin:postdaily:postdaily` and authenticate.

PostDaily opens in your browser: sign in, pick the workspaces Claude may use
and what it can do (Full access, Drafts only or Read only). Change or revoke
it any time in PostDaily under **Settings → AI agents**.

## What you get

- **PostDaily's MCP server** (`https://mcp.postdaily.app/mcp`): up to 20 tools
  for channels, posts, the queue, media and analytics, prompts such as
  planning a week of posts, and a post preview card in the conversation.
- **Skills**
  - `posting`: drafts by default, one text per network, a check before
    saving, and a clear yes before anything goes out now.
  - `local-media`: attach an image, video or PDF from your own device.
  - `release-posts`: turn release notes, or a repository's recent changes,
    into per-network drafts announcing a release.
- **A confirmation hook** (Claude Code and Cowork): Claude asks you before a
  call publishes immediately, retries a failed post, deletes or cancels a
  post, or schedules a batch, even when PostDaily's tools are otherwise
  allowed.

## What this plugin runs and sends

- **MCP server:** the only network destination is PostDaily's own server,
  `https://mcp.postdaily.app/mcp`, reached after you sign in with OAuth. It
  receives the requests Claude makes with PostDaily's tools and nothing else.
  The post preview card loads images only from PostDaily's media domains.
- **Hook:** `hooks/confirm-publish.sh` runs on your computer before PostDaily
  tool calls in Claude Code and Cowork. It reads the tool name and arguments
  it is given, prints a permission decision, and sends nothing anywhere. It
  uses only `sh`, `sed` and `grep`.
- **Skills:** instructions only. Where Claude can run commands, the
  `local-media` skill asks it to read a file's size and type (`wc`, `file`)
  and upload it with `curl` to the one-time URL PostDaily returns; elsewhere
  it gives you a PostDaily upload page instead. Where a repository is
  available, `release-posts` reads it with `git` and, when installed, `gh`;
  otherwise it works from release notes you paste. Claude asks before running
  commands under your usual permission settings.
- No telemetry, no credentials stored by the plugin, no other downloads.

## Try it

- "What's scheduled on my channels this week?"
- "Draft a post for Bluesky and Threads about the new export feature."
- "Announce the v2.3 release."
- "Attach this screenshot and schedule it for tomorrow at 9am."

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
