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
| `PROVIDER` | `""` | DNS Provider. Valid values are: `edgedns`,`alidns`,`allinkl`,`lightsail`,`route53`,<br/>`arvancloud`,`auroradns`,`autodns`,`azure`,`azuredns`,<br/>`bindman`,`bluecat`,`brandit`,`bunny`,`checkdomain`,<br/>`civo`,`cloudru`,`clouddns`,`cloudflare`,`cloudns`,<br/>`cloudxns`,`conoha`,`constellix`,`cpanel`,`derak`,<br/>`desec`,`designate`,`digitalocean`,`dnsmadeeasy`,`dnshomede`,<br/>`dnsimple`,`dnspod`,`dode`,`domeneshop`,`dreamhost`,<br/>`duckdns`,`dyn`,`dynu`,`easydns`,`efficientip`,<br/>`epik`,`exoscale`,`exec`,`freemyip`,`gcore`,<br/>`gandi`,`gandiv5`,`glesys`,`godaddy`,`gcloud`,<br/>`googledomains`,`hetzner`,`hostingde`,`hosttech`,<br/>`httpreq`,`httpnet`,`hurricane`,`hyperone`,`ibmcloud`,<br/>`iijdpf`,`infoblox`,`infomaniak`,`iij`,`internetbs`,<br/>`inwx`,`ionos`,`ipv64`,`iwantmyname`,`joker`,<br/>`acme-dns`,`liara`,`linode`,`liquidweb`,`loopia`,<br/>`luadns`,`mailinabox`,`manual`,`metaname`,`mydnsjp`,<br/>`mythicbeasts`,`namedotcom`,`namecheap`,`namesilo`,`nearlyfreespeech`,<br/>`netcup`,`netlify`,`nicmanager`,`nifcloud`,`njalla`,<br/>`nodion`,`ns1`,`otc`,`oraclecloud`,`ovh`,<br/>`plesk`,`porkbun`,`pdns`,`rackspace`,`rcodezero`,<br/>`regru`,`rfc2136`,`rimuhosting`,`sakuracloud`,`scaleway`,<br/>`selectel`,`servercow`,`shellrent`,`simply`,`sonic`,<br/>`stackpath`,`tencentcloud`,`transip`,`safedns`,`ultradns`,<br/>`variomedia`,`vegadns`,`vercel`,`versio`,`vinyldns`,<br/>`vkcloud`,`vscale`,`vultr`,`webnames`,`websupport`,<br/>`wedos`,`yandex360`,`yandexcloud`,`yandex`,`zoneee`,<br/>`zonomi` | `--dns`
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
