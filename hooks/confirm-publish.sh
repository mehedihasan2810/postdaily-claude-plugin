#!/bin/sh
# PreToolUse hook for PostDaily's MCP tools: make Claude Code ask the person
# before a call that publishes immediately, removes a post, or schedules many
# posts at once. Everything else (drafts, reads, one scheduled post) passes
# through untouched. The server enforces its own confirmPublish rule too; this
# puts a human click in front of it even when the tool is otherwise allowed.
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

case "$tool" in
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
