```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebSocket JSON Viewer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        input {
            padding: 10px;
            width: calc(100% - 20px);
            box-sizing: border-box;
            border: 1px solid #007BFF;
            border-radius: 5px;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        button {
            padding: 10px 15px;
            margin-right: 10px;
            border: none;
            border-radius: 4px;
            color: white;
            background-color: #007BFF;
            cursor: pointer;
            font-size: 14px;
        }
        button:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }
        button:hover:not(:disabled) {
            background-color: #0056b3;
        }
        .output-title {
            font-weight: bold;
            font-size: 18px;
            color: #333;
            margin-top: 30px;
            margin-bottom: 10px;
        }
        .output-container {
            padding: 10px;
            border: 1px solid #007BFF;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            overflow-y: auto;
        }
        #connectionOutput {
            height: 150px;
        }
        #dataOutput {
            height: 500px;
        }
        #lineOutput {
            white-space: pre;
            overflow-x: auto;
            height: 500px;
        }
        .output-container::-webkit-scrollbar {
            width: 10px;
        }
        .output-container::-webkit-scrollbar-thumb {
            background-color: #007BFF;
            border-radius: 5px;
        }
        .output-container::-webkit-scrollbar-thumb:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>WebSocket JSON Viewer</h1>

    <div class="form-group">
        <label for="serverIP">IP + Port</label>
        <input type="text" id="serverIP" placeholder="ex: 192.168.0.2:9000">
    </div>

    <div class="form-group">
        <label for="socketURL">Socket URL:</label>
        <input type="text" id="socketURL" placeholder="ex: /count">
    </div>

    <div>
        <button id="connectBtn">Connect</button>
        <button id="disconnectBtn" disabled>Disconnect</button>
        <button id="clearBtn">Clear Messages</button>
    </div>

    <div class="output-title">Connection</div>
    <div id="connectionOutput" class="output-container"></div>

    <div class="output-title">Received Data</div>
    <div id="dataOutput" class="output-container"></div>

    <div class="output-title">Received Data (One Line Per Message)</div>
    <div id="lineOutput" class="output-container"></div>

    <script>
        let websocket;

        document.getElementById('connectBtn').addEventListener('click', () => {
            const serverIP = document.getElementById('serverIP').value;
            const socketURL = document.getElementById('socketURL').value;

            if (!serverIP || !socketURL) {
                alert('Server IP와 Socket URL을 입력해주세요.');
                return;
            }

            const fullURL = `ws://${serverIP}${socketURL}`;
            websocket = new WebSocket(fullURL);

            websocket.onopen = () => {
                document.getElementById('connectionOutput').textContent = `✔ 연결 성공: ${fullURL}\n`;
                document.getElementById('connectBtn').disabled = true;
                document.getElementById('disconnectBtn').disabled = false;
            };

            websocket.onmessage = (event) => {
                const data = JSON.parse(event.data);

                // 새로운 div를 생성하여 줄바꿈을 처리
                const newMessage = document.createElement('div');
                newMessage.textContent = `${JSON.stringify(data, null, 2)}`;
                document.getElementById('dataOutput').appendChild(newMessage);

                document.getElementById('lineOutput').textContent += `${JSON.stringify(data)}\n\n`;
            };

            websocket.onerror = (error) => {
                const errorMsg = `❌ 오류 발생: ${error.message || error}\n`;
                document.getElementById('connectionOutput').textContent += errorMsg;
            };

            websocket.onclose = () => {
                document.getElementById('connectionOutput').textContent = '❌ 연결 종료\n';
                document.getElementById('connectBtn').disabled = false;
                document.getElementById('disconnectBtn').disabled = true;
            };
        });

        document.getElementById('disconnectBtn').addEventListener('click', () => {
            if (websocket) {
                websocket.close();
            }
        });

        document.getElementById('clearBtn').addEventListener('click', () => {
            document.getElementById('connectionOutput').textContent = '';
            document.getElementById('dataOutput').innerHTML = '';
            document.getElementById('lineOutput').textContent = '';
        });
    </script>
</body>
</html>
```