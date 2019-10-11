# Fedora image

The resources used to build this sample fedora image were taken
directly from Fedora 30 DVD install medium. Alternatively, they
can be acquired from any [Fedora public mirror](https://admin.fedoraproject.org/mirrormanager/)

## Packages

The relevant data is available in the following packages:

- `fedora-repos`
- `fedora-gpgkeys`
- `dnf-data`

Available package groups can be found on the ISO in /repodata/<hash>-comps-Server.x86_64.xml

### extracting packages

Package contents can be extracted using rpm2cpio in conjunction with the cpio command, e.g.:

```
rpm2cpio fedora-repos-30-1.noarch.rpm | cpio -idmv # -t can be used to simply list contents
```
