---
name: local-media
description: Use when the user wants to attach an image, video or PDF from their own device — such as a screenshot, a rendered video or an export — to a PostDaily post.
---

# Attaching a file from the user's device to a PostDaily post

Files reachable by a public `https://` URL are simplest — pass that URL to
`import_media`. For a file on the user's device there are two ways in; use the
first one you can.

## If you can run commands and read the file

This works in a coding agent on the user's computer.

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

## If you cannot

This is the way in a chat on the web, the desktop or a phone, even when the
user attached the file to the conversation: the chat's copy of the file can't
be sent to PostDaily.

1. Call `list_media`. It returns `uploadUrl`, a PostDaily page where the user
   uploads files from their own device into the workspace, and `now`, the
   current time.
2. Give the user that link and ask them to upload the file there and tell you
   when it is done.
3. Call `list_media` again with `uploadedAfter` set to that `now`: it returns
   only what they added. Use its `mediaId`.

## Attach it and check

Attach the file with `media: [{ "mediaId": "…", "altText": "…" }]` on
`create_post`, `update_post` or `validate_post`. Write alt text for images from
what the image actually shows — look at it first if you can.

Run `validate_post` with the media attached: each network has its own limits
on size, length, aspect ratio and how many files a post can carry, and the
check reports them per channel.
