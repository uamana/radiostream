settings.harbor.bind_addrs := ["${HARBOR_BIND_ADDR:-0.0.0.0}"]

segment_config = {
    duration = ${SEGMENT_DURATION:-5.0},
    count = ${SEGMENTS:-5},
    overhead = ${SEGMENT_OVERHEAD:-5}
}

bitrates = {
    hifi = "${HIFI_BITRATE:-160k}",
    lofi = "${LOFI_BITRATE:-64k}",
    midfi = "${MIDFI_BITRATE:-128k}"
}

sample_rate = ${SAMPLE_RATE:-44100}

need_midfi = ${NEED_MIDFI:-false}

sources = [
    $SOURCES
]