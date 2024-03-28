## Python 개발 환경 세팅

IDE는 IntelliJ로 진행

[Python 설치](https://www.python.org/downloads/)

---
## 프로젝트 생성

- IntelliJ Python 플러그인 설치
- New Project에서 Python 선택
- Environment Type은 `Virtualenv` 사용
- Virtualenv는 각각의 프로젝트에 독립적인 Python 환경을 제공해주는 도구입니다.

<br>

프로젝트 터미널에 다음과 같이 입력해줍니다.

```bash
python.exe -m pip install --upgrade pip
```

---
## 웹 크롤러

간단한 웹 크롤링 프로그램을 만들기 위해 라이브러리를 설치해줍니다.

프로젝트 터미널에 다음과 같이 입력합니다.

```bash
pip install requests beautifulsoup4
```
r
그 후, 파일을 만들어줍니다.

```python
import requests  
from bs4 import BeautifulSoup  
  
# 네이버 뉴스 페이지에서 HTML을 가져옵니다.  
response = requests.get("https://news.naver.com/")  
  
# BeautifulSoup 객체를 생성합니다.  
soup = BeautifulSoup(response.text, 'html.parser')  
  
# 뉴스 헤드라인을 선택합니다.  
headlines = soup.select("div.cjs_channel_card div.cjs_journal_wrap._item_contents div.cjs_news_tw div.cjs_t")  
  
# 각 헤드라인의 텍스트를 출력합니다.  
for headline in headlines:  
    print(headline.text.strip())
```

실행 해보면 뉴스 헤드라인 텍스트들이 출력됩니다.

```
C:\Users\root\Desktop\Private\Python\venv\Scripts\python.exe C:\Users\root\Desktop\Private\Python\Crawling.py 
자녀와 여행가려던 날 쓰러진 30대 엄마, 5명 살리고 하늘로 떠나
이건희가 “월급 두 배 올려라”고 말한 사연
‘푸바오’의 빈자리, 레서판다 삼총사가 메울까
경북 김천 2층 단독주택 화재···주택 2층 전소
Terra's Do Kwon to be extradited to Korea: Montenegro court
경찰 "이천수 폭행 · 협박 가해자는 60대 · 70대 남성…곧 소환"
[네트워크 통·장] 해외 수주 급감, 내리막길 걷는 KMW…김덕용 리더십 '흔들'
민주주의의 진정한 적은 누구인가?[박이대승의 소수관점](37)
‘치유공간 이웃’ 이영하 전 대표  [세월호 10년, 100명의 기억-62]
[인터뷰] 함운경 국민의힘 마포을 후보 "당에서 내가 가진 전투력 높게 봐"
[Z시세] "뒤풀이가 뭐예요?"… 청년 조기축구는 끝나면 '칼퇴'
... 등등등
```