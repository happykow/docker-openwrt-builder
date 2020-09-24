# OpenWrt on Linksys EA9200

### How to use image builder

The following command is used to build the ea9200 firmware with image builder.

You will need to copy the following into your image builder dir:
- packages.txt
- files (dir)

```bash

# start container
setup.sh

# image builder command
make image linksys-ea9200 PACKAGES="$(cat packages.txt | xargs)" FILES=files
```

### Links
https://www.ifixit.com/Guide/Linksys+EA9200+Disassembly/71762


