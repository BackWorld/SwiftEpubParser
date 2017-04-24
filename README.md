# SwiftEpubParser
A easy and simple kit for epub file parsing with Swift 3.0.

###关于EPub

> EPub（**Electronic Publication**）的缩写，意为电子出版物

> EPub于2007年9月成为国际数位出版论坛（IDPF）的正式标准，以取代旧的开放Open eBook电子书标准。EPub包括三项主要规格：
- 开放出版结构（Open Publication Structure，OPS）2.0，以定义内容的版面；
- 开放包裹格式（Open Packaging Format，OPF）2.0，定义以XML为基础的.[epub](http://baike.baidu.com/item/epub)档案结构；
- OEBPS容纳格式（OEBPS Container Format，OCF）1.0，将所有相关文件收集至ZIP压缩档案之中。

> 更多知识前往官网：http://epubzone.org

![文件基本结构](http://upload-images.jianshu.io/upload_images/1334681-f4dd758f9c091123.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###效果：

![目录结构](http://upload-images.jianshu.io/upload_images/1334681-e47b4d7fc5bd9009.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###要求：
- Platform: iOS8.0+ 
- Language: Swift3.0
- Editor: Xcode8

###用法：
> 由于epub的解压和解析用到了第三方库，所以得更新carthage
使用`cd 到demo工程目录下`，然后执行`carthage update --platform iOS`

> 关于Carthage安装使用等更多知识：https://github.com/Carthage/Carthage

```
// 打开epub - 包括文件解压解析等过程
let url = Bundle.main.url(forResource: "demo.epub", withExtension: nil)!
let dest = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents")

EpubKit.open(epub: url, destination: dest)
{ (model, error) in
     print(error ?? "Epub file is opened successfully")
     // model即为整个epub文件的所有解析内容
}
```

###数据模型
```
class EpubContentModel: NSObject {
    var bookType: EpubBookType = .unknown
    var bookEncryption: EpubBookEncryption = .none
    
    var metadata: EpubMetadata? //元数据信息-包括作者、标题等
    var coverURL: URL? //封面文件/图
    var manifest: [String: EpubManifestItem]? //清单配置文件
    var spines: [String]? //书脊
    var guides: [String]? //阅读向导
    var catalog: [EpubCatalogItem]? //目录
    var isRTL = false //版式布局还是流式布局
}
```

> 如果对你有帮助，别忘了点个❤️哦。
