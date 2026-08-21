
import 'package:shared_preferences/shared_preferences.dart';

class MathSkillsEngineV14 {
  static const _key = 'math_skills_v14';

  static Future<Map<String,int>> _load() async {
    final p=await SharedPreferences.getInstance();
    final list=p.getStringList(_key)??[];
    final out=<String,int>{};
    for(final x in list){
      final a=x.split(':');
      if(a.length==2) out[a[0]]=int.tryParse(a[1])??0;
    }
    return out;
  }

  static Future<void> _save(Map<String,int> m) async {
    final p=await SharedPreferences.getInstance();
    await p.setStringList(_key,m.entries.map((e)=>'${e.key}:${e.value}').toList());
  }

  static Future<void> record(String skillId,{required bool correct}) async {
    final m=await _load();
    var value=m[skillId]??0;
    value += correct?10:-5;
    if(value<0)value=0;
    if(value>100)value=100;
    m[skillId]=value;
    await _save(m);
  }

  static Future<int> mastery(String skillId) async =>
      (await _load())[skillId]??0;

  static Future<List<String>> weakSkills(Iterable<String> ids) async {
    final m=await _load();
    return ids.where((id)=>(m[id]??0)<80).toList();
  }
}
