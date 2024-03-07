## 📘 GStreamer - Pipeline

Gstreamer Pipeline은 Multi-Media 데이터를 처리하는 Elements 들로 구성되어 있습니다.

각 요소는

- resize
- encoding
- decoding
- filter

등 특정 작업을 수행하는 역할을 하고 각 요소는 데이터 입력(source), 출력(sink)되는 부분으로 이루어져 있습니다.

---
## 📘 Pipeline 구성 요소

### Elements

Pipeline을 구성하는 추상화된 Block 형태를 정의하며, 특정 Source가 들어와서 처리되고 출력(sink)되어 나옵니다.

예를 들면, `videotestsrc`같은 Data Stream을 생성하는 Element는 1개의 src를 가지고 있는 반면,

1개의 Stream을 N개의 Source로 Demux 하는 `demuxer`같은 Element는 여러 개의 Source를 갖습니다.

<br>

### Pads

각 Elements를 연결하는 **src**와 **sink**를 GStreamer에서 **Pad**라고 정의합니다.

Plug, Port 같은 외부 인터페이스 개념과 유사합니다.

각 Pad는 `caps negotitation` 이라고 불리는 과정을 통해 Element 간 연결을 만듭니다.

<br>

### Bin

Element의 집합인 Container 단위를 정의하는 용어입니다.

Elements들 자체의 Sub-Class 개념이며, 어플리케이션의 많은 복잡성을 추상화할 수 있습니다.

1개의 bin 상태를 변경함으로써 하위의 모든 Elements의 상태를 변경하듯이 말이죠.

또, Error, Tag, EOS Message 같이 각각이 포함하는 Children으로부터 Messaging Bus를 전달하기도 합니다.

---
## 📘 Pipeline 실행 예제

저는 GStreamer를 설치해두었으므로 설치가 되었다고 가정합니다.

```bash
gst-launch-1.0 videotestsrc ! autovideosink
```

위 명령어에서 각 Elements들은 `!`로 구분하여 사용합니다.

위 명령을 실행시키면 Test Color Bar 창이 뜨는걸 확인할 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/test-pipeline.png)

**source**와 **sink** Element만 사용한 간단한 Pipeline으로, `videotestsrc`는 테스트용 Video Stream을 생성해주는 source 플러그인입니다.

<br>

`pattern property`를 변경하여 패턴을 변경할 수도 있습니다.

`autovideosink`는 Display Sink의 한 종류로 적합한 Video Sink를 찾아 자동으로 연결 해 줍니다.

예를 들어, `gtk` 인터페이스를 통해 Display하고 싶다면 Sink 부분을 아래와 같이 변경하면, 출력 영상은 같지만 `gtk` 인터페이스로 영상을 보여줍니다.

```bash
gst-launch-1.0 videotestsrc ! gtksink
```

---
## 📘 Audio Source 추가하기

`videotestsrc`처럼 Audio도 테스트용 Source Element가 있습니다. (`audiotestsrc`)

source를 추가할 때는 `!` 구분자를 사용하면 오류가 나니 Syntax를 잘보고 실행해야 합니다.

```bash
gst-launch-1.0 videotestsrc ! autovideosink audiotestsrc ! autoaudiosink
```

위 명령을 실행하면 기존 ColorBar 화면에 삐- 소리가 나는것을 확인할 수 있습니다.

---
## 📘 Communication

GStreamer는 Application과 Pipeline 간 데이터 교환 및 커뮤니케이션을 위한 메커니즘도 제공합니다.

<br>

**buffers**

- Pipeline의 Elements들 사이의 Streaming Data를 나아가게 하는 객체입니다.
- buffers는 항상 `source -> sink` 방향으로 이동합니다. (UpStream -> DownStream)

<br>

**events**

- Elements 또는 Application에서 Elements 사이에 전달된 객체입니다.
- events는 UpStream -> DownStream 방향으로 이동합니다.
- DownStream Events는 데이터 흐름이 동기화 될 수 있습니다.

<br>

**Messages**

- Pipeline Messaging Bus에 의해 Posted된 객체입니다.
- Streaming Thread Context로부터 동기적으로 가로채기 당할 수 있습니다.
- 주로 Application의 Main Thread로부터 비동기적으로 다루어지게 됩니다.
- Error, Tag, State Change, Buffering, Redirect 같은 정보를 전송하는데 사용됩니다.

<br>

**Queries**

- 구간 & 재생위치 같은 정보를 요청하며, 쿼리는 항상 동기적으로 응답합니다.
- Peer Element로부터 정보를 요청하기 위해 Queries를 사용할 수도 있습니다. (ex: File Size, Duration)
- Pipeline 내에서 둘 다 사용될 수 있지만, 보통은 UpStream Queries가 일반적으로 응답합니다.