## ❌ Jenkins - Credential & Web hook Error

`stderr: No ECDSA host key is known for github.com and you have requested strict checking.`

Jenkins Item(프로젝트)를 생성할 때 이 오류가 뜨면 보통 SSH Key known_hosts 파일에 등록이 안될때 문제가 생깁니다.

리눅스를 오랜만에 만져서 조금 해멨는데 제가 시도한 방법들을 나열해 보겠습니다. ㅠ

key파일의 권한이나 소유권이 안맞아도 발생할 수 있습니다.

아래 방법들 중 하나씩 시도해보면 해결이 될겁니다.

<br>

## 해결 기록

일단 에러의 내용이 ECDSA 키가 없다고 했으니 등록합니다.

```bash
# /var/lib/jenkins/.ssh 로 이동
git ls-remote -h -- {프로젝트의 SSH URL} HEAD
```

위의 명령어가 기본적인 해결책이지만, 저는 권한 문제도 있었습니다. (권한, 파일 소유자, SSH 키 변경 기록 등)

<br>

> **문제의 원인**

저는 SSH Key를 만들때 EC2의 Root계정으로 만들었습니다.

그래서 SSH Key의 소유권이 jenkins 유저가 아닌 root 소유로 되어 있었으며,

Jenkins 빌드 실행 시, 실행 유저는 jenkins 이므로 SSH Key에 접근 권한이 없었습니다.

<br>

다시 루트 계정으로 전환 하거나, sudo 명령을 써서 SSH Key 파일 권한을 변경해줍니다.

```bash
# .ssh 폴더를 루트계정으로 만들었기 떄문에 폴더의 권한이 Root로 되어 있을 경우
chown -R /var/lib/jenkins/.ssh jenkins

# /var/lib/jenkins/.ssh 안에 파일들의 권한을 확인
ll /var/lib/jenkins/.ssh

# 키파일들의 소유권이 root로 되어 있을 경우 소유 유저 jenkins로 변경
chown jenkins:jenkins id_rsa
chown jenkins:jenkins id_rsa.pub
chown jenkins:jenkins 
```

<br>
이래도 안된다면  SSH Key를 업데이트 해줍니다.

```bash
# /var/lib/jenkins/.ssh 로 이동
ssh-keygen -R  github.com
```

<br>

이제 에러가 안뜨고 프로젝트가 Jenkins Credential과 잘 연동이 됩니다.

---

## ❌ Web hook Error

Jenkins의 Plugin 중 Generic Webhook Trigger 사용 중,

정보가 다 맞는데 이런 오류가 뜬다면 /var/lib/jenkins/workspace/{프로젝트이름} 으로 이동 후 .git 폴더를 삭제하고,

다시 빌드를 하면 됩니다.

<br>

> **Error 내용**

```
Generic Cause Running as SYSTEM Building in workspace /var/lib/jenkins/workspace/SpringBoot The recommended git tool is: NONE using credential b89718b9-fb19-4bcf-86aa-6cf7a75b81c4 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/SpringBoot/.git # timeout=10 Fetching changes from the remote Git repository > git config remote.origin.url git@github.com:CosmicDangNyang/CosmicDangNyang-Server.git # timeout=10 Fetching upstream changes from git@github.com:CosmicDangNyang/CosmicDangNyang-Server.git > git --version # timeout=10 > git --version # 'git version 2.25.1' using GIT_SSH to set credentials Github Account Credential Verifying host key using known hosts file > git fetch --tags --force --progress -- git@github.com:CosmicDangNyang/CosmicDangNyang-Server.git +refs/heads/SPACEPET-TEST:refs/remotes/origin/SPACEPET-TEST # timeout=10 ERROR: Error fetching remote repo 'origin' hudson.plugins.git.GitException: Failed to fetch from git@github.com:CosmicDangNyang/CosmicDangNyang-Server.git at hudson.plugins.git.GitSCM.fetchFrom(GitSCM.java:1003) at hudson.plugins.git.GitSCM.retrieveChanges(GitSCM.java:1245) at hudson.plugins.git.GitSCM.checkout(GitSCM.java:1309) at hudson.scm.SCM.checkout(SCM.java:540) at hudson.model.AbstractProject.checkout(AbstractProject.java:1240) at hudson.model.AbstractBuild$AbstractBuildExecution.defaultCheckout(AbstractBuild.java:649) at jenkins.scm.SCMCheckoutStrategy.checkout(SCMCheckoutStrategy.java:85) at hudson.model.AbstractBuild$AbstractBuildExecution.run(AbstractBuild.java:521) at hudson.model.Run.execute(Run.java:1900) at hudson.model.FreeStyleBuild.run(FreeStyleBuild.java:44) at hudson.model.ResourceController.execute(ResourceController.java:101) at hudson.model.Executor.run(Executor.java:442) Caused by: hudson.plugins.git.GitException: Command "git fetch --tags --force --progress -- git@github.com:CosmicDangNyang/CosmicDangNyang-Server.git +refs/heads/SPACEPET-TEST:refs/remotes/origin/SPACEPET-TEST" returned status code 128: stdout: stderr: fatal: invalid refspec '+refs/heads/?SPACEPET-TEST:refs/remotes/origin/SPACEPET-TEST' at org.jenkinsci.plugins.gitclient.CliGitAPIImpl.launchCommandIn(CliGitAPIImpl.java:2732) at org.jenkinsci.plugins.gitclient.CliGitAPIImpl.launchCommandWithCredentials(CliGitAPIImpl.java:2109) at org.jenkinsci.plugins.gitclient.CliGitAPIImpl$1.execute(CliGitAPIImpl.java:623) at hudson.plugins.git.GitSCM.fetchFrom(GitSCM.java:1001) ... 11 more ERROR: Error fetching remote repo 'origin' Finished: FAILURE
```