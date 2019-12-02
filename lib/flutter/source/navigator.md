 Navigator 无context研究

​    https://juejin.im/post/5d6b5f31f265da03b76b38b9

​     navigator的标准写法

     ```dart
Navigator.of(context).push();
     ```

​     Navigator.of(context)的目的是拿到NavigatorState，如果能拿到全局的NavigatorState就可以实现无context了。整个material app的源码里Navigator widget只有一个，同时只存在一个NavigatorState，理论上是可行。

​    那么问题来了，你也看过源码吧，怎么想不到这个？？？

  实现方式

​       1   MaterialApp可以设置一个navigatorKey，通过GloableKey的形式设置navigatorKey找到CurrentState也即是NavigatorState，然后执行跳转方法

​       2  NavigatorObserver

​           NavigatorObserver中持有变量navigator

                ```dart
NavigatorState get navigator => _navigator
                ```

​           NavigatorObserver 的设置方式MaterialApp中的navigatorObservers

​       3  扩展ServiceLocator

​           https://juejin.im/post/5d1daadbe51d457759648755