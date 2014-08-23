do ->
  Mock.mockjax = (module) ->
    class Item
      add: (url) ->
        for k, v of Mock._mocked
          if k is url
            return @[url] = Mock.mock v.template

    try
      module.config ($httpProvider) ->
        item = new Item()

        $httpProvider.interceptors.push ->
          return {
          request: (config) ->
            # 添加链接到缓存区
            item.add config.url
            if item[config.url] then config.url = "?mockUrl=#{config.url}"

            return config

          response: (response) ->
            # 拦截输出缓存区的数据
            url = response.config.url.substr 9
            if item[url] then response.data = item[url]

            return response
          }
    catch error
      console.error '生成mock.angular失败，例：var app = angular.module("app", []); Mock.mockjax(app);'