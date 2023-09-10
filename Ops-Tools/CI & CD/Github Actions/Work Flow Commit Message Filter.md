## Work Flow Commit Message Filter

Work flow Yaml 파일의 runs on, steps 사이에 if 문으로 특정 커밋메시지가 존재할 시 특정행동을 추가할 수 있다.

```yaml
if: ${{ contains(github.event.head_commit.message, '#ios') || contains(github.event.head_commit.message, '#all') }}
```

`#ios` 혹은 `#all` 이 커밋 메시지에 있는 경우에만 Work Flow가 돌아가게 할 수 있다.