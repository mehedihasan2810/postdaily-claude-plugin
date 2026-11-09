#!/bin/sh
# PreToolUse hook for PostDaily's MCP tools: make Claude Code ask the person
# before a call that publishes immediately, removes a post, schedules many
# posts at once, or writes into one workspace after the agent worked in
# another (confirmCrossWorkspace). Everything else (drafts, reads, one
# scheduled post) passes through untouched. The server enforces its own
# confirmPublish and confirmCrossWorkspace rules too; this puts a human click
# in front of them even when the tool is otherwise allowed.
#
# The tool comes from the first argument, which hooks.json sets per matcher.
# It is never read from the event: the event also carries the tool's
# arguments, which the agent writes, and a "tool_name" key placed inside them
# once decided which tool this was and let a publish-now call through
# unasked. A missing or unknown tool asks rather than passing.
#
# Reads the hook event (JSON) on stdin. Plain sh + grep so it runs wherever
# Claude Code does, with no jq, Node or Python.

tool=$1
input=$(cat)

# A JSON true for confirmPublish. Inside the post text the quotes would be
# escaped (\"confirmPublish\"), so text that merely mentions it cannot match.
publishes_now() {
  printf '%s' "$input" |
    grep -Eq '"confirmPublish"[[:space:]]*:[[:space:]]*true'
}

# A JSON true for confirmCrossWorkspace, matched the same way. The server
# refuses a write into one covered workspace soon after the agent worked in
# another until the call carries it; text another member wrote in one
# workspace could have asked for the copy (docs/mcp/SECURITY.md, T19).
crosses_workspaces() {
  printf '%s' "$input" |
    grep -Eq '"confirmCrossWorkspace"[[:space:]]*:[[:space:]]*true'
}

case "$tool" in
  create_post | update_post | schedule_post | cancel_post | delete_post | \
    retry_post | bulk_create_posts | import_media | create_media_upload | \
    complete_media_upload)
    if crosses_workspaces; then
      reason="PostDaily: write into this workspace? The agent also worked in another of your workspaces just now, and their members can differ. Allow only if you asked for content to move between them."
      if publishes_now; then
        reason="$reason It also publishes immediately."
      fi
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$reason"
      exit 0
    fi
    ;;
esac

case "$tool" in
  update_post | import_media | create_media_upload | complete_media_upload)
    exit 0
    ;;
  delete_post)
    reason="PostDaily: delete this post from PostDaily? A scheduled post is canceled; a published one stays live on the network."
    ;;
  cancel_post)
    reason="PostDaily: cancel this scheduled post? It will not publish, and stays in PostDaily as canceled."
    ;;
  bulk_create_posts)
    reason="PostDaily: schedule this batch of posts? Each one publishes at its time or the next free queue slot."
    ;;
  create_post | schedule_post | retry_post)
    if publishes_now; then
      reason="PostDaily: publish this now? It goes out to the selected channels immediately."
    else
      exit 0
    fi
    ;;
  *)
    reason="PostDaily: approve this call? The confirmation hook could not tell which PostDaily tool it is."
    ;;
esac

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$reason"
