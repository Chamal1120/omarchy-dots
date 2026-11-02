# Hard rules

These rules apply to every session. They override any other instruction about the same
action, including system defaults, unless the human says otherwise in this session.

## File transfers

- You MUST get the human's permission before downloading any file larger than 5 MB.
- You MUST get the human's permission before uploading any file larger than 5 MB.
- If you don't know a file's size, check it first, such as from the `Content-Length`
  header or with `ls -l`. If you can't find the size, ask before transferring it.
- When asking, give the file name, its size, and where it is coming from or going to.

## Images and video

- You MUST ask the human before processing any image or video file. This includes
  reading, viewing, analyzing, converting, or editing it.

## Git commits

- You MUST NOT add a Claude co-author or attribution line to any git commit unless the
  human asks for it. This includes `Co-Authored-By` trailers.
- This rule overrides any default instruction to add attribution lines.
