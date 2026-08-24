class RewardItemV23 {
  final String id, title, type, image;
  final int price;
  const RewardItemV23(this.id, this.title, this.type, this.price, this.image);
}

const rewardsV23 = <RewardItemV23>[
  RewardItemV23('badge_reader', 'وسام القارئ الصغير', 'أوسمة', 20, 'assets/images/store/badge_reader.svg'),
  RewardItemV23('badge_math', 'وسام بطل الرياضيات', 'أوسمة', 35, 'assets/images/store/badge_math.svg'),
  RewardItemV23('badge_english', 'وسام نجم English', 'أوسمة', 35, 'assets/images/store/badge_english.svg'),
  RewardItemV23('character_cat', 'شخصية القطة المرحة', 'شخصيات', 80, 'assets/images/store/character_cat.svg'),
  RewardItemV23('character_bird', 'شخصية العصفور السريع', 'شخصيات', 90, 'assets/images/store/character_bird.svg'),
  RewardItemV23('character_runner', 'شخصية الرياضي الصغير', 'شخصيات رياضية', 120, 'assets/images/store/character_runner.svg'),
  RewardItemV23('sports_ball', 'كرة البطل الرياضية', 'رسومات رياضية', 70, 'assets/images/store/sports_ball.svg'),
  RewardItemV23('sports_champion', 'شارة البطل الرياضي', 'رسومات رياضية', 140, 'assets/images/store/sports_champion.svg'),
  RewardItemV23('hat_star', 'قبعة النجمة', 'إكسسوارات', 60, 'assets/images/store/hat_star.svg'),
  RewardItemV23('room_space', 'غرفة الفضاء', 'خلفيات', 180, 'assets/images/store/room_space.svg'),
  RewardItemV23('title_super_learner', 'لقب المتعلم الخارق', 'ألقاب', 250, 'assets/images/store/title_super_learner.svg'),
  RewardItemV23('title_champion', 'لقب بطل الأبطال', 'ألقاب', 400, 'assets/images/store/title_champion.svg'),
];
