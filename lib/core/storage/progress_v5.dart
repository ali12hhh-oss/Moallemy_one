
import 'dart:convert'; import 'package:shared_preferences/shared_preferences.dart';
class ProgressV5{
 static const key='daleel_v5_state';
 static Future<Map<String,dynamic>> load()async{final p=await SharedPreferences.getInstance();final x=p.getString(key);return x==null?{}:Map<String,dynamic>.from(jsonDecode(x));}
 static Future<void> save(Map<String,dynamic> s)async{final p=await SharedPreferences.getInstance();await p.setString(key,jsonEncode(s));}
 static Future<int> stars()async=>((await load())['stars']??0) as int;
 static Future<bool> lessonDone(String id)async=>List<String>.from((await load())['done']??[]).contains(id);
 static Future<void> finishLesson(String id,int reward)async{final s=await load();final d=List<String>.from(s['done']??[]);if(!d.contains(id)){d.add(id);s['stars']=(s['stars']??0)+reward;}s['done']=d;await save(s);}
 static Future<bool> buy(String id,int price)async{final s=await load();final stars=(s['stars']??0) as int;if(stars<price)return false;final bought=List<String>.from(s['bought']??[]);if(bought.contains(id))return true;s['stars']=stars-price;bought.add(id);s['bought']=bought;await save(s);return true;}
}
