import 'package:flutter/material.dart';
import '../../data/curriculum_v8.dart';
import '../../core/learning/adaptive_learning_engine_v9.dart';
import '../../core/localization/arabic_numbers.dart';

class LearningPlanScreenV9 extends StatefulWidget {
  final CurriculumStageV8 stage;
  final Set<String> completedUnits;
  const LearningPlanScreenV9({super.key,required this.stage,required this.completedUnits});
  @override State<LearningPlanScreenV9> createState()=>_LearningPlanScreenV9State();
}
class _LearningPlanScreenV9State extends State<LearningPlanScreenV9>{
  List<LearningRecommendationV9> rec=[]; double mastery=0; Map<String,SkillProgressV9> skills={};
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {final r=await AdaptiveLearningEngineV9.recommendations(widget.stage,widget.completedUnits); final m=await AdaptiveLearningEngineV9.stageMastery(widget.stage); final s=await AdaptiveLearningEngineV9.skills(widget.stage.id); if(mounted)setState((){rec=r;mastery=m;skills=s;});}
  @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
    appBar:AppBar(title:const Text('خطة تعلمك الذكية')),
    body:ListView(padding:const EdgeInsets.all(16),children:[
      Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(widget.stage.title,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),Text('مستوى الإتقان: ${arNum((mastery*100).round())}٪'),const SizedBox(height:8),LinearProgressIndicator(value:mastery,minHeight:10),
      ]))),
      const SizedBox(height:16),const Text('ماذا تتعلم الآن؟',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),const SizedBox(height:8),
      ...rec.map((r)=>Card(child:ListTile(leading:Text(r.icon,style:const TextStyle(fontSize:30)),title:Text(r.title),subtitle:Text(r.reason)),)),
      const SizedBox(height:16),const Text('إتقان المهارات',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),const SizedBox(height:8),
      ...skills.values.map((s)=>Card(child:ListTile(title:Text(s.skillId),subtitle:LinearProgressIndicator(value:s.mastery),trailing:Text('${arNum((s.mastery*100).round())}٪')))),
      if(skills.isEmpty) const Card(child:Padding(padding:EdgeInsets.all(16),child:Text('لم نسجل إجابات كافية بعد. ابدأ الدروس والاختبارات القصيرة ليبني التطبيق خطة مناسبة لك.'))),
    ])));
}
