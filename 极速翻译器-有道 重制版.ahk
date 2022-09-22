#SingleInstance Force
SetBatchLines, -1
CoordMode, ToolTip, Screen

#Persistent
OnClipboardChange("ClipChanged")
return
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
Thread, Interrupt ,0

; text = Whether 60 or 16, there is in every human being’s heart the lure of wonders, the unfailing appetite for what’s next and the joy of the game of living. In the center of your heart and my heart, there is a wireless station so long as it receives messages of beauty, hope, courage and power from man and from the infinite, so long as you are young.When your aerials are down, and your spirit is covered with snows of cynicism and the ice of pessimism, then you’ve grown old, even at 20 but as long as your aerials are up, to catch waves of optimism, there’s hope you may die young at 80.
; msgbox % youdao_translation(remove_punctuation(text))
~LButton Up::
Send ^{c}
ClipChanged(1){
text = % youdao_translation(remove_punctuation(Clipboard))
If (StrLen(text)>=70){
    i := 1
    Loop, % StrLen(text)/70+1{
        text1 .= SubStr(text, i, 70)
        text1 .= "`n"
        i += 70
    }

}

    Else text1 := text


ret := btt(text1,,,,,{JustCalculateSize:1})
btt(text1,(1720-ret.w)/2,1015-ret.h,,"Style2")

; ret := btt(text,,,,,{JustCalculateSize:1})
; MsgBox, % "宽：" ret.w " 高：" ret.h
Return
}



;翻译主函数
youdao_translation(text){
    Url=http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=null
    postdata=type=AUTO&i=%text%&doctype=json&xmlVersion=1.4&keyfrom=fanyi.web&ue=UTF-8&typoResult=true&flag=false
    youdaoreText:= byteToStr(WinHttp(Url,"POST",postdata),"utf-8")
    NeedleRegEx=O)tgt":"(.*?)"
    FoundPos:=RegExMatch(youdaoreText,NeedleRegEx,OutMatch)
    youdaoValue:=(ErrorLevel) ? :OutMatch.Value(1)
    NeedleRegEx=O)entries":["","(.*?)"
    FoundPos:=RegExMatch(youdaoreText,NeedleRegEx,OutMatch)
    youdaoValue.=(! ErrorLevel and OutMatch.Value(1)="") ? :
    Return youdaoValue
}

;发送接收数据
WinHttp(Httpurl,Httpmode="GET",Httppostdata=""){
    StringUpper Httpmode,Httpmode
    ;~ XMLHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    XMLHTTP := ComObjCreate("Microsoft.XMLHTTP")
    XMLHTTP.open(Httpmode,Httpurl,false)
    XMLHTTP.setRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0")
    if Httpmode=POST
    {
        XMLHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        XMLHTTP.send(Httppostdata)
    }else
        XMLHTTP.send()
    ;~ return XMLHTTP.responseText
    return XMLHTTP.ResponseBody
}
 
;将原始数据流以指定的编码的形式读出
byteToStr(body, charset){
    Stream := ComObjCreate("Adodb.Stream")
    Stream.Type := 1
    Stream.Mode := 3
    Stream.Open()
    Stream.Write(body)
    Stream.Position := 0
    Stream.Type := 2
    Stream.Charset := charset
    str := Stream.ReadText()
    Stream.Close()
    return str
}

;去除文本中的标点
remove_punctuation(text){
    punctuation := [",", ".", "!", "`n", "?", """", ";"]
    For k, v in punctuation{
        text1 := StrReplace(text, v, " ")
        text := text1
    }
    Return text
}