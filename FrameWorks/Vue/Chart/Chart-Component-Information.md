## Components information

**차트 컴포넌트 목록**

- BarChart
- DoughnutChart
- LineChart
- PieChart
- PolarAreaChart
- RadarChart
- BubbleChart
- ScatterChart

<br>

**모든 컴포넌트 props**

|Prop|Type|Default|
|---|---|---|
|'chartData'|ChartJs.ChartData||
|'options'|ChartJs.ChartOptions||
|'plugins'|ChartJs.Plugin[]||
|'cssClasses'|string||
|'width'|number|400|
|'height'|number|400|
|'onChartRender'|(chartInstance: Chart) => void||
|'onChartUpdate'|(chartInstance: Chart) => void||
|'onChartDestroy'|() => void||
|'onLabelsUpdate'|() => void||

<br>

**참조로 접근할 수 있는 데이터**

|Prop|Type|
|---|---|
|'chartInstance'|Chart|
|'canvasRef'|HtmlCanvasElement|
|'renderChart'|() => void|

<br>

**모든 컴포넌트에서 발생시킬 수 있는 이벤트 Emits**

|Event|Payload|
|---|---|
|'chart:render'|chartInstance: Chart|
|'chart:update'|chartInstance: Chart|
|'chart:destroy'|-|
|'labels:update'|-|
