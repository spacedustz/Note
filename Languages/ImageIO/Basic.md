## 💡 ImageIO Class

썸네일을 구현하는 가장 일반적인 방법은 ImageIO 클래스를 사용하여 이미지를 리사이즈 하는것입니다.

다음은 코틀린 기반 스프링부트 서버에서 썸네일을 구현하는 간단한 예제 코드입니다.

<br>

### 의존성 추가 

Gradle 빌드 파일에 다음 의존성을 추가합니다.

```groovy
dependencies {
  implementation 'net.coobird:thumbnailator:0.4.13'
}
```

<br>

### Image Resize

 resizeImage 함수를 통해 원본 이미지의 크기를 줄여주는 작업을 수행합니다. 

getScaledInstance 함수는 ImageIO 클래스를 사용하여 이미지를 리사이즈하는 방법을 보여주는 함수입니다. 

이 함수에서는 targetWidth와 targetHeight에 맞게 이미지의 크기를 조정하고, 

RenderingHints를 사용하여 이미지의 품질을 향상시킵니다. 

<br>

마지막으로, 리사이즈된 이미지를 PNG 파일로 변환하여 바이트 배열로 반환합니다.

```kotlin
@Service
class ImageService {
    
    fun resizeImage(imageBytes: ByteArray, width: Int, height: Int): ByteArray {
        val inputStream = ByteArrayInputStream(imageBytes)
        val bufferedImage = ImageIO.read(inputStream)
        val scaledImage = getScaledInstance(bufferedImage, width, height)
        val outputStream = ByteArrayOutputStream()
        
        ImageIO.write(scaledImage, "png", outputStream)
        
        return outputStream
    }
    
    private fun getScaledInstance(
        image: BufferedImage, 
        targetWidth: Int,
        targetHeight: Int
    ): BufferedImage {
        var width = image.width
        var height = image.height
        
        val ratio = width.toDouble() / height.toDouble()
        
        if (width > targetWidth) {
            width = targetWidth
            height = (width / ratio).toInt()
        }
        
        val scaledImage = BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
        
        val g2d: Graphics2D = scaledImage.createGraphics()
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC)
        g2d.drawImage(image.getScaledInstance(width, height, Image.SCALE_SMOOTH), 0, 0, width, height, null)
        g2d.dispose()

        return scaledImage
    }
}
```

위 코드를 사용하여 이미지를 리사이즈한 다음, 그 결과를 HTTP 응답으로 보내주는 API를 만들 수 있습니다.
