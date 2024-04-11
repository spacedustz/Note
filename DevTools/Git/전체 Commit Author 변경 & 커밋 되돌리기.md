
## Commit Author 변경

```bash
# 모든 커밋 Author 변경
git filter-branch -f --env-filter "GIT_AUTHOR_NAME='spacedustz'; GIT_AUTHOR_EMAIL='spacedustw@gmail.com'; GIT_COMMITTER_NAME='spacedustz'; GIT_COMMITTER_EMAIL='spacedustw@gmail.com';" HEAD

# Push
git push -f origin
```

---
## 커밋 되돌리기

`git reset --hard` 사용 시 주의점

**내가 실수로 올린 Push의 내용을 협업하는 누군가 Pull을 받지 않았다고 확신할때만 사용**하시길 바랍니다.

만약 내가 실수로 올린걸 누가 이미 Pull을 받고 거기서 작업중이라면 그 해당 사람의 브랜치에서도 지워줘야 하기 때문입니다.

```bash
git reset --hard HEAD^
git push -f origin main
```

---

## Commit Author 개별적으로 바꾸기

```bash
git rebase -i {git hash}
# [vi 편집기] -> pick을 e or edit 으로 바꾼후 저장
git commit --amend --author="spacedustz<spacedustw@gmail.com>"
git push -f origin
```