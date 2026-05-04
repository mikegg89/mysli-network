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

## Smoke Checks

Check required App Store/support routes and public launch markers directly from files:

```bash
cd /Users/michealgiles/Documents/GitHub/mysli-network
ruby scripts/check-public-routes.rb
```

Check a running local server:

```bash
cd /Users/michealgiles/Documents/GitHub/mysli-network
ruby -run -e httpd public -p 4187
ruby scripts/check-public-routes.rb http://127.0.0.1:4187
```

After Netlify DNS is live, check production:

```bash
ruby scripts/check-public-routes.rb https://mysli.network
```

If this reports a Namecheap parking page, the domain is still pointed at Namecheap parking instead of Netlify. In Namecheap or Netlify DNS, finish the Netlify custom-domain setup, remove parking records, and point:

- Apex `mysli.network` to the Netlify-provided apex record or Netlify DNS.
- `www.mysli.network` to the Netlify-provided `CNAME`.

Then rerun the smoke check after DNS propagation.

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
- Serve `/.well-known/apple-app-site-association` with `Content-Type: application/json`

## Required Routes

- `/`
- `/privacy/`
- `/terms/`
- `/support/`
- `/account-deletion/`
- `/contact/`
- `/accessibility/`
- `/.well-known/apple-app-site-association`

## Apple Universal Links

The static association file at `public/.well-known/apple-app-site-association` connects `mysli.network` to the production and staging iOS bundle IDs:

- `SW9DHVDGY8.mysli.network.app`
- `SW9DHVDGY8.mysli.network.app.staging`

It currently allows app handoff for corporate QR payer links, identity verification returns, interpreter referrals, and Stripe Connect returns:

- `/qr*`
- `/corporate/*`
- `/payer/*`
- `/identity-verification*`
- `/interpreter/referral*`
- `/stripe-connect*`

## Launch Notes

The copy is public-safe placeholder language for the app launch surface. Privacy Policy and Terms should be reviewed by counsel before App Store production release, especially before regulated medical/corporate claims.
