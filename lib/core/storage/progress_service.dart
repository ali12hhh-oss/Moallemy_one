import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class ProgressService{
 static const key='daleel_progress_v4';
 static Future<Map<String,dynamic>> load()async{
  final p=await SharedPreferences.getInstance();final raw=p.getString(key);
  return raw==null?{}:Map<String,dynamic>.from(jsonDecode(raw));
 }
 static Future<void> set(String id,Map<String,dynamic> data)async{
  final p=await SharedPreferences.getInstance();final all=await load();all[id]=data;await p.setString(key,jsonEncode(all));
 }
 static Future<void> add(String id,{int stars=0,int lessons=0,int correct=0,int total=0,int minutes=0,String? weak})async{
  final all=await load();final d=Map<String,dynamic>.from(all[id]??{});
  d['stars']=(d['stars']??0)+stars;d['lessons']=(d['lessons']??0)+lessons;d['correct']=(d['correct']??0)+correct;d['total']=(d['total']??0)+total;d['minutes']=(d['minutes']??0)+minutes;
  final w=List<String>.from(d['weak']??[]);if(weak!=null&&!w.contains(weak))w.add(weak);d['weak']=w;
  all[id]=d;final p=await SharedPreferences.getInstance();await p.setString(key,jsonEncode(all));
 }
}
