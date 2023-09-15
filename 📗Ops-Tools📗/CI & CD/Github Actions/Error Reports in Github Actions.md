## Github Actions Error Report

Github Actions Build 실패 시 에러로그가 담긴 파일을 준다.

```
file:///home/runner/work/Query-Builder/Query-Builder/build/reports/tests/test/index.html
```

이런 식으로 주는데 Github Actions Runner 내부 경로라 접근이 불가능하다.

그래서 빌드 실패 시 오류가 날때 Workflow에 저 에러의 내용을

압축해서 빼와보자.

<br>

**에러내용을 압축하는 Workflow**

```yaml
- name: Compress All Report Files  
  if: ${{ failure() }}  
  run: |  
    echo "Compressing All Report Files..."  
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)  
    mkdir report_files  
    REPORT_DIRS=$(find . -type d -path '*/build/reports/tests/test')  
    for dir in $REPORT_DIRS; do  
      module_path=$(echo $dir | awk -F'/build/' '{print $1}' | cut -c 3-)  
      cp -r "$dir" "report_files/$module_path/$(basename "$(dirname "$dir")")"  
    done  
    tar czvf "report_files_$TIMESTAMP.tar.gz" report_files
```

<br>

**압축을 한 파일을 Github Actions Artifacts를 이용해 가져오자.**

```yaml
- name: Upload Error Report Files to Artifacts  
  if: ${{ failure() }}  
  uses: actions/upload-artifact@v3  
  with:  
    name: report_files  
    path: report_files_*.tar.gz
```

이 업로도된 파일에 접근 방법은 Github Action 페이지의 Summury로 들어가면 된다.

<br>

**아티팩트 잘 나온 모습**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/errorreport.png)

---

## Cache Gradle

Github Action CI 빌드 시 Gradle을 캐싱해 빌드 속도를 향상시킨다.

```yaml
- name: Cache Gradle dependencies  
  uses: actions/cache@v3  
  with:  
    path: ~/.gradle/caches  
    key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle') }}  
    restore-keys: |  
      ${{ runner.os }}-gradle-
```

