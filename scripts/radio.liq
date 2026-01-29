%include "settings.liq"

aac_lofi = %ffmpeg(format="mpegts",
                   %audio(
                     codec="aac",
                     channels=2,
                     ar=sample_rate,
                     b=bitrates.lofi
                   ))

aac_hifi = %ffmpeg(format="mpegts",
                   %audio(
                     codec="aac",
                     channels=2,
                     ar=sample_rate,
                     b=bitrates.hifi
                   ))

streams = ref([
        ("aac_hifi", aac_hifi),
        ("aac_lofi", aac_lofi)
])

if need_midfi then 
    aac_midfi = %ffmpeg(format="mpegts",
                    %audio(
                        codec="aac",
                        channels=2,
                        ar=sample_rate,
                        b=bitrates.midfi
                    ))
    streams := list.insert(1, ("aac_midfi", aac_midfi), streams())
end

def segment_name(meta) =
  timestamp = int_of_float(time())
  let {stream_name, duration, position, extname} = meta
  "#{stream_name}_#{duration}_#{timestamp}_#{position}.#{extname}"
end

def make_output(s) =
    let (stream_name, stream_source) = s

    output.file.hls(playlist="#{stream_name}.m3u8",
        segment_duration=segment_config.duration,
        segments=segment_config.count,
        segments_overhead=segment_config.overhead,
        segment_name=segment_name,
        persist_at="/tmp/hls/#{stream_name}/state.config",
        "/tmp/hls/#{stream_name}",
        streams(),
        stream_source
    )
end

list.iter(make_output, sources)

