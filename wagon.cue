package main

import (
	"strings"

	"wagon.octohelm.tech/core"

	"github.com/innoai-tech/runtime/cuepkg/libify"
)

client: env: core.#ClientEnv & {
	VERSION: string | *"5"
}

actions: ffmpeg: libify.#Project & {
	module:  "github.com/innoai-tech/ffmpeg"
	version: "\(client.env.VERSION)"

	base: {
		source: "docker.io/library/debian:11"
	}

	// https://packages.debian.org/bullseye/ffmpeg
	packages: {
		"libavfilter-dev": _
		"libavcodec-dev":  _
		"libavformat-dev": _
		"libswscale-dev":  _
		"libavutil-dev":   _
	}

	target: {
		arch: ["amd64", "arm64"]
		include: [
			"/usr/include/{{ .TARGETGNUARCH }}-linux-gnu",
		]
		lib: [
			"/lib/{{ .TARGETGNUARCH }}-linux-gnu",
			"/usr/lib/{{ .TARGETGNUARCH }}-linux-gnu",
		]
	}

	ship: {
		name: strings.Replace(module, "github.com/", "ghcr.io/", -1)
	}
}

setting: {
	_env: core.#ClientEnv & {
		GH_USERNAME: string | *""
		GH_PASSWORD: core.#Secret
	}

	setup: core.#Setting & {
		registry: "ghcr.io": auth: {
			username: _env.GH_USERNAME
			secret:   _env.GH_PASSWORD
		}
	}
}
