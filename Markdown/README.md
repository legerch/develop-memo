This file is use as a memo for _Markdown_ syntax

**Table of contents :**
- [1. Syntax](#1-syntax)
  - [1.1. Tutorials](#11-tutorials)
  - [1.2. Set a dropdown](#12-set-a-dropdown)
- [2. Advice rules](#2-advice-rules)
  - [2.1. Links](#21-links)
- [3. Markdown editor](#3-markdown-editor)
  - [3.1. Plugin - Markdown All In One](#31-plugin---markdown-all-in-one)
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

This extension allow to:
- Add table of contents: Open control panel and search for `Create Table of Contents`
- Add number of sections: Open control panel and search for `Add/update sections numbers`
- Convert markdown file to HTML: Open control panel and search for `Print current document to HTML`
- And many more...

For more details, use [official documentation of the extension][vscode-md-all-in-one]

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
[markdown-syntax-basic]: https://www.markdownguide.org/basic-syntax/
[markdown-syntax-extended]: https://www.markdownguide.org/extended-syntax/
[markdown-syntax-linking-heading-ids]: https://www.markdownguide.org/extended-syntax/#linking-to-heading-ids
[markdown-syntax-code]: https://support.codebasehq.com/articles/tips-tricks/syntax-highlighting-in-markdown
[markdown-syntax-dropdown]: https://dev.to/asyraf/how-to-add-dropdown-in-markdown-o78

<!-- Links for markdown editor -->
[vscode]: https://code.visualstudio.com/
[vscode-md-all-in-one]: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
[vscode-md-pdf]: https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf