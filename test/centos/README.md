# CentOS image

The resources used to build this sample CentOS image were taken
directly from a CentOS 8 DVD install medium.

## Packages

The relevant data is available in the following packages:

- `centos-release`
- `dnf-data`

Available package groups can be found on the ISO in BaseOS/repodata/<hash>-comps-BaseOS.x86_64.xml

### extracting packages

Package contents can be extracted using rpm2cpio in conjunction with the cpio command, e.g.:

```
rpm2cpio centos-release-8.0-0.1905.0.9.el8.x86_64.rpm | cpio -idmv # -t can be used to simply list contents
```
