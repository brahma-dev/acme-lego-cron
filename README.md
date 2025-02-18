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
| `PROVIDER` | `""` | DNS Provider. Valid values are:<br/>`edgedns`,`alidns`,`allinkl`,`lightsail`,`route53`,<br/>`arvancloud`,`auroradns`,`autodns`,`azure`,`azuredns`,<br/>`bindman`,`bluecat`,`brandit`,`bunny`,`checkdomain`,`civo`,<br/>`cloudru`,`clouddns`,`cloudflare`,`cloudns`,`cloudxns`,<br/>`conoha`,`constellix`,`corenetworks`,`cpanel`,`derak`,<br/>`desec`,`designate`,`digitalocean`,`directadmin`,<br/>`dnsmadeeasy`,`dnshomede`,`dnsimple`,`dnspod`,`dode`,<br/>`domeneshop`,`dreamhost`,`duckdns`,`dyn`,`dynu`,`easydns`,<br/>`efficientip`,`epik`,`exoscale`,`exec`,`freemyip`,`gcore`,<br/>`gandi`,`gandiv5`,`glesys`,`godaddy`,`gcloud`,<br/>`googledomains`,`hetzner`,`hostingde`,`hosttech`,`httpreq`,<br/>`httpnet`,`huaweicloud`,`hurricane`,`hyperone`,`ibmcloud`,<br/>`iijdpf`,`infoblox`,`infomaniak`,`iij`,`internetbs`,`inwx`,<br/>`ionos`,`ipv64`,`iwantmyname`,`joker`,`acme-dns`,`liara`,<br/>`limacity`,`linode`,`liquidweb`,`loopia`,`luadns`,<br/>`mailinabox`,`manageengine`,`manual`,`metaname`,`mijnhost`,<br/>`mittwald`,`myaddr`,`mydnsjp`,`mythicbeasts`,`namedotcom`,<br/>`namecheap`,`namesilo`,`nearlyfreespeech`,`netcup`,<br/>`netlify`,`nicmanager`,`nifcloud`,`njalla`,`nodion`,`ns1`,<br/>`otc`,`oraclecloud`,`ovh`,`plesk`,`porkbun`,`pdns`,<br/>`rackspace`,`rainyun`,`rcodezero`,`regru`,`regfish`,<br/>`rfc2136`,`rimuhosting`,`sakuracloud`,`scaleway`,<br/>`selectel`,`selectelv2`,`selfhostde`,`servercow`,<br/>`shellrent`,`simply`,`sonic`,`spaceship`,`stackpath`,<br/>`technitium`,`tencentcloud`,`timewebcloud`,`transip`,<br/>`safedns`,`ultradns`,`variomedia`,`vegadns`,`vercel`,<br/>`versio`,`vinyldns`,`vkcloud`,`volcengine`,`vscale`,<br/>`vultr`,`webnames`,`websupport`,`wedos`,`westcn`,<br/>`yandex360`,`yandexcloud`,`yandex`,`zoneee`,`zonomi` | `--dns`
| `DNS_TIMEOUT` | `10` | Set the DNS timeout value to a specific value in seconds. | `--dns-timeout`.
| `LEGO_ARGS` | `""` | Send arguments directly to lego, e.g. `"--dns.disable-cp"` or `"--dns.resolvers 1.1.1.1"` |

--------------------

## Hooks

You can mount a shell script to /app/hook.sh to run whenever a cert is issued. This image comes with bash/curl/wget/jq preinstalled.

## Examples

This example get one certificate for `*.example.com` and `example.com` using cloudflare dns :

- Use staging endpoint during development.


```yaml
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
      - ./letsencrypt:/letsencrypt
```
With hook: Check [hook.sh](https://github.com/brahma-dev/acme-lego-cron/blob/main/app/hook.sh "hook.sh") for an example.
```yaml
services:
  nginx:
    container_name: nginx01
    image: nginx:alpine
    ports:
    - mode: host
      published: 443
      target: 443
    - mode: host
      published: 80
      target: 80
    volumes:
      - ./html/:/var/www/html
      - ./nginx-example.conf:/etc/nginx/conf.d/default.conf
      - "./letsencrypt:/letsencrypt"
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
      - ./hook.sh:/app/hook.sh
      - /var/run/docker.sock:/var/run/docker.sock
      - ./letsencrypt:/letsencrypt
```
