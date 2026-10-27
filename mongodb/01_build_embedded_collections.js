// 01 - Build the embedded collections for database_b from the referenced collections in database_a
// Run in mongosh (or paste each pipeline into MongoDB Compass's aggregation builder), in this order.

// Answers_emb: each answer with its related documents embedded
db.Answers.aggregate(
[
  {
    $lookup:
      {
        from: "Questions",
        localField: "parent_id",
        foreignField: "id",
        as: "question"
      }
  },
  {
    $lookup:
      {
        from: "Comments",
        localField: "id",
        foreignField: "post_id",
        as: "comments"
      }
  },
  {
    $unwind:
      {
        path: "$question",
        preserveNullAndEmptyArrays: false
      }
  },
  {
    $out:
      {
        db: "database_b",
        coll: "Answers_emb"
      }
  }
]
);

// Questions_emb: each question with its related documents embedded
db.Questions.aggregate(
[
  {
    $lookup:
      {
        from: "Users",
        localField: "owner_user_id",
        foreignField: "id",
        as: "user"
      }
  },
  {
    $lookup:
      {
        from: "Answers_emb",
        localField: "accepted_answer_id",
        foreignField: "id",
        as: "accepted_answer"
      }
  },
  {
    $lookup:
      {
        from: "Comments",
        localField: "id",
        foreignField: "post_id",
        as: "comments"
      }
  },
  {
    $project:
      {
        id: 1,
        title: 1,
        body: 1,
        accepted_answer_id: 1,
        answer_count: 1,
        comment_count: 1,
        creation_date: 1,
        favorite_count: 1,
        last_activity_date: 1,
        last_edit_date: 1,
        last_editor_user_id: 1,
        owner_user_id: 1,
        post_type_id: 1,
        score: 1,
        tags: 1,
        view_count: 1,
        user: 1,
        comments: 1,
        accepted_answer: {
          $cond: {
            if: {
              $eq: [
                {
                  $size: "$accepted_answer"
                },
                0
              ]
            },
            then: null,
            else: {
              $arrayElemAt: [
                "$accepted_answer",
                0
              ]
            }
          }
        }
      }
  },
  {
    $unwind:
      {
        path: "$user",
        preserveNullAndEmptyArrays: false
      }
  },
  {
    $out:
      {
        db: "database_b",
        coll: "Questions_emb"
      }
  }
]
);

// Badges_emb: each badge with its related documents embedded
db.Badges.aggregate(
[
  {
    $lookup:
      {
        from: "Users",
        localField: "user_id",
        foreignField: "id",
        as: "user"
      }
  },
  {
    $unwind:
      {
        path: "$user",
        preserveNullAndEmptyArrays: false
      }
  },
  {
    $out:
      {
        db: "database_b",
        coll: "Badges_emb"
      }
  }
]
);

// Comments_emb: each comment with its related documents embedded
db.Comments.aggregate(
[
  {
    $lookup:
      {
        from: "Users",
        localField: "user_id",
        foreignField: "id",
        as: "user"
      }
  },
  {
    $unwind:
      {
        path: "$user",
        preserveNullAndEmptyArrays: false
      }
  },
  {
    $out:
      {
        db: "database_b",
        coll: "Comments_emb"
      }
  }
]
);
