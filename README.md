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
| `PROVIDER` | `""` | DNS Provider. Valid values are:<br/>`onecloudru`,`com35`,`dns51`,`abion`,`active24`,`edgedns`,<br/>`alidns`,`aliesa`,`allinkl`,`alwaysdata`,`lightsail`,<br/>`route53`,`anexia`,`safedns`,`artfiles`,`arvancloud`,<br/>`auroradns`,`autodns`,`axelname`,`azion`,`azuredns`,<br/>`baiducloud`,`beget`,`binarylane`,`bindman`,`bluecat`,<br/>`bluecatv2`,`bookmyname`,`bunny`,`checkdomain`,`civo`,<br/>`cloudru`,`clouddns`,`cloudflare`,`cloudns`,`conoha`,<br/>`conohav3`,`constellix`,`corenetworks`,`cpanel`,`curanet`,<br/>`czechia`,`dandomain`,`ddnss`,`derak`,`desec`,`designate`,<br/>`digitalocean`,`dinahosting`,`directadmin`,`dnsmadeeasy`,<br/>`dnsupdate`,`dnsla`,`dnsservices`,`dnscale`,`dnsexit`,<br/>`dnshomede`,`dnsimple`,`dode`,`domeneshop`,`dreamhost`,<br/>`duckdns`,`dyn`,`dyndnsfree`,`dynu`,`easydns`,`edgecenter`,<br/>`efficientip`,`epik`,`eurodns`,`euserv`,`excedo`,<br/>`exoscale`,`exec`,`f5xc`,`fornex`,`freemyip`,`namesurfer`,<br/>`gcore`,`gandi`,`gandiv5`,`gehirn`,`gigahostno`,`glesys`,<br/>`gname`,`godaddy`,`gcloud`,`gravity`,`hetzner`,`hostingde`,<br/>`hostingnl`,`hostinger`,`hosttech`,`hostup`,`httpreq`,<br/>`httpnet`,`huaweicloud`,`hurricane`,`hyperone`,`ibmcloud`,<br/>`iijdpf`,`infoblox`,`infomaniak`,`internetbs`,`inwx`,<br/>`ionos`,`ionoscloud`,`ipv64`,`ispconfig`,`ispconfigddns`,<br/>`jdcloud`,`joker`,`acmedns`,`katapult`,`keyhelp`,<br/>`leaseweb`,`liara`,`limacity`,`linode`,`liquidweb`,<br/>`loopia`,`luadns`,`mailinabox`,`manageengine`,`manual`,<br/>`metaname`,`metaregistrar`,`mijnhost`,`mittwald`,`myaddr`,<br/>`mydnsjp`,`mythicbeasts`,`namedotcom`,`namecheap`,<br/>`namesilo`,`nearlyfreespeech`,`nederhost`,`neodigit`,<br/>`netcup`,`netlify`,`netnod`,`ngenix`,`nicmanager`,<br/>`nifcloud`,`njalla`,`nodion`,`ns1`,`octenium`,`omglol`,<br/>`onlinenet`,`otc`,`oraclecloud`,`ovh`,`plesk`,`pointdns`,<br/>`porkbun`,`pdns`,`rackspace`,`rage4`,`rainyun`,`rcodezero`,<br/>`regru`,`regfish`,`rimuhosting`,`nicru`,`sakuracloud`,<br/>`scaleway`,`scannet`,`selectel`,`selectelv2`,`selfhostde`,<br/>`servercow`,`shellrent`,`simply`,`sonic`,`spaceship`,<br/>`stackpath`,`syse`,`technitium`,`tele3`,`tencentcloud`,<br/>`edgeone`,`timewebcloud`,`todaynic`,`transip`,`ucloud`,<br/>`ultradns`,`uniteddomains`,`variomedia`,`veesp`,`vegadns`,<br/>`vercel`,`versio`,`vinyldns`,`virtualname`,`vkcloud`,<br/>`volcengine`,`vscale`,`vultr`,`wannafind`,`webnamesca`,<br/>`webnamesru`,`websupport`,`wedos`,`westcn`,`xinnet`,<br/>`yandex360`,`yandexcloud`,`yandex`,`zilore`,`zoneee`,<br/>`zoneedit`,`zonomi` | `--dns`
| `DNS_TIMEOUT` | `10` | Set the DNS timeout value to a specific value in seconds. | `--dns-timeout`.
| `LEGO_ARGS` | `""` | Send arguments directly to lego, e.g. `"--dns.propagation.wait"` or `"--dns.resolvers 1.1.1.1"` |

--------------------

## Non-root user

> [!IMPORTANT]
> Starting from version **v5**, this image uses `supercronic` instead of the standard `crond`. This allows for better signal handling and the ability to run as a non-root user.

This image defaults to `root` to ensure backward compatibility and ease of use with volume mounts. However, it uses `supercronic` which allows it to run as any UID.

To run as a non-root user, simply set the `user` in your docker-compose or docker run command. You **must** ensure the mounted volume (e.g. `./letsencrypt`) is writable by the UID you choose.

```yaml
services:
  lego:
    image: brahmadev/acme-lego-cron:latest
    user: "1000:1000"
    # ...
```

```bash
# Before running as UID 1000
chown -R 1000:1000 ./letsencrypt
```

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
      LEGO_ARGS: "--dns.propagation.wait 90s --dns.resolvers 1.1.1.1"
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
      LEGO_ARGS: "--dns.propagation.wait 90s --dns.resolvers 1.1.1.1"
    volumes:
      - ./hook.sh:/app/hook.sh
      - /var/run/docker.sock:/var/run/docker.sock
      - ./letsencrypt:/letsencrypt
```
