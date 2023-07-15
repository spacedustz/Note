## 소스코드

URL : https://github.com/wikibook/math_dl_book_info

---

## Jupyter Notebook

주피터 노트북은 `파일 실행 & 결과 기록 & 데이터 분석` 툴이다.

노트북 파일은 파이썬 언어를 기본 베이스로 하고 계산을 하거나 그래프를 그릴 수 있고,

마크다운 문서 작성도 지원하므로 딥러닝을 학습하는데 최적의 툴이다.

주피터 노트북을 실행할 수 있는 Anaconda라는 툴도 사용한다.

---

## Anaconda

사이트 접속 후 다운로드 : https://www.anaconda.com/distribution

파이썬 3.10 중에서도 64bit Graphical Installer를 사용을 전제로 함.

macOS는 설치 후 Anaconda Prompt 가 아닌 기본 터미널로 진행해도 무방하다.

<br>

### 아나콘다 업데이트

`conda update -n base -c defaults conda `
`conda install -y conda=23.5.0`

<br>

### 소스코드를 실행할 때 필요한 모듈 추가

- Matplotlib
- Scikit-Learn
- Jupyter
- Tensor Flow
- Keras

`conda install -y matplotlib`
`conda install -y scikit-learn`
`conda install -y jupyter`
`conda install -y tensorflow`
`conda install -y keras`

를입력해 모듈 추가

<br>

### 주피터 노트북 실행

주피터 노트북을 실행하기 위한 GUI툴인 Anaconda Navigator를 OS 검색창에서 찾아 실행한다.

Anaconda Navigator 실행 후, Jupyter NoteBook을 실행

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/anaconda.png)

Jupyter NoteBook이 열리면 기본적으로 OS의 홈 디렉터리를 표시한다.

이제 가져온 소스코드에서 실행하고 싶은 노트북 파일을 실행하면 된다.

잘 열리는지 확인하기 위해 `ch11-keras.ipynb` 파일을 열어보자.

`Run` 버튼을 누르면 단계별 실행, >> 버튼을 누르면 한번에 전체 실행이다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/jupyter.png)

<br>

전체 실행 버튼을 누르면 코드들이 실행되고,


![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/jupyter2.png)

10분정도 기다리면 마지막 그래프가 그려지는데 기다리기 귀찮으므로 스킵,

이제 기본 환경을 세팅되었다.

---

## macOS 환경 주의점

macOs 환경에서 Keras를 사용할 때 정상동적처럼 보이지만 Matplotlib으로 그래프를 그릴 때 오작동 하는 현상이 있다.

이 문제를 피하려면 다음과 같은 코드가 필요하다.

```python
import os
import platform

if platform.system() == 'Darwin':
	os.environ['KMP_DUPLICATE_LIB_OK']='True'
```