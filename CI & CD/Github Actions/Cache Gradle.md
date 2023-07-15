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