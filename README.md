# PostDaily for Claude Code

Draft, schedule and publish social media posts from Claude Code with
[PostDaily](https://www.postdaily.app) — Instagram, Facebook, TikTok, YouTube,
LinkedIn, X, Threads, Pinterest, Bluesky and Mastodon.

## Install

```bash
claude plugin marketplace add mehedihasan2810/postdaily-claude-plugin
claude plugin install postdaily@postdaily
```

Then, in Claude Code, run `/mcp`, choose `plugin:postdaily:postdaily` and
authenticate. PostDaily opens in your browser: pick the workspaces Claude Code
may use and what it can do (Full access, Drafts only or Read only). Change or
revoke it any time in PostDaily under **Settings → AI agents**.

You need a PostDaily account — every plan includes AI agent access.

## What you get

- **PostDaily's MCP server** (`https://mcp.postdaily.app/mcp`): up to 20 tools
  for channels, posts, the queue, media and analytics, plus prompts such as
  planning a week of posts.
- **Skills**
  - `posting` — drafts by default, one text per network, validation before
    saving, and a clear yes before anything goes out now.
  - `local-media` — attach an image, video or PDF from your machine by
    uploading it straight to PostDaily.
  - `release-posts` — turn your repository's recent changes into per-network
    drafts announcing a release.
- **A confirmation hook**: Claude Code asks you before a call publishes
  immediately, retries a failed post, deletes or cancels a post, or schedules
  a batch — even when PostDaily's tools are otherwise allowed.

## Try it

- "What's scheduled on my LinkedIn this week?"
- "Draft a post for Bluesky and LinkedIn about the new export feature."
- "Announce the v2.3 release."
- "Attach ./screenshots/dashboard.png and schedule it for tomorrow at 9am."

## Help

- [Connecting AI apps to PostDaily](https://www.postdaily.app/help/connect-ai-apps)
- support@postdaily.app

## Development

This repository is published from PostDaily's main codebase, where the
plugin is kept in step with the MCP server it wraps. To check it locally:

```bash
claude plugin validate --strict plugins/postdaily
claude plugin validate --strict .
claude --plugin-dir plugins/postdaily plugin details postdaily
```

The hook is plain `sh`; feed it a hook event to see its decision:

```bash
printf '%s' '{"tool_name":"mcp__plugin_postdaily_postdaily__create_post","tool_input":{"mode":"now","confirmPublish":true}}' \
  | sh plugins/postdaily/hooks/confirm-publish.sh
```

It prints `"permissionDecision":"ask"` for publish-now, retries, deletes,
cancels and batches, and nothing (proceed normally) for everything else.

## License

[MIT](./LICENSE)
