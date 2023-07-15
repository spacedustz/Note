## ❌ [Github Actions] every step must define a `uses` or `run` key

Github Actions 빌드 중 Work Flow를 추가하고 갑자기 안되는 문제 발생.

Yaml 문법도 다 맞는데 왜 안되나 해서 계속 만져보다가,

-name 밑에 uses 중 1곳에 `uses`가 아닌 `- uses`가 되있길래 `-`를 뺐더니 정상 작동했다.

<br>

문제의 코드

```yaml
# AWS Access & Secret Key 권한 확인, Github Actions Secret에서 등록  
- name: Configure AWS Credentials  
- uses: aws-actions/configure-aws-credentials@v1  
  with:  
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY }}  
    aws-secret-access-key: ${{ secrets.AWS_SECRET_KEY }}  
    aws-region: ap-northeast-2
```

<br>

수정 후

```yaml
# AWS Access & Secret Key 권한 확인, Github Actions Secret에서 등록  
- name: Configure AWS Credentials  
  uses: aws-actions/configure-aws-credentials@v1  
  with:  
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY }}  
    aws-secret-access-key: ${{ secrets.AWS_SECRET_KEY }}  
    aws-region: ap-northeast-2
```

`-`를 뺐더니 잘 작동한다.