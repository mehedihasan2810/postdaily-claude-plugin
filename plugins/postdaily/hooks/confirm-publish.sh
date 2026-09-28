#!/bin/sh
# PreToolUse hook for PostDaily's MCP tools: make Claude Code ask the person
# before a call that publishes immediately, removes a post, or schedules many
# posts at once. Everything else (drafts, reads, one scheduled post) passes
# through untouched. The server enforces its own confirmPublish rule too; this
# puts a human click in front of it even when the tool is otherwise allowed.
#
# Reads the hook event (JSON) on stdin. Plain sh + sed + grep so it runs
# wherever Claude Code does, with no jq, Node or Python.

input=$(cat)

tool=$(printf '%s' "$input" |
  sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
  head -n 1)

# A JSON true for confirmPublish. Inside the post text the quotes would be
# escaped (\"confirmPublish\"), so text that merely mentions it cannot match.
publishes_now() {
  printf '%s' "$input" |
    grep -Eq '"confirmPublish"[[:space:]]*:[[:space:]]*true'
}

case "$tool" in
  *__delete_post)
    reason="PostDaily: delete this post from PostDaily? A scheduled post is canceled; a published one stays live on the network."
    ;;
  *__cancel_post)
    reason="PostDaily: cancel this scheduled post? It will not publish, and stays in PostDaily as canceled."
    ;;
  *__bulk_create_posts)
    reason="PostDaily: schedule this batch of posts? Each one publishes at its time or the next free queue slot."
    ;;
  *__create_post | *__schedule_post | *__retry_post)
    if publishes_now; then
      reason="PostDaily: publish this now? It goes out to the selected channels immediately."
    else
      exit 0
    fi
    ;;
  *)
    exit 0
    ;;
esac

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$reason"
