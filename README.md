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
| `PROVIDER` | `""` | DNS Provider. Valid values are:<br/>`active24`,`edgedns`,`alidns`,`allinkl`,`lightsail`,<br/>`route53`,`arvancloud`,`auroradns`,`autodns`,`axelname`,<br/>`azion`,`azure`,`azuredns`,`baiducloud`,`beget`,<br/>`binarylane`,`bindman`,`bluecat`,`bookmyname`,`brandit`,<br/>`bunny`,`checkdomain`,`civo`,`cloudru`,`clouddns`,<br/>`cloudflare`,`cloudns`,`cloudxns`,`conoha`,`conohav3`,<br/>`constellix`,`corenetworks`,`cpanel`,`derak`,`desec`,<br/>`designate`,`digitalocean`,`directadmin`,`dnsmadeeasy`,<br/>`dnshomede`,`dnsimple`,`dnspod`,`dode`,`domeneshop`,<br/>`dreamhost`,`duckdns`,`dyn`,`dyndnsfree`,`dynu`,`easydns`,<br/>`efficientip`,`epik`,`exoscale`,`exec`,`f5xc`,`freemyip`,<br/>`gcore`,`gandi`,`gandiv5`,`glesys`,`godaddy`,`gcloud`,<br/>`googledomains`,`hetzner`,`hetznerv1`,`hostingde`,<br/>`hostinger`,`hosttech`,`httpreq`,`httpnet`,`huaweicloud`,<br/>`hurricane`,`hyperone`,`ibmcloud`,`iijdpf`,`infoblox`,<br/>`infomaniak`,`iij`,`internetbs`,`inwx`,`ionos`,`ipv64`,<br/>`iwantmyname`,`joker`,`acme-dns`,`keyhelp`,`liara`,<br/>`limacity`,`linode`,`liquidweb`,`loopia`,`luadns`,<br/>`mailinabox`,`manageengine`,`manual`,`metaname`,<br/>`metaregistrar`,`mijnhost`,`mittwald`,`myaddr`,`mydnsjp`,<br/>`mythicbeasts`,`namedotcom`,`namecheap`,`namesilo`,<br/>`nearlyfreespeech`,`netcup`,`netlify`,`nicmanager`,<br/>`nifcloud`,`njalla`,`nodion`,`ns1`,`octenium`,`otc`,<br/>`oraclecloud`,`ovh`,`plesk`,`porkbun`,`pdns`,`rackspace`,<br/>`rainyun`,`rcodezero`,`regru`,`regfish`,`rfc2136`,<br/>`rimuhosting`,`nicru`,`sakuracloud`,`scaleway`,`selectel`,<br/>`selectelv2`,`selfhostde`,`servercow`,`shellrent`,`simply`,<br/>`sonic`,`spaceship`,`stackpath`,`technitium`,<br/>`tencentcloud`,`edgeone`,`timewebcloud`,`transip`,<br/>`safedns`,`ultradns`,`variomedia`,`vegadns`,`vercel`,<br/>`versio`,`vinyldns`,`vkcloud`,`volcengine`,`vscale`,<br/>`vultr`,`webnames`,`websupport`,`wedos`,`westcn`,<br/>`yandex360`,`yandexcloud`,`yandex`,`zoneee`,`zoneedit`,<br/>`zonomi` | `--dns`
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
