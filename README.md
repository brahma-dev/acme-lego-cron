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
| `PROVIDER` | `""` | DNS Provider. Valid values are:<br/>`active24`,`edgedns`,`alidns`,`allinkl`,`lightsail`,<br/>`route53`,`arvancloud`,`auroradns`,`autodns`,`axelname`,<br/>`azion`,`azure`,`azuredns`,`baiducloud`,`binarylane`,<br/>`bindman`,`bluecat`,`bookmyname`,`brandit`,`bunny`,<br/>`checkdomain`,`civo`,`cloudru`,`clouddns`,`cloudflare`,<br/>`cloudns`,`cloudxns`,`conoha`,`conohav3`,`constellix`,<br/>`corenetworks`,`cpanel`,`derak`,`desec`,`designate`,<br/>`digitalocean`,`directadmin`,`dnsmadeeasy`,`dnshomede`,<br/>`dnsimple`,`dnspod`,`dode`,`domeneshop`,`dreamhost`,<br/>`duckdns`,`dyn`,`dyndnsfree`,`dynu`,`easydns`,<br/>`efficientip`,`epik`,`exoscale`,`exec`,`f5xc`,`freemyip`,<br/>`gcore`,`gandi`,`gandiv5`,`glesys`,`godaddy`,`gcloud`,<br/>`googledomains`,`hetzner`,`hostingde`,`hosttech`,`httpreq`,<br/>`httpnet`,`huaweicloud`,`hurricane`,`hyperone`,`ibmcloud`,<br/>`iijdpf`,`infoblox`,`infomaniak`,`iij`,`internetbs`,`inwx`,<br/>`ionos`,`ipv64`,`iwantmyname`,`joker`,`acme-dns`,`keyhelp`,<br/>`liara`,`limacity`,`linode`,`liquidweb`,`loopia`,`luadns`,<br/>`mailinabox`,`manageengine`,`manual`,`metaname`,<br/>`metaregistrar`,`mijnhost`,`mittwald`,`myaddr`,`mydnsjp`,<br/>`mythicbeasts`,`namedotcom`,`namecheap`,`namesilo`,<br/>`nearlyfreespeech`,`netcup`,`netlify`,`nicmanager`,<br/>`nifcloud`,`njalla`,`nodion`,`ns1`,`otc`,`oraclecloud`,<br/>`ovh`,`plesk`,`porkbun`,`pdns`,`rackspace`,`rainyun`,<br/>`rcodezero`,`regru`,`regfish`,`rfc2136`,`rimuhosting`,<br/>`nicru`,`sakuracloud`,`scaleway`,`selectel`,`selectelv2`,<br/>`selfhostde`,`servercow`,`shellrent`,`simply`,`sonic`,<br/>`spaceship`,`stackpath`,`technitium`,`tencentcloud`,<br/>`edgeone`,`timewebcloud`,`transip`,`safedns`,`ultradns`,<br/>`variomedia`,`vegadns`,`vercel`,`versio`,`vinyldns`,<br/>`vkcloud`,`volcengine`,`vscale`,`vultr`,`webnames`,<br/>`websupport`,`wedos`,`westcn`,`yandex360`,`yandexcloud`,<br/>`yandex`,`zoneee`,`zoneedit`,`zonomi` | `--dns`
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
