## 📘 FFpmeg Low Ratency

FFmpeg을 이용해 RTSP를 HLS로 스트리밍을 하는데 지연시간이 너무 길어 옵션들을 만지다가,

최대한 Low Ratency를 달성하기 위해 알아본 글 입니다.

<br>

>  **지연시간이 발생하는 이유**

HLS는 일반적으로 **설계상 지연시간**이 존재합니다. (일반적으로 2~30초) 

왜일까요?

- 일반적으로 플레이어는 2~4개의 세그먼트를 캐시합니다. (8~16초 지연)
- 플레이어가 항상 재생목록을 다시 로드하기 때문에 (최대 4초 지연) 또 다른 세그먼트가 지연됩니다.
- 인코더는 항상 하나의 세그먼트를 처리중 입니다. (또 4초 지연)
- 그리고 클라이언트 측 RTSP 인코딩과 서버의 업로드/전송 시간으로 인해 지연됩니다. (1~4초 지연)

이러면 최소 30초 정도의 딜레이가 발생합니다.

<br>

>  **지연 시간을 줄이는 방법**

**세그먼트 크기 줄이기 - `hls_time` 옵션**

- 이 방법을 사용하면 더 많은 파일을 생성해야 합니다.
- 재생 목록 파일(m3u8)을 더 자주 업데이트 해야합ㅂ니다.
- 더 많은 오버헤드가 발생합니다.
- 기본값은 2이며, 2~6초를 권장합니다.

<br>

**세그먼트 개수 줄이기 - `hls_list_size` 옵션**

- m3u8 재생목록에 들어가는 세그먼트 파일(.ts)의 개수를 줄이는 옵션입니다. 

<br>

**하드웨어 가속**

- 알아보는 중

---

## 📘 FFmpeg Options

>  **설정값**

- hls_time = 2
- hls_list_size = 2
- hls_flags = delete_segments+append_list
- start_number = 1
- hls_playlist_type = event

<br>

>  `-hls_flags delete_segments`

- 이 플래그는 처리된 세그먼트 파일들을 지속적으로 삭제합니다. 
- 그렇게 함으로써 사용자가 재생을 시작할 때 오래된 세그먼트 대신 최신 세그먼트부터 재생하게 할 수 있습니다.  

<br>

>  `-hls_flags append_list`

- HLS v4 이상에서 사용할 수 있는 이 플래그는 기존 재생 목록에 세그먼트를 추가만 하며, 이것은 항상 최신 세그먼트부터 재생하게 할 때 유용합니다.  

<br>

>  `-hls_playlist_type event`

- 이 옵션은 라이브 스트리밍에 적합한 event 타입의 재생 목록을 생성합니다. vod (Video On Demand)와 달리, event 타입은 새로운 세그먼트가 추가될 때 기존의 세그먼트를 유지하게 해서 실시간으로 업데이트되는 재생 목록을 제공합니다.  

<br>

>  `-hls_list_size 0`

- 이 옵션은 재생 목록에 모든 세그먼트를 유지하도록 설정합니다. 
- 그러나 실시간 스트리밍에는 유용하지 않을 수 있으며, 대신 적절한 크기(예: -hls_list_size 3 또는 5)로 설정하여 최근 세그먼트만 유지하게 할 수 있습니다.  

<br>

>  `-hls_time`

- 이 옵션으로 각 세그먼트의 지속 시간을 설정할 수 있으며, 이는 세그먼트의 길이를 결정합니다. 
- 세그먼트 길이를 짧게 설정하면(예: 2초), 재생이 더 빨리 최신으로 시작될 수 있습니다.  

```bash
ffmpeg -i rtsp://your_rtsp_stream_address -codec copy -flags -global_header -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+append_list -hls_playlist_type event stream.m3u8
```

<br>

>  **설명**

* RTSP 스트림을 입력으로 받습니다.  
* 비디오와 오디오 코덱을 변환하지 않고 복사합니다 (-codec copy).  
* HLS 포맷으로 출력합니다 (-f hls).  
* 각 세그먼트의 길이를 2초로 설정합니다 (-hls_time 2).  
* 재생 목록에서 최대 3개의 세그먼트를 유지합니다 (-hls_list_size 3).  
* 처리된 세그먼트를 삭제하고 재생 목록에 세그먼트를 추가만 하여 최신 상태를 유지합니다 (-hls_flags delete_segments+append_list).  
* 재생 목록 타입을 event로 설정하여 라이브 스트리밍에 적합하게 합니다 (-hls_playlist_type event).  
* 재생 목록 파일 이름을 stream.m3u8로 설정합니다.  
* 위 설정을 사용하면, 사용자가 재생을 시작할 때 최신 콘텐츠를 먼저 볼 수 있도록 HLS 스트림이 구성됩니다.  

<br>

> **지연시간 낮은 옵션**

```python
ffmpeg -nostdin -flags low_delay -rtsp_transport tcp -i <rtsp_stream> -pix_fmt bgr24 -an -vcodec rawvideo -f rawvideo -
```