class PostReaction {

  int id_post;
  int total;
  int subscriber_reaction;
  List<int> top_reactions = [];

  static final int REACTION_LIKE = 1;
  static final int REACTION_LOVE = 2;
  static final int REACTION_REDCARD = 3;
  static final int REACTION_GOAL = 4;
  static final int REACTION_OFFSIDE = 5;
  static final int REACTION_ANGRY = 6;


  PostReaction(this.id_post, this.total, this.subscriber_reaction,
      this.top_reactions);

  static PostReaction getFromMap(Map item){
    int id_post = int.parse(item['id_post']);
    int total = int.parse(item['total']);
    int subscriber_reaction = int.parse(item['subscriber_reaction']);
    List<int> top_reactions = [];

    item['top_reactions'].forEach((result){

      int reaction_type = int.parse(result['reaction_type']);
      top_reactions.add(reaction_type);

    });

    PostReaction postReaction = new PostReaction(id_post, total, subscriber_reaction,
        top_reactions);

    return postReaction;
  }


}