This file is use as a memo for _Markdown_ syntax

**Table of contents :**
- [1. Syntax](#1-syntax)
  - [1.1. Tutorials](#11-tutorials)
  - [1.2. Set a dropdown](#12-set-a-dropdown)
  - [1.3. Customize images](#13-customize-images)
  - [1.4. Add alerts](#14-add-alerts)
    - [1.4.1. Github](#141-github)
    - [1.4.2. Jekyll themes](#142-jekyll-themes)
      - [1.4.2.1. Just The Docs](#1421-just-the-docs)
- [2. Advice rules](#2-advice-rules)
  - [2.1. Links](#21-links)
- [3. Markdown editor](#3-markdown-editor)
  - [3.1. Plugin - Markdown All In One](#31-plugin---markdown-all-in-one)
    - [3.1.1. Presentation](#311-presentation)
    - [3.1.2. Convert to HTML](#312-convert-to-html)
  - [3.2. Plugin - Markdown PDF](#32-plugin---markdown-pdf)
    - [3.2.1. Settings](#321-settings)

# 1. Syntax
## 1.1. Tutorials
- [Basic syntax][markdown-syntax-basic] : headings, line breaks, text transformation, blockquotes, lists, images, links
- [Extended syntax][markdown-syntax-extended] : tables, code blocks, footnotes, task lists, emoji, highlight
- [Code blocks syntax][markdown-syntax-code] : list of supported languages and keywork to use when creating a block of code

## 1.2. Set a dropdown

<details>
<summary>How do I dropdown?</summary>
<br>
This is how you dropdown.
<br><br>
<pre>
&lt;details&gt;
&lt;summary&gt;How do I dropdown?&lt;&#47;summary&gt;
&lt;br&gt;
This is how you dropdown.
&lt;&#47;details&gt;
</pre>
</details>

> Syntax notes:
> - `<details>`: Define dropdown **wrapper** (can be _open_ by default by using `<details open>`)
> - `<summary>`: Define dropdown **title**  
> See [this tutorial][markdown-syntax-dropdown] for more complex dropdown scenario

## 1.3. Customize images

```markdown
<!-- Set custom size -->
![asset-img]{: width="100" }

<!-- Add links -->
[![asset-img]{: width="100" }][custom-links]

[asset-img]: myImage.png
[custom-links]: https://www.google.com/
```

## 1.4. Add alerts

Some platforms and themes extends markdown syntax allowing to provide alerts.

### 1.4.1. Github

Using those [alerts][alerts-syntax-github]:
```markdown
> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.
```

Will render:  

![alerts-render-github]

### 1.4.2. Jekyll themes
#### 1.4.2.1. Just The Docs

[Just The Docs][jekyll-theme-jtd] jekyll theme also use [alerts][alerts-syntax-jekyll-theme-jtd] (called _callouts_) :
```markdown
{: .note }
Useful information that users should know, even when skimming content.

{: .highlight }
Helpful advice for doing things better or more easily.

{: .important }
Key information users need to know to achieve their goal.

{: .warning }
Urgent info that needs immediate user attention to avoid problems.

{: .new }
This feature was just added in `v4.0.0`
```

Will render:  

![alerts-render-jekyll-theme-jtd]

# 2. Advice rules
## 2.1. Links

Don't put URL directly to your hypertext, use [linking to heading IDs instead][markdown-syntax-linking-heading-ids] instead:  
Example - Don't do:
```markdown
You can see markdown basic syntax at this [link](https://www.markdownguide.org/basic-syntax/)
```

{: .highlight }
> This will print :  
> You can see markdown basic syntax at this [link](https://www.markdownguide.org/basic-syntax/)

Example - do instead :
```markdown
You can see markdown basic syntax at this [link][markdown-syntax-basic]

<!-- AT BOTTOM OF YOUR FILE -->
<!-- Links for markdown syntax -->
[markdown-syntax-basic]: https://www.markdownguide.org/basic-syntax/
```

{: .highlight }
> This will print :  
> You can see markdown basic syntax at this [link][markdown-syntax-basic]

As you can see, result is exactly the same but markdown page is easier to maintain with heading IDs because all links are at the bottom of the page, so we don't have to go through the all page to update a broken link !  

# 3. Markdown editor

[Visual Studio Code][vscode] allow us to easily write markdown file.  
To preview markdown: open your markdown file and press `CTRL + SHIFT + v`.

More features can be added by using plugins:
- [Markdown All in One][vscode-md-all-in-one]
- [Markdown PDF][vscode-md-pdf]

> To use plugins options, use _VsCode control panel_ by pressiong: `CTRL + SHIFT + p`

## 3.1. Plugin - Markdown All In One
### 3.1.1. Presentation

This extension allow to:
- Add table of contents: Open control panel and search for `Create Table of Contents`
- Add number of sections: Open control panel and search for `Add/update sections numbers`
- Convert markdown file to HTML: Open control panel and search for `Print current document to HTML`
- And many more...

For more details, use [official documentation of the extension][vscode-md-all-in-one]

### 3.1.2. Convert to HTML

When exporting to HTML, I don't use generated stylesheets, I prefer to use [custom Github CSS][css-github-repository]. To use it:
- Disable stylesheet of the extension via: `markdown.pureHtml: true`
- Then modify generated HTML file to include custom CSS by adding this:
```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Filename</title>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.6.1/github-markdown-dark.min.css" integrity="sha512-mzPe5Bxap921sKCNI3lXEi5FxCue4M1Ei65ZVFi1UdCMnr4+BFOpBuWnfpJ8WLBxvyhf7z45Jsa5jWiseE57rg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <style>
            .markdown-body {
                box-sizing: border-box;
                min-width: 200px;
                max-width: 980px;
                margin: 0 auto;
                padding: 45px;
            }
        
            @media (max-width: 767px) {
                .markdown-body {
                    padding: 15px;
                }
            }
        </style>

    </head>
    <body class="markdown-body">
    <!-- Here will be the generated HTML -->
    </body>
</html>
```

> [!NOTE]
> CSS link is available via [the repository][css-github-repository] or via [CDNJS][css-github-cdnjs]

## 3.2. Plugin - Markdown PDF

This extension allow to export PDF and much more ! Please refer to [Markdown PDF documentation][vscode-md-pdf] for more details.  

### 3.2.1. Settings

Some useful settings can be customized:
- PDF options
  - `markdown-pdf.headerTemplate`:
    - Default value:

    ```html
    <div style="font-size: 9px; margin-left: 1cm;"> <span class='title'></span></div> <div style="font-size: 9px; margin-left: auto; margin-right: 1cm; ">%%ISO-DATE%%</div>
    ```
    - Custom value:

    ```html
    <div style="font-size: 9px; margin-left: 1cm;"> <span class='title'></span></div>
    ```
  - `markdown-pdf.footerTemplate`:
    - Default value:

    ```html
    <div style="font-size: 9px; margin: 0 auto;"> <span class='pageNumber'></span> / <span class='totalPages'></span></div>
    ```

When exporting to PDF, it can be useful to go to next page (to not have text cut), to do so, you can use:
```html
<div style="page-break-before:always"></div>
```

<!-- Links for markdown syntax -->
[css-github-repository]: https://github.com/sindresorhus/github-markdown-css
[css-github-cdnjs]: https://cdnjs.com/libraries/github-markdown-css

[markdown-syntax-basic]: https://www.markdownguide.org/basic-syntax/
[markdown-syntax-extended]: https://www.markdownguide.org/extended-syntax/
[markdown-syntax-linking-heading-ids]: https://www.markdownguide.org/extended-syntax/#linking-to-heading-ids
[markdown-syntax-code]: https://support.codebasehq.com/articles/tips-tricks/syntax-highlighting-in-markdown
[markdown-syntax-dropdown]: https://dev.to/asyraf/how-to-add-dropdown-in-markdown-o78

[alerts-syntax-github]: https://docs.github.com/fr/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts
[alerts-syntax-jekyll-theme-jtd]: https://just-the-docs.com/docs/ui-components/callouts/

[alerts-render-github]: alerts-rendered-github.png
[alerts-render-jekyll-theme-jtd]: alerts-rendered-jekyll-jtd.png

[jekyll-theme-jtd]: https://just-the-docs.com

<!-- Links for markdown editor -->
[vscode]: https://code.visualstudio.com/
[vscode-md-all-in-one]: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
[vscode-md-pdf]: https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf