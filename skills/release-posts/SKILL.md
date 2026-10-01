---
name: release-posts
description: Use when the user wants to announce a release, launch, changelog, shipped feature or merged work on social media — turns the release notes or the repository's recent changes into per-network PostDaily drafts.
argument-hint: "[version, tag or range — defaults to changes since the last tag]"
---

# Turning a release into social posts

Write posts about what actually shipped, from the release notes or the
repository itself, and save them to PostDaily as drafts for the user to review.

## 1. Find what shipped

If you cannot read a repository (in a chat on the web or a phone, for
example), ask the user to paste the release notes, the changelog section or a
list of what shipped, and work only from that.

If you can, use the range the user gave. Otherwise take everything since the
latest tag:

```bash
git describe --tags --abbrev=0
git log --no-merges --pretty='%h %s' <last-tag>..HEAD
```

Also read, when present: the matching `CHANGELOG.md` section, release notes
(`gh release view <tag>`), and the titles and descriptions of merged pull
requests (`gh pr list --state merged --search "merged:>=<date>"`). Skip
chores, refactors, dependency bumps and internal fixes unless users would
notice them.

## 2. Pick the story

Choose the one to three changes a user of the product would care about and
say what each lets them do, not how it was built. Never invent a feature,
number, quote or customer; if the notes or the repository don't say it, leave
it out.
Ask the user for a link (release notes, docs, blog post) if there is none.

## 3. Write for each network

Call `list_channels` and write only for the channels the user wants:

- **Facebook**: a short story of the problem and what changed, 3–5 short
  paragraphs, one link at the end.
- **X, Threads, Bluesky, Mastodon**: one punchy post within the limit, or a
  short `thread` (2–4 parts) when there is more than one change.
- **Instagram, TikTok, YouTube, Pinterest** need an image or video. Offer to
  attach a screenshot or demo clip (see the `local-media` skill) rather than
  posting text only.

Match the tone of the project's README and past posts (`list_posts` shows
recent ones). Put the per-network texts in `channelSettings`.

## 4. Check and save as drafts

Run `validate_post`, fix what it reports, then `create_post` with
`mode: "draft"` and an `idempotencyKey`. Show the user each draft and its
link. Schedule or publish only if they ask — see the `posting` skill.
