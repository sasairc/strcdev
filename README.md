strcdev
=======
![default](http://41.media.tumblr.com/5e4ee6e035e90d81f798d57a848f0b7d/tumblr_ngwvpbQcPA1u2jamko1_1280.png)   

お好みのテキストファイルから改行区切りで配列を生成し、ランダムに出力するキャラクタデバイスドライバです。	

#### Requirements
* Linux Kernel 3.x  
3.18および、3.2.0(Debian Generic)にて動作を確認しています。		
新しい機能等は使っていないので、未確認ではありますが、2.6系でも動作するかと思います。

* Linux headers   
	* Debian GNU/Linux	
	  Debianでgeneric kernelを利用しているのであれば	  
	  `# apt-get install linux-headers-$(uname -r)`  
	  を実行すればインストールできます。
		
	* 環境問わず自前のカーネルを使ってる方	
		自前でビルドしたカーネルを使っている方は、カーネルソースのトップディレクトリへ移動し	
		`# make headers_install`を実行してください。

	* RedHat派生含むその他ディストリビューション	
		ごめんなさい。手元にないので詳しい方法は分かりません。	
		

* GNU Compiler Collection(gcc)	
	gcc 4.7.2で確認しましたが、特にバージョン依存はないかと。

* GNU bash	

#### Build
* `% ./bootstrap.sh sample_text/yasuna.txt`を実行します。（ファイル名は適時置き換えてください） 
	* 空行が削除され`yasuna.txt.tmp`が生成されます。  
	* 生成された`yasuna.txt.tmp`をもとに、次のような配列に変換され	
		`convert.txt`として保存されます。
	```
		char* str[] = {
			"エッ エッ",
			"へんし・・・",
			"ちかんなんて滅びればいい",
			"あっあっ！！　くそう！ くそう！！",
			"ひゅ―――！！",
			"ひゃ――――――",
			"ああ・・・海が呼んでる・・・",
			（略）
			"ああああ ありがとうございますありがとうございます"
		};
	```
	* 最終的に`strcdev.c.orig`の所定の行に`convert.txt`が挿入され、`strcdev.c`が生成されます。

* モジュールのビルド	
`make`を実行します。

#### Install	
* インストールしたい	
	Makefileの`PREFIX`変数でインストール先の設定してください。  
	デフォルトでは`/lib/modules/$(shell uname -r)/kernel/drivers/block`です。   
	`# make install`でモジュールのコピーとmknodが実行されます。

* インストールせずに使いたい  
	`# make mknod`で、スペシャルファイルのみ作成されます。	
	削除する場合は、`# make rmnod`を実行してください。

#### Usage
* モジュールのロード  
```
# insmod /lib/modules/`uname -r`/kernel/drivers/block/strcdev.ko
```
* モジュールのアンロード  
```
# rmmod strcdev
```

#### Digression
ただ、このままではリブート後に`/dev/strcdev`が消滅（自動作成されない）してしまいます。     
それを悲しく思う方は、udevにデバイス管理を依頼する	
または`/etc/rc.local`などの起動スクリプトに    

```
insmod /lib/modules/`uname -r`/kernel/drivers/block/strcdev.ko
mknod /dev/strcdev c 250 0
chmod 0666 /dev/strcdev
```
のような記述すると良いかもしれません。   

#### License  
[どうとでも勝手にしやがれクソッタレ・公衆利用許諾書(WTFPL Version 2)] (http://www.wtfpl.net/txt/copying/)
