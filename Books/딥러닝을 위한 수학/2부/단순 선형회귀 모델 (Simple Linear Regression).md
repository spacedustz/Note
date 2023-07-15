## 단순 선형회귀 모델 (Simple Linear Regression)

위에서 언급한 손실함수에 대해 좀 더 구체적인 예제를 하나 살펴보겠습니다.

이 예제를 보고 **머신러닝 모델을 수학적으로 푼다** 의 감을 잡을 수 있습니다.

<br>

예제는 `단순 회귀 모델(Simple Regression Model)`에 관한 것입니다.

하나의 실수값 입력(x)으로 하나의 실수값(y) 출력을 예측하는 모델입니다.

예를 들어, 성인 남자의 키 x(cm)가 입력값으로 몸무게 y(kg)가 출력값인 모델을 생각해 봅시다.

이 때 모델의 내부 구조에서는 `선형 회귀(linear regression)`라는 방법을 사용합니다.

`선형 회귀(linear regression)`란 1차함수로 예측하는 모델로 입력 x, 출력 y라고 할 때 선형 회귀 예측식을 작성할 수 있습니다.

`y = w0 + w1x`

<br>

우선 학습 데이터는 아래와 같이 3개의 데이터라고 가정합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml6.png)

이 데이터는 쉽게 답을 구할 수 있도록 값을 조정해서 만든 것입니다.

그래서 수식에 해당하는 예측식을 다음과 같이 어렵지 않게 찾을 수 있습니다.

`y = x - 105`

<br>

이번에는 학습데이터가 아래와 같이 5개의 데이터라고 가정합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml7.png)

앞선 예제와 달리 실측 데이터를 학습 데이터로 사용했습니다.

이런 경우 표본 수가 조금만 늘어나도 어떻게 예측할 지 난감해집니다.

바로 이럴 때 수학적인 접근법이 필요합니다.

<br>

다음 아래 그림은 학습 데이터를 2차원 `산점도(scatter plot)`로 표현 한 그림입니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml8.png)

<br>

아래 그림은 그래프에서의 측정값과 예측값의 오차를 표현한 그림입니다.

yt를 정답값, yp를 모델의 예측값이라고 할때 이 회귀 모델의 오차는 (yt - yp)이며 그림의 파란 직선으로 표현했습니다.

단, 이렇게 계산하면 오차가 음수로 나올 수 있기 때문에 여러 점에서의 오차를 모두 더하면 오차가 오히려 줄어들 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml9.png)

그래서 **정답값 yt와 예측값 yp 간의 차이를 구하되 음수가 나오지 않도록 제곱 후, 모든 점에서의 오차를 합산하는 방식**으로 손실함수를 만듭니다.

이런 접근법을 `잔차제곱합(residual sum of squares)`이라 하고 선형회귀 모델에서 사용하는 손실함수 중 가장 기본적인 계산 방식입니다.

이렇게 정의한 손실함수가 어떤 모양이 되는지 실제로 계산하면서 확인해 봅시다.

<br>

표본 5개의 좌표값을 ( x(i), y(i) )와 같이 써서 우측 상단의 첨자로 구분할 때,

손실함수 L(w0, w1)의 식은 다음과 같이 표현됩니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml10.png)

<br>

위 식을 전개한 다음 w0, w1로 정리하면 다음과 같은 식이 됩니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml11.png)

이 식을 자세히 보면 w0과 w1에 관한 2차식으로 되어 있습니다.

w0w1과 w0의 계수는 입력 데이터의 x좌표, y좌표를 각각 더하는 식이므로,

좌표값의 평균을 원점으로 하는 새로운 좌표계에서는 값을 0으로 만들 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml12.png)

이 식을 실제로 계산해 봅시다.

x좌표의 평균값은 171.0이고, y좌표의 평균값은 65.4입니다.

앞의 학습데이터에서 평균값을 뺀 값을 X, Y라고 할 때 새로 만들어진 학습 데이터는 다음과 같습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml13.png)

<br>

새로운 좌표로 산점도를 그리면 다음과 같습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml14.png)

새로운 좌표계에 대한 가중치를 W0, W1이라고 할때 예측식은 다음과 같이 표현할 수 있습니다.

`Yp = W0 + W1X`

<br>

새로운 좌표계인 위 수식에 대해 새로운 학습 데이터인 위 그림의 X, Y값으로 손실함수를 구하면 다음과 같은 모양이 나옵니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml16.png)

이때 W0과 관련된 부분은 5W0^2 밖에 없습니다.

만약 W0 가 0이라면 이 부분은 0이 되어 최소값이 될 것이 분명합니다.

<br>

남은 58W1^2 - 211.2W1 + 214.96을 최소화하기 위한 W1값은 2차함수의 완전제곱꼴을 이용해 구할 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml15.png)

<br>

결국 W1이 1.82068... 일 때 최소값 22.6951... 이 나오는것을 알 수 있습니다.

확인을 위해 2차함수의 그래프를 그려보면 다음과 같습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml17.png)

결국 새로운 좌표계로 표현한 손실함수가 최소가 될 때는,

`(W0, W1) = (0, 1.82068...)` 일 때라는 것을 알 수 있습니다.

---

## 최적의 예측함수와 회귀 직선 그래프 표시

`학습단계`와 `예측단계`의 관점에서 보면 지금까지의 계산과정은 최적의 W0, W1을 구하기 위한 `학습 단계`에 해당합니다.

그리고 이제 `예측 단계`에 대해서 배워볼 것입니다.

<br>

위의 수식에서 얻은 매개변수의 값을 원래의 수식에 대입하면 다음과 같은 식을 만들 수 있습니다.

`Y = 1.82068X`

이것이 이번 계산에서 얻어낸 **회귀 모델의 예측식입니다.**

이 직선식을 산점도에 표현하면 다음과 같습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml18.png)

그래프로 확인해봐도 5개의 점에 대한 `직선근사(linear approximation)`로 적절하다는 것을 알 수 있습니다.

마지막으로 새로 옮긴 좌표계를 이동 전의 좌표계로 되돌려 원래 모양의 회귀 모델 예측식을 만들어 보겠습니다.

<br>

**좌표계를 변환할 때**

x = 171 + X
y = 65.4 + Y

이었기 때문에 X, Y는 다음과 같이 정리할 수 있습니다.

X = x - 171
Y = y - 65.4

<br>

이 그래프를 원래의 산점도에 그려 봅시다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ml19.png)

이번에도 적절한 선형직선이 나오는 것을 알 수 있습니다.

지금까지 머신러닝 모델에서 가자 간단한 `단순 선형 회귀(simple linear regression)`라는 모델의 설명이었습니다.