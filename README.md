# project42/selfsignedcert

A docker image that creates self signed certificates and saves them to /ssl, mount volumes accordingly.

## Environment variables

* HOST = Host name to use for the self signed certificates. (default: server.domain.tld)
* TYPE = What type of files to save from "crt", "pem" or "all". (default: all)


## Outputted filenames (hostname is from HOST environment variable)
* crt = <hostname>.crt and <hostname>.key
* pem = <hostname>.pem
* all = all three files

## Example docker run

```
docker run --rm --volume /tmp/ssl:/ssl --env HOST=server.snakeoil.com --env TYPE=pem project42/selfsignedcert
```
