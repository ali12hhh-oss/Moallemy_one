import 'package:flutter/material.dart';
import '../../data/content_v11.dart';
import '../../core/audio/voice_service.dart';

class ExpandedWordBankScreen extends StatefulWidget {
  const ExpandedWordBankScreen({super.key});
  @override State<ExpandedWordBankScreen> createState() => _ExpandedWordBankScreenState();
}

class _ExpandedWordBankScreenState extends State<ExpandedWordBankScreen> {
  String letter = 'الكل';
  String category = 'الكل';
  @override Widget build(BuildContext context) {
    final letters = ['الكل','أ','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص','ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','ه','و','ي'];
    final categories = ['الكل','حيوانات','طعام','منزل','مدرسة','طبيعة','جسم','مواصلات','مهن','ملابس','أشياء'];
    final list = arabicWordsV11.where((x)=> (letter=='الكل'||x.letter==letter) && (category=='الكل'||x.category==category)).toList();
    return Directionality(textDirection:TextDirection.rtl,child:Scaffold(
      appBar:AppBar(title:Text('الكلمات والصور (${list.length})')),
      body:Column(children:[
        _chips(letters,(x)=>setState(()=>letter=x)),
        _chips(categories,(x)=>setState(()=>category=x)),
        Expanded(child:GridView.builder(padding:const EdgeInsets.all(12),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,childAspectRatio:.98,crossAxisSpacing:10,mainAxisSpacing:10),itemCount:list.length,itemBuilder:(_,i){final x=list[i];return Card(child:InkWell(onTap:()=>VoiceService.arabic(x.word),borderRadius:BorderRadius.circular(22),child:Padding(padding:const EdgeInsets.all(10),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(x.emoji,style:const TextStyle(fontSize:42)),Text(x.word,style:const TextStyle(fontSize:21,fontWeight:FontWeight.bold),textAlign:TextAlign.center),Text('الصوت: ${x.phoneme}',style:const TextStyle(fontSize:16)),Text(x.category,style:TextStyle(color:Theme.of(context).colorScheme.primary)),IconButton(onPressed:()=>VoiceService.arabic(x.word),icon:const Icon(Icons.volume_up))]))));})),
      ]),
    ));
  }
  Widget _chips(List<String> items,void Function(String) onTap)=>SingleChildScrollView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),child:Row(children:items.map((x)=>Padding(padding:const EdgeInsets.symmetric(horizontal:3),child:ChoiceChip(label:Text(x),selected:(x==letter||x==category),onSelected:(_)=>onTap(x)))).toList()));
}
