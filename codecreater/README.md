# codecreater

Create an HTML website from supplied HTML code or interactively.

## Usage

Interactive:

```
codecreater
```

Then paste HTML line-by-line and enter `END` on its own line.

Supply HTML directly:

```
codecreater "<html><h1>Hello world</h1></html>"
```

The command then asks where to save the website and for a title.

### Automatic formatting

If HTML is supplied on one line, codecreater automatically detects common HTML tags, wraps them onto separate lines, and adds indentation.

For example:

```
codecreater "<html><body><h1>Hello</h1><p>Test</p></body></html>"
```

becomes a readable multi-line HTML file.

If the supplied HTML does not contain a `<title>`, codecreater adds one using the title you enter.

Files are written as UTF-8.
