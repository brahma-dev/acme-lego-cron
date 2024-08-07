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
| `PROVIDER` | `""` | DNS Provider. Valid values are: `edgedns`,`alidns`,`allinkl`,`lightsail`,`route53`,<br/>`arvancloud`,`auroradns`,`autodns`,`azure`,`azuredns`,<br/>`bindman`,`bluecat`,`brandit`,`bunny`,`checkdomain`,`civo`,<br/>`cloudru`,`clouddns`,`cloudflare`,`cloudns`,`cloudxns`,<br/>`conoha`,`constellix`,`cpanel`,`derak`,`desec`,`designate`,<br/>`digitalocean`,`dnsmadeeasy`,`dnshomede`,`dnsimple`,<br/>`dnspod`,`dode`,`domeneshop`,`dreamhost`,`duckdns`,`dyn`,<br/>`dynu`,`easydns`,`efficientip`,`epik`,`exoscale`,`exec`,<br/>`freemyip`,`gcore`,`gandi`,`gandiv5`,`glesys`,`godaddy`,<br/>`gcloud`,`googledomains`,`hetzner`,`hostingde`,`hosttech`,<br/>`httpreq`,`httpnet`,`hurricane`,`hyperone`,`ibmcloud`,<br/>`iijdpf`,`infoblox`,`infomaniak`,`iij`,`internetbs`,`inwx`,<br/>`ionos`,`ipv64`,`iwantmyname`,`joker`,`acme-dns`,`liara`,<br/>`linode`,`liquidweb`,`loopia`,`luadns`,`mailinabox`,<br/>`manual`,`metaname`,`mydnsjp`,`mythicbeasts`,`namedotcom`,<br/>`namecheap`,`namesilo`,`nearlyfreespeech`,`netcup`,<br/>`netlify`,`nicmanager`,`nifcloud`,`njalla`,`nodion`,`ns1`,<br/>`otc`,`oraclecloud`,`ovh`,`plesk`,`porkbun`,`pdns`,<br/>`rackspace`,`rcodezero`,`regru`,`rfc2136`,`rimuhosting`,<br/>`sakuracloud`,`scaleway`,`selectel`,`selectelv2`,<br/>`servercow`,`shellrent`,`simply`,`sonic`,`stackpath`,<br/>`tencentcloud`,`transip`,`safedns`,`ultradns`,`variomedia`,<br/>`vegadns`,`vercel`,`versio`,`vinyldns`,`vkcloud`,`vscale`,<br/>`vultr`,`webnames`,`websupport`,`wedos`,`yandex360`,<br/>`yandexcloud`,`yandex`,`zoneee`,`zonomi` | `--dns`
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
