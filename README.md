# mysli.network

Public launch-gate, support, privacy, terms, account deletion, contact, and accessibility site for MySLI.

This site is intentionally static and dependency-free so it can deploy cheaply on Netlify while the iOS app is still being prepared for public launch.

## Local Development

```bash
cd /Users/michealgiles/Documents/GitHub/mysli-network
npx serve public
```

Or open `public/index.html` directly in a browser.

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
