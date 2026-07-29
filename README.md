# Academic website — David J.P. O'Sullivan

A Quarto website template pre-populated from your UL Pure and Google Scholar profiles.

## Quick start

1. Install [Quarto](https://quarto.org/docs/get-started/) (if not already installed).
2. (Recommended) Install the academicons extension for the ORCID/Scholar icons:

   ```bash
   cd dosullivan-site
   quarto add schochastics/academicons
   ```

   If you skip this, replace the `{{< ai ... >}}` shortcodes in `_quarto.yml`
   and `index.qmd` with plain text links.
3. Preview locally:

   ```bash
   quarto preview
   ```

4. Render the final site to `_site/`:

   ```bash
   quarto render
   ```

## Things to fill in (marked with ← comments in the files)

- `assets/profile.jpg` — add your photo (you can save the one from your Pure profile).
- `_quarto.yml` — your site URL and GitHub username.
- `index.qmd` — education details; prune/extend the News section.
- `publications.qmd` — the remaining ~13 outputs from Pure (2014–2023), and
  verify the Dinkelberg et al. (2023) JASSS title.
- `teaching.qmd` — your actual module codes and descriptions.

## Deploying

The easiest free option is **GitHub Pages**:

```bash
quarto publish gh-pages
```

Quarto also supports Netlify, Quarto Pub, and university web hosting
(just upload the contents of `_site/`). Docs: https://quarto.org/docs/publishing/

## Optional upgrade: automated publications

Instead of maintaining `publications.qmd` by hand, you can export a BibTeX
file from Google Scholar (Profile → export) or Pure, save it as
`publications.bib`, and have Quarto render it automatically. Happy to set
that up if you prefer.
