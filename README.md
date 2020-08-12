# acme-lego-cron

[![github-actions](https://github.com/brahma-dev/acme-lego-cron/workflows/build/badge.svg)](https://github.com/brahma-dev/acme-lego-cron/actions)

Dockerized [Lego](https://go-acme.github.io/lego/) with cron. Caters to DNS ACME challenge; other challenges can be worked out using `LEGO_ARGS`.

## Environment variables

Environment variables are used to control various steps of the automation process.

## Lego

| Name | Default value | Description | Corresponds to `lego` argument |
|:-------:|:---------------:|:---------:|:---------:|
| `STAGING` | `0` |  Whether to use production or staging LetsEncrypt endpoint. 0 for production, 1 for staging
| `KEY_TYPE` | `ec384` | Type of key. | `--key-type`
| `DOMAINS` | `""` | Domains (delimited by ';' ) | `--domains`, `-d`
| `EMAIL_ADDRESS` | `""` | Email used for registration and recovery contact. | `--email`, `-m`
| `PROVIDER` | `""` | DNS Provider. Valid values are: `acmedns`, `alidns`, `arvancloud`, `auroradns`, `autodns`, `azure`, `bindman`, `bluecat`, `checkdomain`, `clouddns`, `cloudflare`, `cloudns`, `cloudxns`, `conoha`, `constellix`, `desec`, `designate`, `digitalocean`, `dnsimple`, `dnsmadeeasy`, `dnspod`, `dode`, `dreamhost`, `duckdns`, `dyn`, `dynu`, `easydns`, `edgedns`, `exec`, `exoscale`, `fastdns`, `gandi`, `gandiv5`, `gcloud`, `glesys`, `godaddy`, `hetzner`, `hostingde`, `httpreq`, `iij`, `internal`, `inwx`, `joker`, `lightsail`, `linode`, `linodev4`, `liquidweb`, `luadns`, `mydnsjp`, `mythicbeasts`, `namecheap`, `namedotcom`, `namesilo`, `netcup`, `netlify`, `nifcloud`, `ns1`, `oraclecloud`, `otc`, `ovh`, `pdns`, `rackspace`, `regru`, `rfc2136`, `rimuhosting`, `route53`, `sakuracloud`, `scaleway`, `selectel`, `servercow`, `stackpath`, `transip`, `vegadns`, `versio`, `vscale`, `vultr`, `yandex`, `zoneee`, `zonomi`  | `--dns`
| `DNS_TIMEOUT` | `10` | Set the DNS timeout value to a specific value in seconds. | `--dns-timeout`.
| `LEGO_ARGS` | `""` | Send arguments directly to lego, e.g. `"--dns.disable-cp"` or `"--dns.resolvers 1.1.1.1"` |

--------------------

## Examples

This example get one certificate for `*.example.com` and `example.com` using cloudflare dns :

- Use staging endpoint during development.
- You can share the same volume `letsencrypt` with other machines.

```yaml
version: "3"
services:
  lego:
    image: brahmadev/acme-lego-cron:latest
    environment:
      STAGING: 1
      DOMAINS: "example.com;*.example.com"
      EMAIL_ADDRESS: user@example.com
      CLOUDFLARE_DNS_API_TOKEN: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      PROVIDER: cloudflare
      LEGO_ARGS: "--dns.disable-cp --dns.resolvers 1.1.1.1"
    volumes:
      - "letsencrypt:/letsencrypt"
```
