# mysli.network

Public launch-gate, support, privacy, terms, account deletion, contact, and accessibility site for MySLI.

This site is intentionally static and dependency-free so it can deploy cheaply on Netlify while the iOS app is still being prepared for public launch.

## Local Development

Use the built-in macOS Ruby server so local preview does not depend on npm or global npm cache permissions:

```bash
cd /Users/michealgiles/Documents/GitHub/mysli-network
ruby -run -e httpd public -p 4187
```

Then open:

```text
http://127.0.0.1:4187
```

You can also open `public/index.html` directly in a browser.

If you prefer `npx serve`, use a project-local npm cache to avoid root-owned files in `~/.npm`:

```bash
cd /Users/michealgiles/Documents/GitHub/mysli-network
npm_config_cache=.npm-cache npx serve public
```

To permanently repair the global npm cache on this Mac:

```bash
sudo chown -R "$(id -u):$(id -g)" "$HOME/.npm"
```

## Netlify

- Base directory: repo root
- Build command: leave blank
- Publish directory: `public`
- Production domain: `mysli.network`
- Redirect `www.mysli.network` to apex

## Required Routes

- `/`
- `/privacy/`
- `/terms/`
- `/support/`
- `/account-deletion/`
- `/contact/`
- `/accessibility/`

## Launch Notes

The copy is public-safe placeholder language for the app launch surface. Privacy Policy and Terms should be reviewed by counsel before App Store production release, especially before regulated medical/corporate claims.
