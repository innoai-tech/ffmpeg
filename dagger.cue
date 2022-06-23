package main

import (
	"strings"

	"dagger.io/dagger"

	"github.com/innoai-tech/runtime/cuepkg/libify"
)

dagger.#Plan

client: env: {
	GIT_SHA: string | *""

	LINUX_MIRROR:                  string | *""
	CONTAINER_REGISTRY_PULL_PROXY: string | *""

	GH_USERNAME: string | *""
	GH_PASSWORD: dagger.#Secret
}

actions: ffmpeg: libify.#Project & {
	auths: "ghcr.io": {
		username: client.env.GH_USERNAME
		secret:   client.env.GH_PASSWORD
	}
	mirror: {
		linux: "\(client.env.LINUX_MIRROR)"
		pull:  "\(client.env.CONTAINER_REGISTRY_PULL_PROXY)"
	}

	module:   "github.com/innoai-tech/ffmpeg"
	version:  "5"
	revision: "\(client.env.GIT_SHA)"

	base: {
		source: "gcr.io/distroless/cc-debian11:latest"
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

	ship: load: host: client.network."unix:///var/run/docker.sock".connect
}

client: network: "unix:///var/run/docker.sock": connect: dagger.#Socket
