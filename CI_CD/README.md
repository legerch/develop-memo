This file will resume multiple CI/CD _(continuous integration and continuous delivery/continuous deployment)_ configurations

# 1. How to deploy project documentation

For a project which use [Doxygen][doxygen-official] utility, it can be useful to be able to deploying it on a online website instead of building it locally.

## 1.1. Github actions

To deploy our generated documentation on a repository **Github Pages**, we can use plugin [doxygen-github-pages-action][gh-plugin-doxygen-deploy].

1. Create Github action workflow file inside `.github/workflows/`, for example with `doxygen-gh-pages.yml`:
```yaml
name: Deploy documentation on GitHub Pages

on:
  push:
    branches:
      - master

permissions:
  contents: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: DenverCoder1/doxygen-github-pages-action@v2.0.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          branch: gh-pages
          config_file: Doxyfile
```

> [!WARNING]
> `permissions` is required, otherwise new branch `gh-pages` will not be able to be created

> [!TIP]
> Plugin allow you to configure multiple properties, please refer to [plugin documentation][gh-plugin-doxygen-deploy].

2. You must configure your repository to deploy from the branch you push to. To do this:
   1. Go to the repository settings
   2. Click on `Pages`
   3. Under section `Build and deployment` and `Source`, choose the option `Deploy from a Branch`
   4. Configure the branch to deploy from (like `gh-pages`) and select your default index repository (like `/ (root)`)
   5. Click `Save`

3. Documentation should be generated at: `https://<owner-name>.github.io/<repository-name>/`

<!-- External links -->
[doxygen-official]: https://www.doxygen.nl/index.html

[gh-doc-actions]: https://docs.github.com/fr/actions
[gh-plugin-doxygen-deploy]: https://github.com/DenverCoder1/doxygen-github-pages-action