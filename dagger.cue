package main

import (
	"strings"

	"dagger.io/dagger"

	"github.com/innoai-tech/runtime/cuepkg/libify"
)

dagger.#Plan

client: env: {
	GIT_SHA: string | *""

	CONTAINER_REGISTRY_PULL_PROXY: string | *""
	LINUX_MIRROR:                  string | *""

	GH_USERNAME: string | *""
	GH_PASSWORD: dagger.#Secret
}

client: network: "unix:///var/run/docker.sock": connect: dagger.#Socket

actions: ffmpeg: libify.#Project & {
	module:   "github.com/innoai-tech/ffmpeg"
	version:  "5"
	revision: "\(client.env.GIT_SHA)"

	base: {
		source: "gcr.io/distroless/cc-debian11:latest"
	}

	// https://packages.debian.org/bullseye/ffmpeg
	packages: {
		"libavfilter-dev": ""
		"libavcodec-dev":  ""
		"libavformat-dev": ""
		"libswscale-dev":  ""
		"libavutil-dev":   ""
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

	mirror: {
		linux: "\(client.env.LINUX_MIRROR)"
		pull:  "\(client.env.CONTAINER_REGISTRY_PULL_PROXY)"
	}

	ship: {
		name: strings.Replace(module, "github.com/", "ghcr.io/", -1)

		push: auth: {
			username: client.env.GH_USERNAME
			secret:   client.env.GH_PASSWORD
		}

		load: host: client.network."unix:///var/run/docker.sock".connect
	}
}
