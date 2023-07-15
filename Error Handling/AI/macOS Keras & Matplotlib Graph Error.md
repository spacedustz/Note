## ❌ macOS Keras & Matplotlib Graph Error

macOs 환경에서 Keras를 사용할 때 정상동적처럼 보이지만 Matplotlib으로 그래프를 그릴 때 오작동 하는 현상이 있다.

이 문제를 피하려면 다음과 같은 파이썬 코드가 필요하다.

```python
import os
import platform

if platform.system() == 'Darwin':
	os.environ['KMP_DUPLICATE_LIB_OK']='True'
```