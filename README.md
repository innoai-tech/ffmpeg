# ffmpeg lib image

## Lib image

```shell
/usr/pkg/<lib_name>/
    <arch>/
      include/
      lib/
    include/ -> ./<arch>/include
    lib/ -> ./<arch>/lib
```

```Dockerfile
FROM gcr.io/distroless/cc-debian11:debug

COPY --from ghcr.io/innoai-tech/ffmpeg:5 / /

COPY /go/bin/xx /xx
```

## Usage in go

```go
package codec

/*
	#cgo CFLAGS: -I/usr/pkg/ffmpeg/include
	#cgo LDFLAGS: -L/usr/pkg/ffmpeg/lib -lavutil -lavcodec -lavformat
	#include <libavcodec/avcodec.h>
	#include <libavformat/avformat.h>
	#include <libavutil/avutil.h>
*/
import "C"
```