---
name: local-media
description: Use when the user wants to attach a local file — an image, video or PDF on this machine, such as a screenshot, a rendered video or an export — to a PostDaily post.
---

# Attaching a local file to a PostDaily post

PostDaily can take a file straight from this machine: ask for a one-time
upload URL, PUT the bytes with curl, then confirm. Files reachable by a public
`https://` URL are simpler — pass that to `import_media` instead.

## Steps

1. Check the file exists and read its size and type:

   ```bash
   wc -c < "path/to/file"
   file --mime-type -b "path/to/file"
   ```

   Accepted types: `image/jpeg`, `image/png`, `image/webp`, `video/mp4`,
   `video/quicktime`, `video/webm` and `application/pdf`. Convert anything else
   first (for example a GIF or HEIC to PNG or MP4) and tell the user you did.

2. Call `create_media_upload` with the `workspaceId`, `filename`,
   `contentType` and `sizeBytes`. It returns `uploadUrl`, `headers`, a ready
   `curl` command and a `mediaId`. The URL works once and expires at
   `expiresAt`.

3. Run the returned `curl` command with `<path to …>` replaced by the file's
   real path, quoted. Keep every `-H` header exactly as given: the URL is
   signed for that content type and size. Do not print or log the upload URL
   anywhere else; it grants a write.

4. Call `complete_media_upload` with the `mediaId`. PostDaily checks the
   stored file has the size and type you declared, and returns it with its
   dimensions or duration. A mismatch means the wrong file or a changed file
   was sent — start again from step 1.

5. Attach it: `media: [{ "mediaId": "…", "altText": "…" }]` on `create_post`,
   `update_post` or `validate_post`. Write alt text for images from what the
   image actually shows — look at it first if you can.

## Before posting

Run `validate_post` with the media attached: each network has its own limits
on size, length, aspect ratio and how many files a post can carry, and the
check reports them per channel.
