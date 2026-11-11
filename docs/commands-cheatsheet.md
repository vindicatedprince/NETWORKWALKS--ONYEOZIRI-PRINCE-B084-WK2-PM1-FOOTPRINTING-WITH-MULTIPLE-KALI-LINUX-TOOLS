# Commands cheat sheet · Week 2

Everything below was used in the report. Run these only against systems you own or have written permission to test.

## Phase 1 · Footprinting (Kali Linux)

| Command | What it does | What to look for |
|---|---|---|
| `whois example.com` | Queries domain registration data | Registrar, created / expiry dates, name servers, status locks, DNSSEC |
| `whatweb example.com` | Fingerprints web technology | Server, CMS + version, plugins, JS libraries, e-mail addresses, redirects |
| `nslookup example.com` | Resolves a name to an IP via your resolver | The A record; "non-authoritative" means the answer came from a cache |
| `curl -I https://example.com` | Fetches only the HTTP response headers | `server`, `link`, `set-cookie` flags, and missing security headers |
| `wafw00f example.com` | Detects a web application firewall | WAF vendor name and the number of requests it needed |
| `dnsrecon -d example.com` | Enumerates DNS records | NS, SOA, MX, A, TXT/SPF, SRV, DNSSEC status, name-server software version |

## Phase 2 · Network scanning

| Command | What it does | Notes |
|---|---|---|
| `nmap -sn 192.168.1.0/24` | Ping sweep: finds live hosts, no port scan | On a local segment Nmap uses ARP, so MAC addresses appear |
| `nmap -sn 192.168.1.0/24 -oA sweep-01` | Same, saving `.nmap`, `.gnmap` and `.xml` | Keeps a baseline for later |
| `ndiff sweep-01.xml sweep-02.xml` | Compares two scans | Spot new or missing devices over time |
| Zenmap → **Topology** tab | Draws the hosts around the scanner | Green = "fewer than 3 open ports", which is meaningless after a ping-only scan |

## Reading a MAC address

The second-lowest bit of the **first byte** is the *locally administered* bit.

| First byte | Binary | Bit | Meaning |
|---|---|---|---|
| `88`, `20`, `3C`, `DC` | `…00` in the lowest two bits | 0 | Factory-assigned, so vendor lookup works |
| `66`, `1E`, `FE` | `…10` in the lowest two bits | 1 | Software-assigned (often a phone's private Wi-Fi address), so vendor lookup fails |

## Sample Apache security headers

```apache
# .htaccess or virtual host · requires mod_headers
Header always set Strict-Transport-Security "max-age=31536000"
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "SAMEORIGIN"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
```

Roll HSTS out gradually, and add `includeSubDomains` / `preload` only after every subdomain works over HTTPS.
