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
| `PROVIDER` | `""` | DNS Provider. Valid values are:<br/>`onecloudru`,`com35`,`active24`,`edgedns`,`alidns`,<br/>`aliesa`,`allinkl`,`alwaysdata`,`lightsail`,`route53`,<br/>`anexia`,`safedns`,`artfiles`,`arvancloud`,`auroradns`,<br/>`autodns`,`axelname`,`azion`,`azure`,`azuredns`,<br/>`baiducloud`,`beget`,`binarylane`,`bindman`,`bluecat`,<br/>`bluecatv2`,`bookmyname`,`brandit`,`bunny`,`checkdomain`,<br/>`civo`,`cloudru`,`clouddns`,`cloudflare`,`cloudns`,<br/>`cloudxns`,`conoha`,`conohav3`,`constellix`,`corenetworks`,<br/>`cpanel`,`czechia`,`ddnss`,`derak`,`desec`,`designate`,<br/>`digitalocean`,`directadmin`,`dnsmadeeasy`,`rfc2136`,<br/>`dnsexit`,`dnshomede`,`dnsimple`,`dnspod`,`dode`,<br/>`domeneshop`,`dreamhost`,`duckdns`,`dyn`,`dyndnsfree`,<br/>`dynu`,`easydns`,`edgecenter`,`efficientip`,`epik`,<br/>`eurodns`,`excedo`,`exoscale`,`exec`,`f5xc`,`freemyip`,<br/>`namesurfer`,`gcore`,`gandi`,`gandiv5`,`gigahostno`,<br/>`glesys`,`godaddy`,`gcloud`,`googledomains`,`gravity`,<br/>`hetzner`,`hostingde`,`hostingnl`,`hostinger`,`hosttech`,<br/>`httpreq`,`httpnet`,`huaweicloud`,`hurricane`,`hyperone`,<br/>`ibmcloud`,`iijdpf`,`infoblox`,`infomaniak`,`iij`,<br/>`internetbs`,`inwx`,`ionos`,`ionoscloud`,`ipv64`,<br/>`ispconfig`,`ispconfigddns`,`iwantmyname`,`jdcloud`,<br/>`joker`,`acme-dns`,`keyhelp`,`leaseweb`,`liara`,`limacity`,<br/>`linode`,`liquidweb`,`loopia`,`luadns`,`mailinabox`,<br/>`manageengine`,`manual`,`metaname`,`metaregistrar`,<br/>`mijnhost`,`mittwald`,`myaddr`,`mydnsjp`,`mythicbeasts`,<br/>`namedotcom`,`namecheap`,`namesilo`,`nearlyfreespeech`,<br/>`neodigit`,`netcup`,`netlify`,`netnod`,`nicmanager`,<br/>`nifcloud`,`njalla`,`nodion`,`ns1`,`octenium`,`onlinenet`,<br/>`otc`,`oraclecloud`,`ovh`,`plesk`,`porkbun`,`pdns`,<br/>`rackspace`,`rainyun`,`rcodezero`,`regru`,`regfish`,<br/>`rimuhosting`,`nicru`,`sakuracloud`,`scaleway`,`selectel`,<br/>`selectelv2`,`selfhostde`,`servercow`,`shellrent`,`simply`,<br/>`sonic`,`spaceship`,`stackpath`,`syse`,`technitium`,<br/>`tencentcloud`,`edgeone`,`timewebcloud`,`todaynic`,<br/>`transip`,`ucloud`,`ultradns`,`uniteddomains`,`variomedia`,<br/>`vegadns`,`vercel`,`versio`,`vinyldns`,`virtualname`,<br/>`vkcloud`,`volcengine`,`vscale`,`vultr`,`webnamesca`,<br/>`webnames`,`websupport`,`wedos`,`westcn`,`yandex360`,<br/>`yandexcloud`,`yandex`,`zoneee`,`zoneedit`,`zonomi` | `--dns`
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
