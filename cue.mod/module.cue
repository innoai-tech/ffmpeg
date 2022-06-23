module: "github.com/innoai-tech/ffmpeg"

require: {
	"dagger.io":                      "v0.3.0"
	"github.com/innoai-tech/runtime": "v0.0.0-20220623025846-fa71790f6a03"
}

require: {
	"universe.dagger.io": "v0.3.0" @indirect()
}
