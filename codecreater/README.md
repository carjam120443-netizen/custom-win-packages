# codecreater

A small Windows PowerShell command for quickly creating a basic HTML website.

## Usage

Run:

```text
codecreater
```

It asks where to save the website, then asks for a title, heading, and main text.

You can also provide a path directly:

```text
codecreater "C:\Users\carja\Desktop\mysite\index.html"
```

If the supplied path has no file extension, `index.html` is added automatically.

The generated file is UTF-8 and includes a responsive HTML/CSS starter page. PowerShell's `Set-Content` supports explicit UTF-8 encoding for file output.