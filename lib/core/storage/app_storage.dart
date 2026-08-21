import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/child.dart';
class AppStorage{
 static const childrenKey='daleel_children_v3',activeKey='daleel_active_v3';
 static Future<List<Child>> getChildren()async{final p=await SharedPreferences.getInstance();final raw=p.getString(childrenKey);if(raw==null)return [];return (jsonDecode(raw) as List).map((e)=>Child.fromMap(Map<String,dynamic>.from(e))).toList();}
 static Future<void> saveChildren(List<Child> c)async{final p=await SharedPreferences.getInstance();await p.setString(childrenKey,jsonEncode(c.map((e)=>e.toMap()).toList()));}
 static Future<String?> activeId()async=>(await SharedPreferences.getInstance()).getString(activeKey);
 static Future<void> setActive(String id)async{await (await SharedPreferences.getInstance()).setString(activeKey,id);}
 static Future<void> clearAll()async{final p=await SharedPreferences.getInstance();await p.remove(childrenKey);await p.remove(activeKey);}
}
