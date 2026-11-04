---
name: broadcast-engineering
description: "Use for any broadcast, television, video, audio, or streaming engineering question: broadcast chains, SMPTE ST 2110, NMOS, PTP, SDI, NDI, MPEG-TS, HLS/DASH, SRT, codecs, HDR, loudness, or building software on FFmpeg/libav, GStreamer, or WebRTC. Industry-wide context; the ffmpeg-*, gstreamer-*, and webrtc-* skills cover tool specifics."
---

Broadcast and media engineering knowledge base. Concepts, standards, API landscape, and where to verify every claim.

## The broadcast chain

Acquisition (cameras, SDI/IP feeds) → contribution (SRT/RIST/satellite to the plant) → production (switchers, audio consoles, graphics) → playout (playout servers, channel branding) → distribution (satellite DVB, cable, IPTV, OTT) → reception (set-top, smart TV, browser). Each hop has its own transport, codec, and latency budget; knowing which stage a question belongs to narrows every answer.

## Video fundamentals

- Formats: SD (576i/480i), HD (1080i/1080p), UHD (2160p). Frame rates: 23.976/24/25/29.97/50/59.94. Trap: 29.97 = 30000/1001 drop-frame timecode; mixing 25 and 29.97 plants requires frame synchronizers.
- Colorimetry: BT.601 (SD), BT.709 (HD), BT.2020 (UHD wide gamut). Transfer: SDR gamma, PQ (ST 2084), HLG. Chroma subsampling: 4:4:4, 4:2:2 (broadcast), 4:2:0 (delivery). Range: limited (16-235) vs full (0-255) — the most common washed-out/blacks-crushed bug.
- HDR: HDR10 (static metadata, ST 2086 + MaxCLL/MaxFALL), HDR10+ (dynamic ST 2094-40), Dolby Vision (profiles 5/8.4), HLG (BT.2100). Tone-mapping HDR→SDR needs a transfer function, not a gamma change (zscale/libplacebo).
- Timing: SDI plants use black-burst/tri-level genlock; IP plants replace it with PTP.

## Audio fundamentals

- Interconnects: AES3 (AES/EBU, 2ch), MADI (AES10, 64ch), embedded SDI audio (20/24-bit audio groups), audio-over-IP: AES67 (interoperable), Dante (Audinate, proprietary), Ravenna.
- Loudness: EBU R128 (-23 LUFS, Europe), ATSC A/85 (-24 LKFS, US), true peak ≤ -1 dBTP. Measured program loudness with loudnorm/EBU mode; normalization is not peak limiting.

## SDI and the transition to IP

- SDI: 270 Mb/s (SD), 1.485/3G (HD), 12G (UHD). Reliable, point-to-point, distance-limited; embedded audio and ancillary data.
- SMPTE ST 2110 (the IP plant standard): -10 system timing (all essences share PTP), -20 uncompressed video, -30 audio (AES67-based), -40 ancillary/captions, -22 (compressed video, e.g. JPEG-XS). Essence flows are separate — one video, N audio, data — recombined at the receiver.
- ST 2022-7: seamless protection switching — every essence sent twice over red/blue networks, receiver picks clean packets. Zero-loss failover.
- PTP: SMPTE ST 2059-1/-2 profiles, grandmaster clock election (BMCA); timing precision is the plant's backbone. Trap: PTP domain/profile mismatch = streams drift apart.
- NMOS (AMWA): IS-04 discovery/registration (registry + heartbeat), IS-05 connection management (senders/receivers), IS-08 audio channel mapping. The control plane of an IP plant.
- Multicast: video essences ride IGMP-joined multicast groups, PIM routing, often source-specific multicast; bandwidth math: 1080p25 4:2:2 10-bit ≈ 2.4 Gb/s per essence — uncompressed IP plants are bandwidth-hungry.
- Alternatives: NDI (compressed, LAN-oriented, discovery via mDNS), IPMX (VSF, 2110-compatible for pro-AV), SRT/RIST for WAN contribution.

## Transport & distribution

- MPEG-TS: 188-byte packets, PIDs, PAT/PMT (program tables), PCR (clock reference), PSI/SI. Still the broadcast backbone (DVB, contribution, HLS TS segments).
- Terrestrial/satellite/cable: DVB-S2/S2X, DVB-T2, DVB-C2, ATSC 1.0/3.0 — modulation and multiplex standards on top of MPEG-TS.
- OTT packaging: HLS (master + media playlists, fMP4 or TS, LL-HLS parts for low latency), MPEG-DASH (MPD, SegmentTemplate), CMAF (single fMP4 fragment format shared by both). Latency ladder: standard HLS ~15-30 s, LL-HLS/DASH ~3-5 s, WebRTC < 1 s.
- Contribution over WAN: SRT (ARQ + encryption, latency-tuned), RIST (RTP-based, ST 2022-x reuse), RTMP (legacy ingest, still everywhere), WHIP/WHEP (WebRTC ingest/egress, RFC 9725 family).
- DRM: Widevine/PlayReady/FairPlay over CENC; cbcs for HLS, cenc for DASH (see the media-shaka and ffmpeg-drm skills).

## Codecs & containers

- Video delivery: H.264/AVC (universal), HEVC (UHD/DRM), AV1 (royalty-free), VP9. Mezzanine/production: ProRes, DNxHR, JPEG-XS (mezzanine over IP, ST 2110-22).
- Audio delivery: AAC (LC/HE), Opus, AC-3/E-AC-3; PCM for production.
- Containers: MP4/MOV (ISOBMFF), MKV, MXF (SMPTE 377M: OP1a single-file delivery, OP-Atom per-essence; AS-11 = UK DPP delivery profile), IMF (ST 2067, component-based masters).
- Bitstream: NAL units, SPS/PPS/VPS parameter sets, Annex-B vs length-prefixed (the classic TS↔MP4 conversion trap; see the ffmpeg-bitstream skill).

## Quality control

Objective: VMAF (Netflix, perceptual), SSIM, PSNR (see ffmpeg-quality). Audio: EBU R128 momentary/short-term/integrated. Plant QC: freeze/black/silence detection, DPP AS-11 compliance for UK delivery.

## Building software on these technologies

- FFmpeg/libav libraries: libavformat (demux/mux, protocols), libavcodec (decode/encode), libavfilter (filter graphs), libswscale (scaling/pixel format), libswresample (audio resample/layout), libavutil (helpers). Decode lifecycle: avformat_open_input → avformat_find_stream_info → av_read_frame (AVPacket) → avcodec_send_packet / avcodec_receive_frame (AVFrame) → av_frame_unref. Packets and frames are reference-counted — copy with av_packet_ref, never by value. The API moves between major versions: verify against the headers of the version you ship.
- FFmpeg source layout (for deep questions): libavcodec/ (decoders/encoders per codec), libavformat/ (muxers/demuxers/protocols), libavfilter/, doc/APIchanges (every breaking API change), examples/ (compileable patterns), doc/ (muxers.txt, demuxers.txt, filters.txt).
- GStreamer: elements connected by pads, negotiated by caps, data in GstBuffer chains; dynamic pipelines use the pad-added pattern; probe elements for inspection.
- WebRTC: SDP offer/answer, ICE/STUN/TURN traversal, DTLS-SRTP, RTP media. Implementations: Pion (Go, pure Go — go code reads the spec directly), libdatachannel (C++), mediasoup/LiveKit (SFU architectures).
- Bindings for FFmpeg: Go → go-astiav (idiomatic, explicit memory management over CGO), C++ → native libav with RAII wrappers, Rust → ffmpeg-next, Python → PyAV. Version skew between your installed FFmpeg libs and the binding's assumptions is the classic failure: pin versions and verify with pkg-config.
- Typical Go integration shape: enable network (avformat_network_init) → open input (RTSP/RTMP/file) → locate video stream → open decoder → loop packet→frame → process → release. Buffer lifetime and CGO pointer rules are where Go/FFmpeg integrations crash.

## Verify, don't trust

- Standards bodies: SMPTE (ST standards), EBU Tech (EBU Tech 3371 "Technology Pyramid" is the best single IP-plant architecture map), AMWA (NMOS specs), VSF (IPMX/TR transport), JT-NM (reference architectures).
- Official docs: ffmpeg.org documentation + doc/ in the source tree, gstreamer.freedesktop.org, W3C/IETF for WebRTC specs.
- Local source truth: for an indexed codebase use the codebase-memory MCP tools (search_graph, trace_path, get_code_snippet, get_architecture) — cite file and line, never paraphrase from memory. State which FFmpeg/codec version your claim applies to.
