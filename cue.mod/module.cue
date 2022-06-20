module: "github.com/innoai-tech/ffmpeg"

require: {
	"dagger.io":                      "v0.3.0"
	"github.com/innoai-tech/runtime": "v0.0.0-20220621090344-b7ae60f8f118"
}

require: {
	"universe.dagger.io": "v0.3.0" @indirect()
}
