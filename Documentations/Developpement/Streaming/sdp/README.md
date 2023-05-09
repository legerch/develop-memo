**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. Required fields](#2-required-fields)
- [3. Details](#3-details)
- [4. Ressources](#4-ressources)

# 1. Introduction

THis file contains all details about a **Session Description Protocol (SDP)**.  
Some examples are available in ressources folder : [`sdp/res`](res/)

# 2. Required fields

_Under construction_

# 3. Details

Structure of `.sdp` file :
```shell
Session description
    v=  (protocol version)
    o=  (originator and session identifier)
    s=  (session name)
    i=* (session information)
    u=* (URI of description)
    e=* (email address)
    p=* (phone number)
    c=* (connection information -- not required if included in
    all media descriptions)
    b=* (zero or more bandwidth information lines)
    One or more time descriptions:
    ("t=", "r=" and "z=" lines; see below)
    k=* (obsolete)
    a=* (zero or more session attribute lines)
    Zero or more media descriptions

Time description
    t=  (time the session is active)
    r=* (zero or more repeat times)
    z=* (optional time zone offset line)

Media description, if present
    m=  (media name and transport address)
    i=* (media title)
    c=* (connection information -- optional if included at
    session level)
    b=* (zero or more bandwidth information lines)
    k=* (obsolete)
    a=* (zero or more media attribute lines)
```

# 4. Ressources

- Official :
  - [Standards Track : RCF4566](https://datatracker.ietf.org/doc/html/rfc4566)
  - [Standards Track : RCF8866](https://www.rfc-editor.org/rfc/rfc8866)
  - [RFC4566 - List attributes](https://www.tech-invite.com/fo-abnf/tinv-fo-abnf-sdpatt-02.html)
- Tutorials :
  - [RTP (I): Intro to RTP and SDP](https://www.kurento.org/blog/rtp-i-intro-rtp-and-sdp)
  - [SDP : Protocole de description de session RFC2327 (French document)](http://abcdrfc.free.fr/rfc-vf/pdf/rfc2327.pdf)
- Threads :
  - [Use VLC to fetch SDP file once using RTSP](https://stackoverflow.com/questions/34983079/use-vlc-to-fetch-sdp-file-once-using-rtsp)
