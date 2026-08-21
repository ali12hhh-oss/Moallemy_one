import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/curriculum_v8.dart';

class SkillProgressV9 {
  final String skillId;
  final int attempts;
  final int correct;
  final int streak;
  final DateTime? lastSeen;
  const SkillProgressV9({required this.skillId, required this.attempts, required this.correct, required this.streak, this.lastSeen});

  double get mastery => attempts == 0 ? 0 : correct / attempts;
  bool get needsReview => attempts > 0 && mastery < .8;

  Map<String,dynamic> toMap()=>{'attempts':attempts,'correct':correct,'streak':streak,'lastSeen':lastSeen?.toIso8601String()};
  factory SkillProgressV9.fromMap(String id, Map<String,dynamic> m)=>SkillProgressV9(
    skillId:id, attempts:(m['attempts']??0) as int, correct:(m['correct']??0) as int,
    streak:(m['streak']??0) as int, lastSeen:m['lastSeen']==null?null:DateTime.tryParse(m['lastSeen'].toString()));
}

class LearningRecommendationV9 {
  final String type, title, reason, icon;
  final String? unitId, skill;
  const LearningRecommendationV9({required this.type,required this.title,required this.reason,required this.icon,this.unitId,this.skill});
}

class AdaptiveLearningEngineV9 {
  static const _key='daleel_learning_engine_v9';
  static Future<Map<String,dynamic>> _load() async {
    final p=await SharedPreferences.getInstance();
    final raw=p.getString(_key);
    return raw==null?{}:Map<String,dynamic>.from(jsonDecode(raw) as Map);
  }
  static Future<void> _save(Map<String,dynamic> data) async {
    final p=await SharedPreferences.getInstance();
    await p.setString(_key,jsonEncode(data));
  }

  static Future<void> recordAnswer({required String stageId, required String skill, required bool correct}) async {
    final data=await _load();
    final stages=Map<String,dynamic>.from(data['stages']??{});
    final stage=Map<String,dynamic>.from(stages[stageId]??{});
    final skills=Map<String,dynamic>.from(stage['skills']??{});
    final old=SkillProgressV9.fromMap(skill,Map<String,dynamic>.from(skills[skill]??{}));
    final next=SkillProgressV9(skillId:skill,attempts:old.attempts+1,correct:old.correct+(correct?1:0),streak:correct?old.streak+1:0,lastSeen:DateTime.now());
    skills[skill]=next.toMap(); stage['skills']=skills; stages[stageId]=stage; data['stages']=stages;
    await _save(data);
  }

  static Future<Map<String,SkillProgressV9>> skills(String stageId) async {
    final data=await _load();
    final stage=Map<String,dynamic>.from(Map<String,dynamic>.from(data['stages']??{})[stageId]??{});
    final raw=Map<String,dynamic>.from(stage['skills']??{});
    return raw.map((k,v)=>MapEntry(k,SkillProgressV9.fromMap(k,Map<String,dynamic>.from(v))));
  }

  static Future<List<String>> weakSkills(String stageId) async {
    final all=await skills(stageId);
    final weak = all.values.where((x) => x.needsReview).toList()
      ..sort((a, b) => a.mastery.compareTo(b.mastery));
    return weak.map((x) => x.skillId).toList();
  }

  static Future<bool> isStageReady(CurriculumStageV8 stage, Set<String> completedUnits) async {
    if(stage.units.isEmpty || !stage.units.every((u)=>completedUnits.contains(u.id))) return false;
    final weak=await weakSkills(stage.id);
    return weak.isEmpty;
  }

  static Future<List<LearningRecommendationV9>> recommendations(CurriculumStageV8 stage, Set<String> completedUnits) async {
    final out=<LearningRecommendationV9>[];
    final weak=await weakSkills(stage.id);
    for(final skillId in weak.take(3)) {
      out.add(LearningRecommendationV9(type:'review',title:'مراجعة $skillId',reason:'هذه المهارة تحتاج تدريباً إضافياً',icon:'🔄',skill:skillId));
    }
    for(final u in stage.units) {
      if(!completedUnits.contains(u.id)) {
        out.add(LearningRecommendationV9(type:'next',title:u.title,reason:'الدرس التالي في مسارك',icon:u.icon,unitId:u.id));
        break;
      }
    }
    if(out.isEmpty) out.add(const LearningRecommendationV9(type:'mastery',title:'أنت جاهز للاختبار النهائي',reason:'أتقنت دروس المرحلة والمهارات المسجلة',icon:'🏆'));
    return out;
  }

  static Future<double> stageMastery(CurriculumStageV8 stage) async {
    final all=await skills(stage.id);
    if(all.isEmpty) return 0;
    return all.values.fold<double>(0,(s,x)=>s+x.mastery)/all.length;
  }

  static Future<void> recordUnitPractice(String stageId,String unitId,String skill) async {
    final data=await _load();
    final practice=Map<String,dynamic>.from(data['practice']??{});
    final key='$stageId:$unitId:$skill';
    practice[key]=(practice[key]??0)+1;
    data['practice']=practice;
    await _save(data);
  }
}
