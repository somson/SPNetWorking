# SPNetWorking

借鉴了前辈的网络层设计方案思想，感谢jianhttp://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html

采用离散型的思想通过代理的方式，对网络层进行了设计。

1、通过dataSource来获取请求的条件参数
2、在接口请求的过程中进行一系列验证、拦截
3、通过delegate对请求结果进行处理
4、对数据进行网络缓存与本地缓存
5、最大的优点：逻辑清晰，对网络请求过程可控
