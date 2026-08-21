
class RewardItemV23 {
  final String id,title,type;
  final int price;
  const RewardItemV23(this.id,this.title,this.type,this.price);
}
const rewardsV23 = <RewardItemV23>[
  RewardItemV23('badge_reader','وسام القارئ الصغير','وسام',20),
  RewardItemV23('pet_cat','قطة لطيفة','حيوان',50),
  RewardItemV23('pet_bird','عصفور سعيد','حيوان',60),
  RewardItemV23('hat_star','قبعة النجمة','ملابس',40),
  RewardItemV23('room_space','غرفة الفضاء','خلفية',100),
  RewardItemV23('title_hero','لقب بطل التعلم','لقب',150),
];
