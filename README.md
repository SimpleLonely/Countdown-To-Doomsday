# Countdown-To-Doomsday
人类生存倒计时
## 项目简介
因为关注了全球变暖的话题，就觉得日常生活的烦恼，在全球变暖可能导致的灾难面前简直不值一提。而这个星球的绝大多数人们并没有意识到、或者说并没有打算，为延续人类的生存做些什么。
于是就想做这么一个APP，让人们看到，如果有成千上万上亿的人和自己一样，每天每月为人类的延续做出一点点微薄的努力，那么地球，可以再为人类提供多久的庇佑。

## 功能特性
首先要在初始档案中填写信息，来和之后作出的改变做出对比，体现出为地球作出的贡献。
首页的温度偏差数据来自于<a>http://www.data.jma.go.jp/cpdinfo/gw_portal/past_ghg_change.html<a>
倒计时的算法来源于<a>http://www.roperld.com/science/globalwarmingmathematics.htm<a> 。
碳足迹的计算方式来源于<a>http://calculator.carbonfootprint.com/calculator.aspx?lang=zh-Hans<a>
计算出的剩余天数，是放大了7百万的结果。

## 环境
使用pods配置依赖。
使用Auth0，Charts，InputKitSwift的外部依赖。

## 目录结构
DataLists里存储了一些初始数据。
Model为数据层。
Controller是每个视图的控制器。

## 开发日志（经验教训）
因为动手之前没有做好足够的框架设计，导致这个大作业写了又重写，写了又重写，数据层改了好几次，因为“面向ddl的集中式”开发，前面写的后面又不记得，多次修改，浪费了很多时间。
下次动手写之前一定好好设计Orz

## 未来计划
1. 把程序的异步情况处理好。对网络请求和GCD Queue进行深入了解。
2. 美化UI。
3. 完善事件，将每日事件和每月事件设置的更细致、具体、丰富。
