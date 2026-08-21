
class ExamSectionV21 {
  final String id,title;
  final int questions;
  const ExamSectionV21(this.id,this.title,this.questions);
}
class ExamV21 {
  final int grade;
  final List<ExamSectionV21> sections;
  const ExamV21(this.grade,this.sections);
}
const examsV21 = <ExamV21>[
  ExamV21(0,[ExamSectionV21('arabic_letters','الحروف العربية',10),ExamSectionV21('reading','القراءة',10),ExamSectionV21('numbers','الأعداد',10)]),
  ExamV21(1,[ExamSectionV21('arabic','العربية',15),ExamSectionV21('math','الرياضيات',15),ExamSectionV21('english','الإنجليزية',10)]),
  ExamV21(2,[ExamSectionV21('arabic','العربية',20),ExamSectionV21('math','الرياضيات',20),ExamSectionV21('english','الإنجليزية',15)]),
  ExamV21(3,[ExamSectionV21('arabic','العربية',25),ExamSectionV21('math','الرياضيات',25),ExamSectionV21('english','الإنجليزية',20)]),
];
