## Remote Commit 기록 없애기

일하다 실수로 브랜치를 안바꾸고 Push를 해버렸는데,

Remote origin의 커밋 기록을 깔끔하게 지우는법을 몰라서 해메다가 찾았습니다.

`git log --oneline`으로 현재 HEAD 를 잘 확인하고 `git reset --hard HEAD^`로 최신 푸시내역을 되돌려줍니다.

이때 Remote Branch가 아닌 Local에서 Reset 된거기 때문에 `git push -f origin master`를 입력해 줍니다.

그럼 Remote Branch에 강제 푸시가 되면서 커밋 기록이 사라지고 원상복구 됩니다.

<br>

`git reset --hard` 사용 시 주의점

**내가 실수로 올린 Push의 내용을 협업하는 누군가 Pull을 받지 않았다고 확신할때만 사용**하시길 바랍니다.

만약 내가 실수로 올린걸 누가 이미 Pull을 받고 거기서 작업중이라면 그 해당 사람의 브랜치에서도 지워줘야 하기 때문입니다.

