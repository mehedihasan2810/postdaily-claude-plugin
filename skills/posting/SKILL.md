---
name: posting
description: Use when the user wants to write, draft, schedule, publish, reschedule, cancel or check social media posts with PostDaily (Instagram, Facebook, TikTok, YouTube, LinkedIn, X, Threads, Pinterest, Bluesky, Mastodon), or asks about their PostDaily queue, channels or analytics.
---

# Posting with PostDaily

PostDaily's tools come from the `postdaily` MCP server this plugin adds. If
they are not available yet, the user has not signed in: ask them to run
`/mcp`, choose postdaily and authenticate. PostDaily opens in the browser to
choose workspaces and an access level; after that the tools just work.

## Before writing anything

1. Call `list_workspaces`, then `list_channels`. Never invent ids. A channel
   can also be named by network (`linkedin`) or `@handle`; if a name matches
   more than one channel the tool returns the candidates — ask which one.
2. Pinterest needs a board and TikTok a privacy level the account allows:
   call `get_channel_options` for those channels before setting options.
3. Read `postdaily://guide/networks` when you are unsure what a network takes
   (length limits, media rules, what a first comment does).

## Writing

- Write for each network rather than pasting one text everywhere. Put the
  per-network versions in `channelSettings` (`{ channel, text, options }`);
  `text` is the default for the rest.
- For X, Threads, Bluesky and Mastodon, a long post can be a `thread` of parts
  instead of one text.
- Run `validate_post` on the finished post. It checks every channel's rules
  without saving anything.

## Saving, scheduling and publishing

- **Default to a draft** (`mode: "draft"`). Schedule only when the user asked
  for it: `mode: "queue"` for each channel's next free slot, or
  `mode: "scheduled"` with `scheduledAt`. A time without an offset is read in
  the workspace's timezone — say which timezone you used.
- **Publishing right now** (`mode: "now"`) and `retry_post` need
  `confirmPublish: true`. Before sending it, show the exact text, media and
  channels and get a clear yes. The plugin also asks the user in Claude Code
  before the call goes out.
- If a result has `outcome: "needs_confirmation"` because of warnings, show the
  warnings, and only re-send with `confirmWarnings: true` if the user agrees.
- Send an `idempotencyKey` (a fresh UUID) with every write, and reuse the same
  key if you retry the same call, so a retry can never post twice.
- A post to several channels becomes one post per channel; report each one.

## After saving

- Give the user what the tool returned: the post ids, the scheduled times and
  any link into PostDaily, so they can review it there.
- To move a scheduled post, use `schedule_post` with a new time. To take one
  back to drafts, `schedule_post` with `mode: "draft"`. `cancel_post` and
  `delete_post` need the user's go-ahead first.
- For a failed post, call `get_post` for the network's real error before
  suggesting a fix. If a channel needs reconnecting or a plan limit was hit,
  pass on the link from the error — that is fixed in PostDaily, not here.

## Access levels

A connection is Full access, Drafts only or Read only, and only sees the tools
its level allows. If a tool you need is missing, tell the user to reconnect
with a higher level (run `/mcp`, choose postdaily, and sign in again).
